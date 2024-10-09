# frozen_string_literal: true

class Train
  include Manufacturer
  include InstanceCounter
  include Validators

  TRAINS_TYPE = { pass: 'PassengerTrain', cargo: 'CargoTrain' }.freeze
  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i.freeze

  class << self
    def find(number)
      ObjectSpace.each_object(self).select { |instance| instance.number == number }
    end
  end

  attr_reader :number, :wagons, :current_station_index, :route
  attr_accessor :speed

  def initialize(number, wagons = [])
    @number = number
    @wagons = wagons
    @speed = 0
    validate!
    register_instance
  end

  def add_wagon(wagon)
    raise StandardError, 'Поезд в пути' unless train_standing?

    @wagons << wagon
  end

  def delete_wagon(wagon)
    raise StandardError, 'Поезд остался без вагонов' if @wagons.empty?
    raise StandardError, 'Поезд в пути' unless train_standing?

    @wagons.delete(wagon)
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station.train_arrival(self)
  end

  def move_next_station
    raise StandardError, 'Не задан маршрут' if @route.nil?
    raise StandardError, 'Достигли конца маршрута' if current_station_final?

    current_station.train_departure(self)
    @current_station_index += 1
    current_station.train_arrival(self)
  end

  def move_previous_station
    raise StandardError, 'Не задан маршрут' if @route.nil?
    raise StandardError, 'Достигли начала маршрута' if current_station_initial?

    current_station.train_departure(self)
    @current_station_index -= 1
    current_station.train_arrival(self)
  end

  def find_next_station
    raise StandardError, 'Не задан маршрут' if @route.nil?
    raise StandardError, 'Поезд на конечной станции' if current_station_final?

    @route.stations[@current_station_index + 1]
  end

  def find_previous_station
    raise StandardError, 'Не задан маршрут' if @route.nil?
    raise StandardError, 'Поезд на начальной станции' if current_station_initial?

    @route.stations[@current_station_index - 1]
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def type
    self.class.to_s
  end

  def self.trains_type!(type)
    raise StandardError, 'Выбран несуществющий тип поезда' if TRAINS_TYPE[type].nil?
  end

  def use?(wagon)
    @wagons.include?(wagon)
  end

  def all_wagons(&block)
    raise StandardError, 'Нет вагонов' if @wagons.empty?

    @wagons.each(&block)
  end

  def type
    type = self.class

    if type.is_a?(PassengerTrain)
      'пассажирский'
    elsif type.is_a?(CargoTrain)
      'грузовой'
    end
  end

  private

  def validate!
    raise StandardError, 'Введите корректный номер' if @number !~ NUMBER_FORMAT

    true
  end

  def train_standing?
    @speed.zero?
  end

  def current_station_initial?
    current_station == @route.initial_station
  end

  def current_station_final?
    current_station == @route.final_station
  end
end

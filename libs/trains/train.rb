# frozen_string_literal: true

class Train
  attr_reader :number, :wagons, :current_station_index, :route

  attr_accessor :speed

  def initialize(number, wagons = [])
    @number = number
    @wagons = wagons
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if train_standing?
  end

  def delete_wagon(wagon)
    return 'Поезд остался без вагонов' if @wagons.nil?

    @wagons.delete(wagon) if train_standing?
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station.train_arrival(self)
  end

  def move_next_station
    raise StandardError.new('Не задан маршрут') if @route.nil?
    raise StandardError.new('Достигли конца маршрута') if current_station_final?

    current_station.train_departure(self)
    @current_station_index += 1
    current_station.train_arrival(self)
  end

  def move_previous_station
    raise StandardError.new('Не задан маршрут') if @route.nil?
    raise StandardError.new('Достигли начала маршрута') if current_station_initial?

    current_station.train_departure(self)
    @current_station_index -= 1
    current_station.train_arrival(self)
  end

  def find_next_station
    raise StandardError.new('Не задан маршрут') if @route.nil?
    raise StandardError.new('Поезд на конечной станции') if current_station_final?

    @route.stations[@current_station_index + 1]
  end

  def find_previous_station
    raise StandardError.new('Не задан маршрут') if @route.nil?
    raise StandardError.new('Поезд на начальной станции') if current_station_initial?

    @route.stations[@current_station_index - 1]
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def type
    self.class.to_s
  end

  private

  def train_standing?
    @speed.zero?
  end

  def current_station_initial?
    current_station == @route.initial_station
  end

  def current_station_final?
    current_station == @route.final_station
  end

  def use?(wagon)
    @wagons.include?(wagon)
  end
end

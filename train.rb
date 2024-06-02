# frozen_string_literal: true

class Train
  TYPE = { passenger: 'пассажирский', cargo: 'грузовой' }.freeze

  attr_reader :number, :wagons_number, :current_station_index, :route

  attr_accessor :speed

  def initialize(number, type, wagons_number)
    @number = number
    @type = TYPE[type.to_sym] || 'undefined'
    @wagons_number = wagons_number
    @speed = 0
  end

  def add_wagon
    @wagons_number += 1 if train_standing?
  end

  def delete_wagon
    return 'Поезд остался без вагонов' if @wagons_number.zero?

    @wagons_number -= 1 if train_standing?
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station.train_arrival(self)
  end

  def move_next_station
    return 'не задан маршрут' if @route.nil?
    return 'Достигли конца маршрута' if current_station_final?

    current_station.train_departure(self)
    @current_station_index += 1
    current_station.train_arrival(self)
  end

  def move_previous_station
    return 'не задан маршрут' if @route.nil?
    return 'Достигли начала маршрута' if current_station_initial?

    current_station.train_departure(self)
    @current_station_index -= 1
    current_station.train_arrival(self)
  end

  def find_next_station
    return 'не задан маршрут' if @route.nil?
    return 'Поезд на конечной станции' if current_station_final?

    @route.stations[@current_station_index + 1]
  end

  def find_previous_station
    return 'не задан маршрут' if @route.nil?
    return 'Поезд на начальной станции' if current_station_initial?

    @route.stations[@current_station_index - 1]
  end

  def current_station
    @route.stations[@current_station_index]
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
end

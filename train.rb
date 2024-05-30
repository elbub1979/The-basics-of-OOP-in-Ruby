# frozen_string_literal: true

class Train
  TYPE = { passenger: 'пассажирский', cargo: 'грузовой' }.freeze

  attr_reader :number, :wagons_number, :current_station, :route

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

  def give_route(route)
    @route = route
    @current_station = route.initial_station
  end

  def move_next_station
    return 'не задан маршрут' if @route.nil?
    return 'Достигли конца маршрута' if @current_station == @route.final_station

    @current_station = @route.next_station(@current_station)
  end

  def move_previous_station
    return 'не задан маршрут' if @route.nil?
    return 'Достигли начала маршрута' if @current_station == @route.initial_station

    @current_station = @route.previous_station(@current_station)
  end

  def next_station
    return 'не задан маршрут' if @route.nil?

    @route.next_station(@current_station) || 'Поезд на конечной станции'
  end

  def previous_station
    return 'не задан маршрут' if @route.nil?

    @route.previous_station(@current_station) || 'Поезд на начальной станции'
  end

  private

  def train_standing?
    @speed.zero?
  end
end

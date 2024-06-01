# frozen_string_literal: true

class Route
  attr_reader :initial_station, :final_station

  def initialize(initial_station, final_station)
    @initial_station = initial_station
    @final_station = final_station
    @intermediate_stations = []
  end

  def station_list
    <<-LIST
Список станций маршрута:
#{@initial_station.name}
#{intermediate_stations}
#{@final_station.name}
    LIST
  end

  def add_intermediate_station(station)
    @intermediate_stations << station
  end

  def delete_intermediate_station(station)
    @intermediate_stations.delete(station)
  end

  def next_station(current_station)
    next_station_index = current_station_index(current_station) + 1

    route[next_station_index]
  end

  def previous_station(current_station)
    next_station_index = current_station_index(current_station) - 1

    route[next_station_index]
  end

  private

  def intermediate_stations
    @intermediate_stations.map(&:name).join("\n")
  end

  def route
    [@initial_station, *@intermediate_stations, @final_station].compact
  end

  def current_station_index(current_station)
    route.index(current_station)
  end
end

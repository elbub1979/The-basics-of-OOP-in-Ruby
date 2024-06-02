# frozen_string_literal: true

class Route
  attr_reader :initial_station, :final_station

  def initialize(initial_station, final_station)
    @initial_station = initial_station
    @final_station = final_station
    @intermediate_stations = []
  end

  def stations
    [@initial_station, *@intermediate_stations, @final_station].compact
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

  private

  def intermediate_stations
    @intermediate_stations.map(&:name).join("\n")
  end
end

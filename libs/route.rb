# frozen_string_literal: true

class Route
  include InstanceCounter

  attr_reader :initial_station, :final_station

  def initialize(initial_station, final_station)
    @initial_station = initial_station
    @final_station = final_station
    @intermediate_stations = []
    register_instance
  end

  def stations
    [@initial_station, *@intermediate_stations, @final_station].compact
  end

  def extreme_stations
    [@initial_station, @final_station]
  end

  def add_intermediate_station(*stations)
    @intermediate_stations.concat(stations)
  end

  def delete_intermediate_station(station)
    @intermediate_stations.delete(station)
  end

  def use?(station)
    initial_station.equal?(station) || final_station.equal?(station) ||
      @intermediate_stations
        .any? { |intermediate_station| intermediate_station.equal?(station) }
  end

  private

  def intermediate_stations
    @intermediate_stations.map(&:name).join("\n")
  end
end

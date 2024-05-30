# frozen_string_literal: true

class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def all_trains
    @trains.map(&:number).join("\n")
  end

  def trains_type
    return 'На станции нет поездов' if @trains.empty?

    group_trains = @trains.group_by(&:type)

    <<~TYPES
    На станции находятся:
    #{ group_trains.map { |key, value| "#{key}: #{value.size}" }.join("\n") }
    TYPES
  end

  def train_departure(train)
    @trains.delete(train)
  end

  def train_arrival(train)
    @trains << train
  end
end


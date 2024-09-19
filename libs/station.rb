# frozen_string_literal: true

class Station
  class << self
    def all
      ObjectSpace.each_object(self).each_with_object([]) { |instance, accum| accum << instance }
    end
  end

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def trains_type
    raise StandardError.new('На станции нет поездов') if @trains.empty?

    @trains.group_by(&:type).transform_values(&:size)
  end

  def train_departure(train)
    @trains.delete(train)
  end

  def train_arrival(train)
    @trains << train
  end
end

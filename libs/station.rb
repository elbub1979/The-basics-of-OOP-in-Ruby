# frozen_string_literal: true

# Station class
class Station
  include InstanceCounter
  include Validators

  attr_reader :name, :trains

  class << self
    def all
      ObjectSpace.each_object(self).each_with_object([]) { |instance, accum| accum << instance }
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    register_instance
    validate!
  end

  def trains_type
    raise StandardError, 'На станции нет поездов' if @trains.empty?

    @trains.group_by(&:type).transform_values(&:size)
  end

  def train_departure(train)
    @trains.delete(train)
  end

  def train_arrival(train)
    @trains << train
  end

  def all_trains(&block)
    @trains.each(&block)
  end

  private

  def validate!
    raise StandardError, 'Введите первым символом букву' if @name !~ /^[a-z].*$/i
    raise StandardError, 'Слишком длинное название станции' if name.size > 25
  end
end

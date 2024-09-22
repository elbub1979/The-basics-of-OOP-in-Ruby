# frozen_string_literal: true

# Station class
class Station
  include InstanceCounter
  include Validators

  class << self
    def all
      ObjectSpace.each_object(self).each_with_object([]) { |instance, accum| accum << instance }
    end
  end

  attr_reader :name, :trains

  def initialize(name)
    validate!
    @name = name
    @trains = []
    register_instance
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

  private

  def validate!
    raise StandardError, 'На звание станции не может быть пустым' if name.gsub(/[[:space:]]/, '').empty?
    raise StandardError, 'Введите первым символом букву' unless name =~ /^[a-z]+.+$/i
    raise StandardError, 'Слишком длинное название станции' if name.size > 25
  end
end

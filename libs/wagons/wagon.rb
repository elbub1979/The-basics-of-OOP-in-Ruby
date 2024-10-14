# frozen_string_literal: true

class Wagon
  include Manufacturer
  include Validation

  WAGONS_TYPE = { pass: 'PassengerWagon', cargo: 'CargoWagon' }.freeze
  NUMBER_FORMAT = /^[0-9]{3,}$/

  attr_reader :number, :capacity, :reserve_capacity

  class << self
    def wagons_type!(type)
      raise StandardError, 'Выбран несуществющий тип вагона' if WAGONS_TYPE[type].nil?
    end

    def validate_attributes(object)
      validate(object, :capacity, :length, :minimum, 5)
      validate(object, :number, :presence)
      validate(object, :number, :format, NUMBER_FORMAT)
      validate(object, :capacity, :presence)
    end
  end

  def initialize(number, capacity)
    @number = number
    @reserve_capacity = 0
    @capacity = capacity
    validate!
  end

  def type
    type = self.class

    if type.is_a?(PassengerWagon)
      'пассажирский'
    elsif type.is_a?(CargoWagon)
      'грузовой'
    end
  end
end

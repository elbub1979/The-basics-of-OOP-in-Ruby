class Wagon
  include Manufacturer
  include Validators

  WAGONS_TYPE = { pass: 'PassengerWagon', cargo: 'CargoWagon' }.freeze

  attr_reader :number, :capacity, :reserve_capacity

  def initialize(number, capacity)
    @number = number
    @reserve_capacity = 0
    @capacity = capacity
    validate!
  end

  def self.wagons_type!(type)
    raise StandardError, 'Выбран несуществющий тип вагона' if WAGONS_TYPE[type].nil?
  end

  def type
    type = self.class

    if type.is_a?(PassengerWagon)
      'пассажирский'
    elsif type.is_a?(CargoWagon)
      'грузовой'
    end
  end

  private

  def validate!
    raise StandardError, 'Введите корректный номер' if @number !~ /^[0-9]{3,}$/
    raise StandardError, 'Объем в вагоне не может быть 0' if @capacity.zero?
  end
end

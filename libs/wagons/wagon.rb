class Wagon
  include Manufacturer
  include Validators

  WAGONS_TYPE = { pass: PassengerWagon, cargo: CargoWagon }.freeze

  attr_reader :number

  def initialize(number)
    validate!
    @number = number
  end

  def self.wagons_type!(type)
    raise StandardError, 'Выбран несуществющий тип вагона' if TRAINS_TYPE[type].nil?
  end

  private

  def validate!
    raise StandardError, 'Введите корректный номер' unless name =~ /^[0-9]{3,}$/
  end
end

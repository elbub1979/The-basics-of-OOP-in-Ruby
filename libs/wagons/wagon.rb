class Wagon
  include Manufacturer
  include Validators

  WAGONS_TYPE = { pass: 'PassengerWagon', cargo: 'CargoWagon' }.freeze

  attr_reader :number

  def initialize(number)
    @number = number
    validate!
  end

  def self.wagons_type!(type)
    raise StandardError, 'Выбран несуществющий тип вагона' if WAGONS_TYPE[type].nil?
  end

  private

  def validate!
    raise StandardError, 'Введите корректный номер' if @number !~ /^[0-9]{3,}$/
  end
end

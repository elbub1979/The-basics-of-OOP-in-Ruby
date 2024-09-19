class Wagon
  include Manufacturer

  attr_reader :number

  def initialize(number)
    @number = number
  end
end

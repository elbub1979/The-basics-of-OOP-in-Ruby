class PassengerWagon < Wagon
  attr_reader :seats, :reserve_seats

  def initialize(number, seats)
    @reserve_seats = 0
    @seats = seats
    super(number)
    validate!
  end

  def reserve_seat
    raise StandardError, 'Нет свободных мест' unless available_seats?

    @reserve_seats += 1
  end

  private

  def available_seats?
    @reserve_seats <= @seats
  end

  def validate!
    raise StandardError, 'Мест в вагоне не может быть 0' if @seats.zero?

    super
  end
end

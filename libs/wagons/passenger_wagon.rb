# frozen_string_literal: true

class PassengerWagon < Wagon
  MEASUREMENT_UNIT = 'мест'

  def reservation_capacity
    raise StandardError, 'Нет свободных мест' unless available_seats?

    @reserve_capacity += 1
  end

  private

  def available_seats?
    @reserve_capacity <= @capacity
  end
end

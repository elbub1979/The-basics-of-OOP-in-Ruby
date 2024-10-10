# frozen_string_literal: true

class CargoWagon < Wagon
  MEASUREMENT_UNIT = 'объем'

  def reservation_capacity(capacity)
    raise StandardError, 'Нет свободного места' unless available_volume?(capacity)

    @reserve_capacity += capacity
  end

  private

  def available_volume?(capacity)
    @reserve_capacity + capacity <= @capacity
  end
end

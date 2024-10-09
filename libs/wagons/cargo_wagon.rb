class CargoWagon < Wagon
  MEASUREMENT_UNIT = 'объем'.freeze

  def reservation_capacity(capacity)
    raise StandardError, 'Нет свободного места' unless available_volume?(capacity)

    @reserve_capacity += capacity
  end

  private

  def available_volume?(capacity)
    @reserve_capacity + capacity <= @capacity
  end
end

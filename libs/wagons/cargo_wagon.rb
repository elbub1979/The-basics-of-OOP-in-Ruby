class CargoWagon < Wagon
  attr_reader :volumes, :reserve_volumes

  def initialize(number, volumes)
    @reserve_volume = 0
    @volumes = volumes
    super(number)
    validate!
  end

  def reserve_volume(volume)
    raise StandardError, 'Нет свободного места' unless available_volume?(volume)

    @reserve_volumes += volume
  end

  private

  def available_volume?(volume)
    @reserve_volumes + volume <= @volumes
  end

  def validate!
    raise StandardError, 'Объем в вагоне не может быть 0' if @volumes.zero?

    super
  end
end

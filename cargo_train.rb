class CargoTrain < Train
  def add_wagon(wagon)
    # raise 'Wrong wagon: not cargo' unless wagon.instance_of?(CargoWagon)
    return 'Wrong wagon: not cargo' unless wagon.instance_of?(CargoWagon)

    super
  end
end

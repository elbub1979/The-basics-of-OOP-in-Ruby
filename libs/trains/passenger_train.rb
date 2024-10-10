# frozen_string_literal: true

class PassengerTrain < Train
  def add_wagon(wagon)
    raise 'Wrong wagon: not pass' unless wagon.instance_of?(PassengerWagon)

    # return 'Wrong wagon: not pass' unless wagon.instance_of?(PassengerWagon)

    super
  end
end

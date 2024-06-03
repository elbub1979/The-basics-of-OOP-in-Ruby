# frozen_string_literal: true

require './route'
require './station'
require './train'
require './passenger_train'
require './cargo_train'
require './wagon'
require './passenger_wagon'
require './cargo_wagon'

pass_wagon_1 = PassengerWagon.new('pass wagon 1')
cargo_wagon_1 = CargoWagon.new('cargo wagon 1')
pass_train = PassengerTrain.new('pass train 1')
cargo_train = CargoTrain.new('cargo train 1')
begin
  pass_train.add_wagon(pass_wagon_1)
  pass_train.add_wagon(cargo_wagon_1)
rescue RuntimeError => e
  puts e
  #retry
end

p pass_train

cargo_train.add_wagon(pass_wagon_1)
cargo_train.add_wagon(cargo_wagon_1)

p cargo_train
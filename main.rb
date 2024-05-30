# frozen_string_literal: true

require './route'
require './station'
require './train'

train_1 = Train.new('0001', :passenger, 1)
train_2 = Train.new('0002', :passenger, 2)
train_3 = Train.new('0003', :passenger, 3)

train_4 = Train.new('0004', :cargo, 4)
train_5 = Train.new('0005', :cargo, 5)
train_6 = Train.new('0006', :cargo, 6)

station_1 = Station.new('Станция 1')
station_2 = Station.new('Станция 2')
station_3 = Station.new('Станция 3')
station_4 = Station.new('Станция 4')
station_5 = Station.new('Станция 5')

route = Route.new(station_1, station_4)

#test route
route.add_intermediate_station(station_2)
route.add_intermediate_station(station_3)
route.add_intermediate_station(station_5)
puts route.station_list
route.delete_intermediate_station(station_5)
puts route.station_list

#test train
p train_1
train_1.add_wagon
p train_1
train_1.delete_wagon
p train_1


p train_1.next_station
p train_1.previous_station

p train_1.move_next_station
p train_1.move_previous_station


train_1.give_route(route)

p train_1.route
p train_1.current_station

#p train_1.next_station
#p train_1.previous_station

p train_1.move_next_station
p train_1.move_next_station
p train_1.move_next_station
p train_1.move_next_station
p train_1.move_previous_station
p train_1.move_previous_station
p train_1.move_previous_station
p train_1.move_previous_station


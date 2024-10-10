# frozen_string_literal: true

Dir['./libs/modules/*.rb'].each { |file| require_relative file }
require_relative 'libs/wagons/wagon'
require_relative 'libs/wagons/cargo_wagon'
require_relative 'libs/wagons/passenger_wagon'
require_relative 'libs/trains/train'
require_relative 'libs/trains/cargo_train'
require_relative 'libs/trains/passenger_train'
require_relative 'libs/route'
require_relative 'libs/station'
# require_relative 'libs/modules/instance_counter'

Dir['./menus/*.rb'].each { |file| require_relative file }

class Railway
  include WagonsMenu
  include TrainsMenu
  include StationsMenu
  include RoutesMenu

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def main_menu
    loop do
      puts <<~MAINMENU
        Главное меню (выберите действие)
        1. Станции
        2. Маршруты
        3. Вагоны
        4. Поезда
        5. Выход
      MAINMENU

      begin
        choice = Integer(gets)
      rescue StandardError
        puts('Введите число')
        next
      end

      case choice
      when 1
        stations_menu
      when 2
        routes_menu
      when 3
        wagons_menu
      when 4
        trains_menu
      when 5
        exit
      else
        puts 'Выберите из предложенного'
      end
    end
  end
end

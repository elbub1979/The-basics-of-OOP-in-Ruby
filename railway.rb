require_relative 'libs/route'
require_relative 'libs/station'
require_relative 'libs/trains/train'
require_relative 'libs/trains/cargo_train'
require_relative 'libs/trains/passenger_train'
require_relative 'libs/wagons/wagon'
require_relative 'libs/wagons/cargo_wagon'
require_relative 'libs/wagons/passenger_wagon'

class Railway
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

      choice = Integer(gets)

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

  private

  def stations_menu
    loop do
      puts <<~STATIONMENU
        1. Список станций
        2. Создать станцию
        3. Удалить станцию
        4. Посмотреть поезда на станции
        5. Вернуться
      STATIONMENU

      choice = Integer(gets)

      case choice
      when 1
        stations
      when 2
        create_station
      when 3
        delete_station
      when 4
        stations_trains
      when 5
        exit
      else
        puts 'Выберите один из указанных пунктов меню'
      end
    end
  end

  def stations
    puts @stations.map.with_index { |station, index| "#{index}: #{station.name}" }.join("\n")
  end

  def create_station
    p 'Введите название станции: '
    name = gets.chomp
    @stations << Station.new(name)
  end

  def delete_station
      puts stations
      p 'Выберите станцию: '
      index = Integer(gets)
      station = @stations[index]

      return puts 'Такой станции не существует'  if station.nil?
      return puts 'На станции есть поезда' unless station.trains.empty?

      @stations.delete(station)
      puts 'Станция удалена'
  end

  def stations_trains
    puts stations
    p 'Выберите станцию: '
    index = Integer(gets)
    station = @stations[index]

    return puts 'Такой станции не существует'  if station.nil?

    station.trains.map { |train| "#{train.number}: маршрут #{train.route.initial_station || ''}  - #{train.route.initial_station  || ''}" }.join("\n")
  end


  def routes_menu
    loop do
      puts <<~STATIONMENU
        1. Список маршрутов
        2. Создать маршрут
        3. Удалить маршрут
        5. Добавить промежуточные станции 
        4. Вернуться
      STATIONMENU

      choice = Integer(gets)

      case choice
      when 1
        routes
      when 2
        create_route
      when 3
        delete_route
      when 4
        add_intermediate_stations
      when 5
        exit
      else
        puts 'Выберите один из указанных пунктов меню'
      end
    end
  end

  def routes
    puts @routes.map.with_index { |route, index| "#{index}: #{route.initial_station}  - #{route.initial_station}"}.join("\n")
  end

  def create_route
    return puts 'Нет станций для создания маршрута' if @stations.empty? || @stations.size == 1
    return puts 'Нет свободных станций' unless free_stations.size > 1

    puts free_stations

    p 'Выберите начальную и конечную станцию (через пробел)'

    selected_stations_index = gets.chomp.split(' ').map(&:to_i)

    return puts 'Выбранный(ые) индексы вне указанного диапазона' if select_out_of_range(selected_stations_index)

    initial_station = @stations[0]
    final_station = @stations[1]

    @routes << Route.new(initial_station, final_station)
  end

  def add_intermediate_stations
    return puts 'Нет станций для создания маршрута' if @stations.empty?
    return puts 'Нет свободных станций' unless free_stations.empty?

    puts routes
    p 'Выберите маршрут'
    route = @routes[Integer(gets)]

    return puts 'Выбран несуществующий маршрут' if route.nil?

    puts free_stations

    p 'Выберите начальную и конечную станцию (через пробел)'

    selected_stations_index = gets.chomp.split(' ').map(&:to_i)

    return puts 'Выбранный(ые) индексы вне указанного диапазона' if select_out_of_range(selected_stations_index)

    intermediate_stations = selected_stations_index.map { |index| @stations[index] }
    route.add_intermediate_station(*intermediate_stations)
  end

  def free_stations
    @stations.reject { |station| @routes.any?{ |route| route.use?(station) } }
  end

  def select_out_of_range(stations_indexes)
    stations_indexes_range = (0..@stations.size - 1)
    stations_indexes.any? { |index| !stations_indexes_range.cover?(index) }
  end

  def wagons_menu
    puts 'wagons_menu'
  end

  def trains_menu
    puts 'trains_menu'
  end
end

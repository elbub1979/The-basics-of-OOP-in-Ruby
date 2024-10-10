# frozen_string_literal: true

module RoutesMenu
  def routes_menu
    loop do
      puts <<~ROUTESMENU
        1. Список маршрутов
        2. Создать маршрут
        3. Удалить маршрут
        4. Добавить промежуточные станции
        5. Вернуться
      ROUTESMENU

      begin
        choice = Integer(gets)
      rescue ArgumentError => e
        puts e
        next
      end

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
        return
      else
        puts 'Выберите один из указанных пунктов меню'
      end
    end
  end

  def routes
    if @routes.empty?
      puts 'Маршрутов нет'
    else
      puts @routes.map.with_index { |route, index|
        "#{index}: #{route.initial_station}  - #{route.initial_station}"
      }.join("\n")
    end
  end

  def create_route
    begin
      can_create_route?
    rescue StandardError => e
      puts e
      retry
    end

    puts free_stations_list

    p 'Выберите начальную и конечную станцию (через пробел, не более двух станций)'

    begin
      stations = get_stations
    rescue StandardError => e
      puts e
      retry
    end

    initial_station, final_station = stations

    @routes << Route.new(initial_station, final_station)
  end

  def delete_route
    puts routes
    p 'Выберите маршрут: '

    begin
      route = get_route
    rescue ArgumentError => e
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    @routes.delete(route)
    puts 'Маршрут удален'
  end

  def add_intermediate_stations
    begin
      can_create_intermediate_station?
    rescue StandardError => e
      puts e
      retry
    end

    puts routes
    p 'Выберите маршрут'

    begin
      route = get_route
    rescue ArgumentError => e
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    puts free_stations_list

    p 'Выберите станции (через пробел)'

    begin
      stations = get_stations
    rescue StandardError => e
      puts e
      retry
    end

    route.add_intermediate_station(*stations)
  end

  def free_stations
    @stations.reject { |station| @routes.any? { |route| route.use?(station) } }
  end

  def free_stations_list
    free_stations.map.with_index { |station, index| "#{index}: #{station.name}" }.join("\n")
  end

  def select_stations_out_of_range(stations_indexes)
    free_stations_indexes_range = (0..free_stations.size - 1)
    stations_indexes.any? { |index| !free_stations_indexes_range.cover?(index) }
  end

  def can_create_route?
    raise StandardError, 'Нет станций для создания маршрута' if @stations.empty? || @stations.size == 1
    raise StandardError, 'Нет свободных станций' unless free_stations.size > 1
  end

  def can_create_intermediate_station?
    raise StandardError, 'Нет станций для создания маршрута' if @stations.empty?
    raise StandardError, 'Нет свободных станций' if free_stations.empty?
  end

  def get_stations
    stations_index_str = gets.chomp

    raise StandardError, 'Выбрать только индексы' if stations_index_str =~ /^[a-z].*$/i

    stations_index_int = stations_index_str.split(' ').map!(&:to_i)

    if select_stations_out_of_range(stations_index_int)
      raise StandardError,
            'Выбранный(ые) индексы вне указанного диапазона'
    end

    stations_index_int.map { |index| @stations[index] }
  end

  def get_route
    index = Integer(gets)
    route = @routes[index]

    raise StandardError, 'Такого марщрута не существует' if route.nil?

    route
  end
end

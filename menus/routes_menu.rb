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
        return
      else
        puts 'Выберите один из указанных пунктов меню'
      end
    end
  end

  def routes
    puts @routes.map.with_index { |route, index| "#{index}: #{route.initial_station}  - #{route.initial_station}" }.join("\n")
  end

  def create_route
    return puts 'Нет станций для создания маршрута' if @stations.empty? || @stations.size == 1
    return puts 'Нет свободных станций' unless free_stations.size > 1

    puts free_stations_list

    p 'Выберите начальную и конечную станцию (через пробел)'

    selected_stations_index = gets.chomp.split(' ').map(&:to_i)

    return puts 'Выбранный(ые) индексы вне указанного диапазона' if select_stations_out_of_range(selected_stations_index)

    initial_station = @stations[0]
    final_station = @stations[1]

    @routes << Route.new(initial_station, final_station)
  end

  def delete_route
    puts routes
    p 'Выберите маршрут: '
    index = Integer(gets)
    route = @routes[index]

    return puts 'Такого маршрута не существует' if route.nil?

    @routes.delete(route)
    puts 'Маршрут удален'
  end

  def add_intermediate_stations
    return puts 'Нет станций для создания маршрута' if @stations.empty?
    return puts 'Нет свободных станций' unless free_stations.empty?

    puts routes
    p 'Выберите маршрут'
    route = @routes[Integer(gets)]

    return puts 'Выбран несуществующий маршрут' if route.nil?

    puts free_stations_list

    p 'Выберите начальную и конечную станцию (через пробел)'

    selected_stations_index = gets.chomp.split(' ').map(&:to_i)

    return puts 'Выбранный(ые) индексы вне указанного диапазона' if select_stations_out_of_range(selected_stations_index)

    intermediate_stations = selected_stations_index.map { |index| @stations[index] }
    route.add_intermediate_station(*intermediate_stations)
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
end

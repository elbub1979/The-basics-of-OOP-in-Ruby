module TrainsMenu

  def trains_menu
    loop do
      puts <<~TRAINSNMENU
        1. Список поездов
        2. Создать поезд
        3. Удалить поезд
        4. Прицепить вагон к поезду
        5. Отцепить вагон от поезда
        6. Присвоить маршрут
        7. Переместить на следующую станцию
        8. Переместить на предыдущую станцию   
        9. Вернуться
      TRAINSNMENU

      choice = Integer(gets)

      case choice
      when 1
        trains
      when 2
        create_train
      when 3
        delete_train
      when 4
        add_wagon
      when 5
        remove_wagon
      when 6
        assign_route
      when 7
        move_next_station
      when 8
        move_previous_station
      when 9
        return
      else
        puts 'Выберите один из указанных пунктов меню'
      end
    end
  end

  def trains
    puts(@trains.map { |train|
 "#{train.number}, #{train.class}, #{train.route&.extreme_stations&.map(&:name)&.join(' - ')}" })
  end

  def create_train
    p 'Введите номер поезда:'
    number = Integer(gets)

    return puts 'Введите корректный номер' if number.nil?

    p 'Введите тип поезда (pass или cargo):'

    choice = gets.chomp.to_sym

    return puts 'Выбран несуществющий тип вагона' if TRAINS_TYPE[choice].nil?

    @trains << TRAINS_TYPE[choice].new(number)
  end

  def delete_train
    p 'Введите номер поезда:'
    number = Integer(gets)

    return puts 'Введите корректный номер' if number.nil?

    train = @trains[number]

    return puts 'Выберите поезд из списка' if train.nil?

    @trains.delete(train)
  end

  def add_wagon
    return puts 'Нет свободных вагонов' if free_wagons.empty?

    puts 'Выберите поезд'
    puts trains

    train = @trains[Integer(gets)]

    return puts 'Поезда не существует' if train.nil?

    puts free_wagons_list

    puts 'Выберите вагон из списка'
    wagon = free_wagons[Integer(gets)]

    return puts 'Вагона не существует' if wagon.nil?

    begin
      train.add_wagon(wagon)
    rescue StandardError => e
      puts e
    end
  end

  def free_wagons
    @wagons.reject { |wagon| @trains.any? { |train| train.use?(wagon) } }
  end

  def free_wagons_list
    free_wagons.map.with_index { |wagon, index| "#{index}: #{wagon.number}" }
  end

  def remove_wagon
    puts 'Выберите поезд'
    puts trains

    train = @trains[Integer(gets)]

    return puts 'Поезда не существует' if train.nil?

    puts train_wagons(train)

    puts 'Выберите вагон из списка'
    wagon = train.wagons[Integer(gets)]

    return puts 'Вагона не существует' if wagon.nil?

    train.delete_wagon(wagon)
  end

  def train_wagons(train)
    train.wagons.map.with_index { |wagon, index| "#{index}: #{wagon.number}" }
  end

  def assign_route
    return puts 'Нет маршрутов' if @routes.empty?

    puts 'Выберите маршрут'

    puts routes

    begin
      route = @routes[Integer.gets]
    rescue StandardError
      return puts 'Маршрута не существует'
    end

    puts 'Выберите поезд'
    puts trains

    begin
      train = @trains[Integer(gets)]
    rescue StandardError
      return puts 'Поезда не существует'
    end

    train.assign_route(route)
  end

  def move_next_station
    puts 'Выберите поезд'
    puts trains

    begin
      train = @trains[Integer(gets)]
    rescue StandardError
      return puts 'Такого поезда не существует'
    end

    begin
      train.move_next_station
    rescue StandardError => e
      puts e
    end
  end

  def move_previous_station
    puts 'Выберите поезд'
    puts trains

    begin
      train = @trains[Integer(gets)]
    rescue StandardError
      return puts 'Такого поезда не существует'
    end

    begin
      train.move_previous_station
    rescue StandardError => e
      puts e
    end
  end
end

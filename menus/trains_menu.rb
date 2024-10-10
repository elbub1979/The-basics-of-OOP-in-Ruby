# frozen_string_literal: true

module TrainsMenu
  def trains_menu
    loop do
      puts <<~TRAINSNMENU
        1. Список поездов
        2. Создать поезд
        3. Удалить поезд
        4. Показать вагоны у поезда
        5. Прицепить вагон к поезду
        6. Отцепить вагон от поезда
        7. Присвоить маршрут
        8. Переместить на следующую станцию
        9. Переместить на предыдущую станцию#{'   '}
        10. Вернуться
      TRAINSNMENU

      begin
        choice = Integer(gets)
      rescue ArgumentError => e
        puts e
        next
      end

      case choice
      when 1
        trains
      when 2
        create_train
      when 3
        delete_train
      when 4
        all_wagons
      when 5
        add_wagon
      when 6
        remove_wagon
      when 7
        assign_route
      when 8
        move_next_station
      when 9
        move_previous_station
      when 10
        return
      else
        puts 'Выберите один из указанных пунктов меню'
      end
    end
  end

  def trains
    return puts 'Нет поездов' if @trains.empty?

    puts(@trains.map.with_index do |train, index|
      "#{index}: #{train.number}, #{train.class},
         #{train.route&.extreme_stations&.map(&:name)&.join(' - ')}"
    end)
  end

  def create_train
    p 'Введите тип поезда (pass или cargo):'

    begin
      choice = gets.chomp.to_sym
      Train.trains_type!(choice)
      train_type = Train::TRAINS_TYPE[choice]
    rescue StandardError => e
      puts e
      retry
    end

    p 'Введите номер поезда (три цифры или буквы, необязательный дефис, две буквы или цифры):'

    begin
      number = gets.chomp
      @trains << Object.const_get(train_type).new(number)
    rescue StandardError => e
      puts e
      retry
    end
    puts "Поезд #{number} создан"
  end

  def delete_train
    trains

    p 'Введите номер поезда:'

    begin
      train = get_train
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    @trains.delete(train)
  end

  def all_wagons
    trains

    begin
      train = get_train
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    return puts 'У поезда нет вагонов' if train.wagons.empty?

    train.all_wagons do |wagon|
      measurement_unit = wagon.class::MEASUREMENT_UNIT
      puts "Номер:#{wagon.number}, тип: #{wagon.type}, всего #{measurement_unit}: #{wagon.capacity}, занято: #{measurement_unit}: #{wagon.reserve_capacity}"
    end
  end

  def add_wagon
    return puts 'Нет поездов' if @trains.empty?
    return puts 'Нет свободных вагонов' if free_wagons.empty?

    trains

    puts 'Выберите поезд'

    begin
      train = get_train
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    puts free_wagons_list

    puts 'Выберите вагон из списка'

    begin
      wagon_collection = free_wagons
      wagon = select_wagon(wagon_collection)
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    begin
      train.add_wagon(wagon)
    rescue StandardError => e
      puts e
    end
  end

  def remove_wagon
    return puts 'Нет поездов' if @trains.empty?

    trains

    puts 'Выберите поезд'

    begin
      train = get_train
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    puts train_wagons(train)

    puts 'Выберите вагон из списка'

    begin
      wagons_collection = train.wagons
      wagon = select_wagon(wagons_collection)
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    begin
      train.delete_wagon(wagon)
    rescue StandardError => e
      puts e
    end
  end

  def assign_route
    return puts 'Нет маршрутов' if @routes.empty?

    puts 'Выберите маршрут'

    puts routes

    begin
      number = Integer(gets)
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    end

    route = @routes[number]

    return puts 'Маршрута не существует' if route.nil?

    puts trains
    puts 'Выберите поезд'

    begin
      train = get_train
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    train.assign_route(route)
  end

  def move_next_station
    return puts 'Нет поездов' if @trains.empty?

    puts trains
    puts 'Выберите поезд'

    begin
      train = get_train
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    begin
      train.move_next_station
    rescue StandardError => e
      puts e
    end
  end

  def move_previous_station
    return puts 'Нет поездов' if @trains.empty?

    puts trains
    puts 'Выберите поезд'

    begin
      train = get_train
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    begin
      train.move_previous_station
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

  def train_wagons(train)
    train.wagons.map.with_index { |wagon, index| "#{index}: #{wagon.number}" }
  end

  def get_train
    number = Integer(gets)
    train = @trains[number]

    raise StandardError, 'Такого поезда не существует' if train.nil?

    train
  end

  def select_wagon(collection)
    number = Integer(gets)
    wagon = collection[number]
    raise StandardError, 'Такого вагона не существует' if wagon.nil?

    wagon
  end
end

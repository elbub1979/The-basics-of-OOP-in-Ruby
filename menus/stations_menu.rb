module StationsMenu
  def stations_menu
    loop do
      puts <<~STATIONMENU
        1. Список станций
        2. Создать станцию
        3. Удалить станцию
        4. Посмотреть поезда на станции
        5. Вернуться
      STATIONMENU

      begin
        choice = Integer(gets)
      rescue StandardError
        puts 'Введите число'
        retry
      end

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
        return
      else
        puts 'Выберите один из указанных пунктов меню'
      end
    end
  end

  def stations
    if @stations.empty?
      puts 'Станций нет'
    else
      puts @stations.map.with_index { |station, index| "#{index}: #{station.name}" }.join("\n")
    end
  end

  def create_station
    p 'Введите название станции: '
    name = gets.chomp

    begin
      station = Station.new(name)
      @stations << station
      puts "Станция #{station.name} создана"
    rescue StandardError => e
      puts e
    end
  end

  def delete_station
    puts stations

    p 'Выберите станцию: '

    begin
      index = Integer(gets)
    rescue ArgumentError => e
      return puts e
    end

    station = @stations[index]

    return puts 'Такой станции не существует' if station.nil?
    return puts 'На станции есть поезда' unless station.trains.empty?

    @stations.delete(station)
    puts 'Станция удалена'
  end

  def stations_trains
    puts stations
    p 'Выберите станцию: '

    begin
      index = Integer(gets)
    rescue ArgumentError => e
      return puts e
    end

    station = @stations[index]

    return puts 'Такой станции не существует' if station.nil?

    station.trains.map { |train| "#{train.number}: маршрут #{train.route.initial_station || ''} - #{train.route.initial_station || ''}" }.join("\n")
  end
end

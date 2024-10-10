# frozen_string_literal: true

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
        station_trains
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
    stations

    p 'Выберите станцию: '

    begin
      station = self.station
    rescue ArgumentError => e
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    @stations.delete(station)
    puts 'Станция удалена'
  end

  def station_trains
    return puts 'Станций нет' if @stations.empty?

    stations

    p 'Выберите станцию: '

    begin
      index = Integer(gets)
      station = @stations[index]

      raise StandardError, 'Такой станции не существует' if station.nil?
    rescue ArgumentError => e
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    return puts 'Поездов на станции нет' if station.trains.empty?

    station.all_trains do |train|
      puts "Номер: #{train.number}, тип #{train.type}, количество вагонов: #{train.wagons.count}"
    end
  end

  def station
    index = Integer(gets)
    station = @stations[index]

    raise StandardError, 'Такой станции не существует' if station.nil?
    raise StandardError, 'На станции есть поезда' unless station.trains.empty?

    station
  end
end

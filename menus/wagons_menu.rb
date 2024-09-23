module WagonsMenu
  def wagons_menu
    loop do
      puts <<~WAGONSMENU
        1. Список вагонов
        2. Создать вагон
        3. Удалить вагон
        4. Вернуться
      WAGONSMENU

      begin
        choice = Integer(gets)
      rescue ArgumentError => e
        puts e
        next
      end

      case choice
      when 1
        wagons
      when 2
        create_wagon
      when 3
        delete_wagon
      when 4
        return
      else
        puts 'Выберите один из указанных пунктов меню'
      end
    end
  end

  def wagons
    puts @wagons.map { |wagon| "#{wagon.class}: #{wagon.number}" }.join("\n")
  end

  def create_wagon
    p 'Введите номер вагона:'

    begin
      number = Integer(gets)
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    end

    p 'Введите тип вагона (pass или cargo):'

    begin
      choice = gets.chomp.to_sym
      Wagon.wagons_type!(choice)
    rescue StandardError => e
      puts e
      retry
    end

    @wagons << WAGONS_TYPE[choice].new(number)
  end

  def delete_wagon
    p 'Введите номер вагона:'

    begin
      number = Integer(gets)
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    end

    wagon = @wagons[number]

    return puts 'Выберите вагон из списка' if wagon.nil?
    return puts 'Вагон прицеплен к поезду' if wagon_used?(wagon)

    @trains.wagons.delete(wagon)
  end

  def wagon_used?(wagon)
    @trains.any { |train| train.use?(wagon) }
  end
end

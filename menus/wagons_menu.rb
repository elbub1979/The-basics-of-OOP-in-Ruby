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
    if @wagons.empty?
      puts 'Вагонов нет'
    else
      puts @wagons.map { |wagon| "#{wagon.class}: #{wagon.number}" }.join("\n")
    end
  end

  def create_wagon
    p 'Введите тип вагона (pass или cargo):'

    begin
      choice = gets.chomp.to_sym
      Wagon.wagons_type!(choice)
      wagon_type = Wagon::WAGONS_TYPE[choice]
    rescue StandardError => e
      puts e
      retry
    end

    p 'Введите номер вагона:'

    begin
      number = gets.chomp
      @wagons << Object.const_get(wagon_type).new(number)
    rescue StandardError => e
      puts e
      retry
    end
  end

  def delete_wagon
    p 'Введите номер вагона:'

    begin
      number = Integer(gets)
      wagon = @wagons[number]
      raise StandardError, 'Выберите вагон из списка' if wagon.nil?
      raise StandardError, 'Вагон прицеплен к поезду' if wagon_used?(wagon)
    rescue ArgumentError
      puts 'Введите корректный номер'
      retry
    rescue StandardError => e
      puts e
      retry
    end

    @trains.wagons.delete(wagon)
  end

  def wagon_used?(wagon)
    @trains.any { |train| train.use?(wagon) }
  end
end

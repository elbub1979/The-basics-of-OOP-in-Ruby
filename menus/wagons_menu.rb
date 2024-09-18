module WagonsMenu
  def wagons_menu
    loop do
      puts <<~WAGONSMENU
        1. Список вагонов
        2. Создать вагон
        3. Удалить вагон
        4. Вернуться
      WAGONSMENU

      choice = Integer(gets)

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
    number = Integer(gets)

    return puts 'Введите корректный номер' if number.nil?

    p 'Введите тип вагона (pass или cargo):'

    choice = gets.chomp.to_sym

    return puts 'Выбран несуществющий тип вагона' if WAGONS_TYPE[choice].nil?

    @wagons << WAGONS_TYPE[choice].new(number)
  end

  def delete_wagon
    p 'Введите номер вагона:'
    number = Integer(gets)

    return puts 'Введите корректный номер' if number.nil?

    wagon = @wagons[number]

    return puts 'Выберите вагон из списка' if wagon.nil?
    return puts 'Вагон прицеплен к поезду' if wagon_used?(wagon)

    @trains.wagons.delete(wagon)
  end

  def wagon_used?(wagon)
    @trains.any { |train| train.use?(wagon) }
  end
end

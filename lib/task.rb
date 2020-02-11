# frozen_string_literal: true

require 'date'

# Класс Задача, разновидность базового класса "Запись"
class Task < Post
  def initialize
    super
    @due_date = Time.now
  end

  def read_from_console
    puts 'Что надо сделать?'
    @text = STDIN.gets.strip

    puts 'К какому числу? Укажите дату в формате ДД.ММ.ГГГГ, например 12.05.2003'
    input = STDIN.gets.strip

    @due_date = Date.today if input == ''
    @due_date = Date.parse(input) unless input == ''
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n\r \n\r"

    deadline = "Крайний срок: #{@due_date}"

    [deadline, @text, time_string]
  end
end

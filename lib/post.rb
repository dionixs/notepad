# frozen_string_literal: true

# Базовый класс "Запись"
# Задает основные методы и свойства, присущие всем разновидностям Записи
class Post
  def self.post_types
    [Memo, Link, Task]
  end

  def self.create(type_index)
    post_types[type_index].new
  end

  def initialize
    @created_at = Time.now # статический метод
    @text = nil
  end

  # тут записи должны запрашивать ввод пользователя
  def read_from_console
    # todo
  end

  # возвращает содержимое объекта в виде массива строк
  def to_strings
    # todo
  end

  # сохранение записи в файл
  def save
    file = File.new(file_path, 'w:UTF-8')

    to_strings.each do |item|
      file.puts(item)
    end

    file.close
  end

  # путь к файлу, куда записывать содержимое объекта
  def file_path
    Dir.mkdir('data') unless File.exist?('data')

    current_path = './data'

    file_name = @created_at.strftime("#{self.class.name}-%d-%m-%Y-%H-%M-%S.txt")

    current_path + '/' + file_name
  end
end

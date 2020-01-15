# Базовый класс "Запись"
# Задает основные методы и свойства, присущие всем разновидностям Записи
class Post

  def initialize
    @created_at = Time.now
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

    for item in to_strings do
      file.puts(item)
    end

    file.close
  end

  # путь к файлу, куда записывать содержимое объекта
  def file_path
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    return current_path + '/' + file_name
  end
end
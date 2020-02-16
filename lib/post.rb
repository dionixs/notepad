# frozen_string_literal: true

require 'sqlite3'

# Базовый класс "Запись"
# Задает основные методы и свойства, присущие всем разновидностям Записи
class Post
  @@SQLITE_DB_FILE = './db/notepad.db'

  def self.post_types
    { 'Memo' => Memo, 'Link' => Link, 'Task' => Task }
  end

  def self.create(type)
    post_types[type].new
  end

  def self.find_by_id(id)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)

    db.results_as_hash = true

    result = db.execute('SELECT * FROM posts WHERE rowid = ?', id)
    result = result[0] if result.is_a? Array
    db.close

    if result.nil?
      puts "Такой id #{id} не найден в базе :("
      nil
    else
      post = create(result['type'])
      post.load_data(result)
      post
    end
  end

  def self.find_all(limit, type)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = false

    query = 'SELECT rowid, * FROM posts '
    query += 'WHERE type = :type ' unless type.nil?
    query += 'ORDER by rowid DESC '
    query += 'LIMIT :limit ' unless limit.nil?

    statement = db.prepare(query)
    statement.bind_param('type', type) unless type.nil?
    statement.bind_param('limit', limit) unless limit.nil?

    result = statement.execute!
    statement.close
    db.close

    result
  end

  def initialize
    @created_at = Time.now # статический метод
    @text = nil
  end

  # тут записи должны запрашивать ввод пользователя
  def read_from_console; end

  # возвращает содержимое объекта в виде массива строк
  def to_strings; end

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

  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true

    db.execute(
      'INSERT INTO posts (' +
          to_db_hash.keys.join(',') +
          ')' \
          ' VALUES (' +
          ('?,' * to_db_hash.keys.size).chomp(',') + # (?, ?, ?)
          ')',
      to_db_hash.values
    )

    insert_row_id = db.last_insert_row_id

    db.close

    insert_row_id
  end

  def to_db_hash
    {
      'type' => self.class.name,
      'created_at' => @created_at.to_s
    }
  end

  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end
end

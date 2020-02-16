# frozen_string_literal: true

require_relative 'lib/post'
require_relative 'lib/task'
require_relative 'lib/memo'
require_relative 'lib/link'

puts 'Привет, я твой блокнот!'

puts 'Что хотите записать в блокнот?'

choices = Post.post_types.keys

choice = -1

until choice >= 0 && choice < choices.size

  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end

  print '>> '

  choice = STDIN.gets.to_i
end

entry = Post.create(choices[choice])

entry.read_from_console

rowid = entry.save_to_db

puts "Ура, запись сохранена, id = #{rowid}"

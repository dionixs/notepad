# frozen_string_literal: true

require_relative 'lib/post'
require_relative 'lib/task'
require_relative 'lib/memo'
require_relative 'lib/link'

puts 'Привет, я твой блокнот!'

puts 'Что хотите записать в блокнот?'

choices = Post.post_types

choice = -1

until choice >= 0 && choice < choices.size

  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end

  print '>> '

  choice = STDIN.gets.to_i
end

entry = Post.create(choice)

entry.read_from_console

entry.save

puts 'Ура, запись сохранена!'

# frozen_string_literal: true

require_relative 'lib/post'
require_relative 'lib/task'
require_relative 'lib/memo'
require_relative 'lib/link'

require 'optparse'

options = {}

optparse = OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'какой тип постов показывать (по умолчанию любой)') { |o| options[:type] = o }
  opt.on('--id POST_ID', 'если задан id — показываем подробно только этот пост') { |o| options[:id] = o }
  opt.on('--limit NUMBER', 'сколько последних постов показать (по умолчанию все)') { |o| options[:limit] = o }
end

begin
  optparse.parse!
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts "Нераспознанный параметр!"
  puts "По команде «read -h» можно получить дополнительную информацию."
  exit
end

result = if options[:id].nil?
           Post.find_all(options[:limit], options[:type])
         else
           Post.find_by_id(options[:id])
         end

if result.is_a? Post
  puts "Запись #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each do |line|
    puts line
  end
else
  exit if result.nil?

  print "| id\t| @type\t|  @created_at\t\t\t|  @text \t\t\t| @url\t\t| @due_date \t "

  result.each do |row|
    puts
    row.each do |element|
      print "| #{element.to_s.delete("\n")[0..40]}\t"
    end
  end
end

puts

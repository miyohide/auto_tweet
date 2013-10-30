require 'rufus-scheduler'
require_relative './tweet_data'
require_relative './tweet_handler'

if ARGV.size < 1
   puts "引数にツイートデータを指定してください"
   exit 1
end

td = TweetData.new
td.read_file(ARGV[0])

tweet_datas = td.tweet_data

tweet_datas.each do |tweet_data|
   Rufus::Scheduler.s.at tweet_data[:time], TweetHandler.new(tweet_data[:msg])
end

Rufus::Scheduler.s.join


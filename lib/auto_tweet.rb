require 'rufus-scheduler'
require 'twitter'
require 'dotenv'
require_relative './tweet_data'
require_relative './tweet_handler'

if $0 == __FILE__
   if ARGV.size < 1
      puts "引数にツイートデータを指定してください"
      exit 1
   end

   Dotenv.load

   twitter_client = Twitter::Client.new(
      consumer_key:       ENV['TWITTER_CONSUMER_KEY'],
      consumer_secret:    ENV['TWITTER_CONSUMER_SECRET'],
      oauth_token:        ENV['OAUTH_TOKEN'],
      oauth_token_secret: ENV['OAUTH_TOKEN_SECRET']
   )

   td = TweetData.new
   td.read_file(ARGV[0])

   tweet_datas = td.tweet_data

   tweet_datas.each do |tweet_data|
      Rufus::Scheduler.s.at tweet_data[:time],
         TweetHandler.new(twitter_client, tweet_data[:msg], Rufus::Scheduler.s)
   end

   Rufus::Scheduler.s.join
end


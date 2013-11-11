# rufus-schedulerで時間が来た時に実行するクラスの定義

require 'active_support/core_ext'

class TweetHandler
   def initialize(twitter_client, msg, scheduler)
      @twitter_client = twitter_client
      @msg = msg
      @scheduler = scheduler
   end

   def call(job)
      @twitter_client.update(@msg)
   rescue => e
      $stderr.puts '-' * 80
      if e.instance_of?(Twitter::Error::ClientError)
         $stderr.puts 'クライアントエラー。15秒後に再送信します。'
         job.unschedule
         @scheduler.at(Time.now + 15.seconds, TweetHandler.new(@twitter_client, @msg, @scheduler))
      elsif e.instance_of?(Twitter::Error::Forbidden)
         if e.wrapped_exception.start_with?("Status is a duplicate")
            $stderr.puts '二重送信エラー。再送信は行いません。'
            job.unschedule
         else
            $stderr.puts "Unknown Error。message = #{e.message}"
         end
      else
         $stderr.puts "Unknown Error。message = #{e.message}"
      end
   end
end


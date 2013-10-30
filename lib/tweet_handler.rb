# rufus-schedulerで時間が来た時に実行するクラスの定義
class TweetHandler
   def initialize(msg)
      @msg = msg
   end

   def call
      puts "#{@msg}"
   end
end


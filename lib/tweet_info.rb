require 'date'

class TweetInfo
   attr_reader :time, :msg

   def initialize(time, msg)
      @time = time
      @msg = msg
   end

   def time_str
      @time.strftime("%Y-%m-%d %H:%M:%S")
   end

   def tweet
      Proc.new{ puts @msg }
   end
end

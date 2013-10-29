class TweetData
   attr_reader :tweet_data

   def initialize
      @tweet_data = []
   end

   def read_file(fname)
      open(fname) {|file|
         while line = file.gets
            line.chomp!
            split_line = line.split("\t")
            ## %i(time msg) # => [:time, :msg]
            ## %i(time msg).zip(split_line) # => [[:time, split_line[0]], [:msg, split_line[1]]]
            ## %i(time msg).zip(split_line).flatten # => [:time, split_line[0], :msg, split_line[1]]
            @tweet_data << Hash[*(%i(time msg).zip(split_line).flatten)] if split_line.size == 2
         end
      }
   end
end

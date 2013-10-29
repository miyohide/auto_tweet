require 'minitest/autorun'
require_relative '../lib/tweet_info'

describe TweetInfo do
   before do
      @ti = TweetInfo.new(DateTime.new(2013, 10, 28, 22, 30, 0, '+0900'), 'hogehoge')
   end

   it { @ti.time_str.must_equal '2013-10-28 22:30:00' }
   # @ti.tweet.must_be_kind_of Proc だとArgument Errorとなるので、kind_of?でチェックさせている
   it { @ti.tweet.kind_of?(Proc).must_equal true }
end

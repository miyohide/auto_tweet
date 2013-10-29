require 'minitest/autorun'
require_relative '../lib/tweet_data'

describe TweetData do
   describe 'Read Tweet Data' do
      before do
         @td = TweetData.new
         @td.read_file('./spec/tweet_data.txt')
      end

      subject { @td.tweet_data }

      it { subject.size.must_equal 1 }
      it { subject.must_be_instance_of Array }
      it { subject.first.has_key?(:time).must_equal true }
      it { subject.first.has_key?(:msg).must_equal true }

   end
end

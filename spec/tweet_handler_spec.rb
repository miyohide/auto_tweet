require 'minitest/autorun'
require 'twitter'
require 'rufus-scheduler'
require_relative '../lib/tweet_handler'

describe TweetHandler do
   # rufus-schedulerで必要なメソッドがあるかどうかの確認。
   # こういうテストって必要かなぁ？
   it { TweetHandler.new(nil, "hoge", nil).must_respond_to :call }

   describe '#call' do
      before do
         @twitter_client = Twitter::Client.new(consumer_key: 'consumer_key',
                                               consumer_secret: 'consumer_secret',
                                               oauth_token: 'oauth_token',
                                               oauth_token_secret: 'oauth_token_secret')
         @scheduler = Rufus::Scheduler.new
      end

      subject { TweetHandler.new(@twitter_client, "message", @scheduler) }

      describe '正常時' do
         it '正常終了すること' do
            @twitter_client.stub(:update, '') do
               subject.call('').must_equal ''
            end
         end
      end
   end
end

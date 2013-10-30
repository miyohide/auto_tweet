require 'minitest/autorun'
require_relative '../lib/tweet_handler'

describe TweetHandler do
   # rufus-schedulerで必要なメソッドがあるかどうかの確認。
   # こういうテストって必要かなぁ？
   it { TweetHandler.new("hoge").must_respond_to :call }
end

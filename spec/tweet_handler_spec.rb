require 'minitest/autorun'
require 'minitest-spec-context'
require 'mocha/setup'
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
         @job = @scheduler.schedule_at '2099/12/31 23:59' do; end
      end

      subject { TweetHandler.new(@twitter_client, "message", @scheduler) }

      describe '正常時' do
         it '正常終了すること' do
            @twitter_client.stub(:update, '') do
               subject.call(@job).must_equal ''
            end
         end
      end

      describe '異常時' do
         context 'ClientError発生時' do
            before do
               @twitter_client.expects(:update).raises(Twitter::Error::ClientError)
               subject.call(@job)
            end

            it 'ジョブが再登録されること' do
               @scheduler.jobs.size.must_equal 1
               @scheduler.jobs.first.must_be_instance_of Rufus::Scheduler::AtJob
            end
         end

         context 'ClientError(二重送信エラー)発生時' do
            before do
               @twitter_client.expects(:update).raises(Twitter::Error::Forbidden)
               Twitter::Error::Forbidden.any_instance.expects(:wrapped_exception).returns("Status is a duplicate")
            end

            it '二重送信エラーのメッセージが表示されること' do
               proc { subject.call(@job) }.must_output(nil, "#{'-' * 80}\n二重送信エラー。再送信は行いません。\n")
            end

            it 'ジョブはなにもないこと' do
               subject.call(@job)
               @scheduler.jobs.size.must_equal 0
            end
         end

         context 'ClientError(二重送信エラー以外)発生時' do
            before do
               @twitter_client.expects(:update).raises(Twitter::Error::Forbidden)
               Twitter::Error::Forbidden.any_instance.expects(:wrapped_exception).returns("Not Status is a duplicate")
               Twitter::Error::Forbidden.any_instance.expects(:message).returns("ErrorMessage")
            end

            it 'Unknownのメッセージが表示されること' do
               proc { subject.call(@job) }.must_output(nil, "#{'-' * 80}\nUnknown Error。message = ErrorMessage\n")
            end
         end

         context 'ClientError/Forbidden以外の例外発生時' do
            before do
               @twitter_client.expects(:update).raises(StandardError)
               StandardError.any_instance.expects(:message).returns("ErrorMessage")
            end

            it 'Unknownのメッセージが表示されること' do
               proc { subject.call(@job) }.must_output(nil, "#{'-' * 80}\nUnknown Error。message = ErrorMessage\n")
            end
         end
      end
   end
end

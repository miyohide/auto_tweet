auto_tweet
==========

テキストファイルに書かれたツイートメッセージを指定時刻になるとツイートするコンソールアプリです。

使うための準備
==============

1. アプリケーションをTwitterに登録する
[TwitterのDevelopersサイト](https://dev.twitter.com/apps)でアプリケーション登録を行ってください。そこで取得したconsumer key、consumer secret、oauth_token、oauth_secretを環境変数に設定します。Application Typeには最低でも書き込み権限があるものを選択してください。

2. 環境変数ファイル.envの作成
  Gemにdotenvを使って環境変数を読み込ませています。1.で取得したconsumer keyなどはこの.envファイルに記述してください。記述の方法は、
  ```
  TWITTER_CONSUMER_KEY=1.で取得したconsumer_key
  TWITTER_CONSUMER_SECRET=1.で取得したconsumer_secret
  OAUTH_TOKEN=1.で取得したoauth_token
  OAUTH_TOKEN_SECRET=1.で取得したoauth_secret
  ```
  
  の用に書いてください。
  
  これらの情報はインターネット上には公開しないように注意してください。例えば、作ったアプリケーションをGitHub上に公開する場合、.envファイルは.gitignoreファイルに記述して管理対象外としてください。
3. Tweetデータの準備
  Tweetするデータの準備をします。タブ区切りで、日時とメッセージを1行に記述します。以下に具体例を記します。
  
  ```
  2013/11/4 10:01:03	テストメッセージ
  ```
4. 起動と終了
  第一引数に3.で作成したTweetデータのパスを指定して`lib/auto_tweet.rb`を実行します。
  ```
  ruby lib/auto_tweet.rb data/tweet_data.txt
  ```
  終了は`Ctrl+C`で終了させてください。



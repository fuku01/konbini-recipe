FROM ruby:3.2.2

# 作業ディレクトリの設定
RUN mkdir /myapp
WORKDIR /myapp

# Gemfileのコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundlerのインストール
RUN gem install bundler

# 依存関係のインストール
RUN bundle install

# プロジェクトのコピー
COPY . /myapp

# ポート番号の設定
EXPOSE 3000

# コンテナ起動時に実行されるコマンド
CMD ["rails", "server", "-b", "0.0.0.0"]

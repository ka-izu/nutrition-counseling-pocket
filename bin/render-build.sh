set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
# bundle exec rails db:migrate

# ★ ここを一時的に変更。成功したら消す（db:migrate のみ）
bundle exec rails db:drop
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

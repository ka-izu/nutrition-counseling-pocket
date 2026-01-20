set -o errexit

apt-get update
apt-get install -y poppler-utils libvips

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
# bundle exec rails db:seed

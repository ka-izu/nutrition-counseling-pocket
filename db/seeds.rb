# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 疾患名の初期データ
system_diseases = [
  "糖尿病",
  "高血圧",
  "脂質異常症",
  "慢性腎臓病",
  "痛風・高尿酸血症"
]

system_diseases.each do |name|
  Disease.find_or_create_by!(name: name, user_id: nil)
end

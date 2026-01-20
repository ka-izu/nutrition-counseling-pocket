# System Diseases の初期マスタ
system_disease_names = [
  "糖尿病",
  "高血圧",
  "脂質異常症",
  "慢性腎臓病",
  "痛風・高尿酸血症"
]

system_diseases = system_disease_names.map do |name|
  Disease.find_or_create_by!(name: name, user_id: nil)
end

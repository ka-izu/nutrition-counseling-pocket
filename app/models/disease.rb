class Disease < ApplicationRecord
  # システム提供データの場合、user_id は nil
  # ユーザー作成データの場合、user_id に user_id が入る
  belongs_to :user, optional: true

  before_validation :generate_slug, on: :create

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  private

  def generate_slug
    self.slug ||= SecureRandom.hex(8)
  end
end

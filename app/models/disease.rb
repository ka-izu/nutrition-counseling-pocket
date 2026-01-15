class Disease < ApplicationRecord
  # システム提供データの場合、user_id は nil
  # ユーザー作成データの場合、user_id に user_id が入る
  belongs_to :user, optional: true

  has_many :teaching_material_diseases, dependent: :destroy
  has_many :teaching_materials, through: :teaching_material_diseases

  before_validation :generate_slug, on: :create

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug ||= SecureRandom.hex(8)
  end
end

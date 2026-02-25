class Tag < ApplicationRecord
  belongs_to :user

  has_many :teaching_material_tags, dependent: :destroy
  has_many :teaching_materials, through: :teaching_material_tags

  validates :name, presence: true,
                   uniqueness: { scope: :user_id },
                   length: { maximum: 15 }
end

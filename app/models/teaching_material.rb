class TeachingMaterial < ApplicationRecord
  belongs_to :user

  has_many :teaching_material_diseases, dependent: :destroy
  has_many :diseases, through: :teaching_material_diseases

  validates :title, presence: true
  validates :teaching_material_diseases, presence: true
end

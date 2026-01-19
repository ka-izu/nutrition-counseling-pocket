class TeachingMaterial < ApplicationRecord
  belongs_to :user

  has_one_attached :document

  has_many :teaching_material_diseases, dependent: :destroy
  has_many :diseases, through: :teaching_material_diseases

  validates :title, presence: true
  validates :teaching_material_diseases, presence: true

  # ファイルの種類とサイズのバリデーション（gem ActiveStorage Validationを使用）
  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png application/pdf].freeze
  validates :document, content_type: ACCEPTED_CONTENT_TYPES,
                    size: { less_than_or_equal_to: 1.megabytes }
end

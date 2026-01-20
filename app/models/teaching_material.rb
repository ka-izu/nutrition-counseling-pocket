class TeachingMaterial < ApplicationRecord
  belongs_to :user

  has_one_attached :document

  has_many :teaching_material_diseases, dependent: :destroy
  has_many :diseases, through: :teaching_material_diseases

  validates :title, presence: true
  validates :teaching_material_diseases, presence: true
  validates :document, presence: true

  # ファイルの種類とサイズのバリデーション（gem ActiveStorage Validationを使用）
  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png application/pdf].freeze
  validates :document, content_type: ACCEPTED_CONTENT_TYPES,
                    size: { less_than_or_equal_to: 1.megabytes }

  # 一覧表示用のサムネイルを返す
  # - 画像ファイルの場合は variant を生成
  # - PDF などプレビュー可能なファイルの場合は preview を生成
  # - ファイル未添付、またはプレビュー不可の場合は nil を返す
  def thumbnail(size: [300, 300])
    # ファイルが添付されていない場合
    return unless document.attached?

    # 画像ファイル（JPEG / PNG など）の場合
    if document.image?
      document.variant(resize_to_limit: size)
    # PDF などプレビュー生成が可能なファイルの場合
    elsif document.representable?
      document.preview(resize_to_limit: size)
    end
  end

  # サムネイルを表示できるかどうかを判定する
  def thumbnail?
    document.attached? && (document.image? || document.representable?)
  end
end

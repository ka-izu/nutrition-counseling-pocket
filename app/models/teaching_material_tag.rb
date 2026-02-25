class TeachingMaterialTag < ApplicationRecord
  belongs_to :teaching_material
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :teaching_material_id }
end

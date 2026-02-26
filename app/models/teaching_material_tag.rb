class TeachingMaterialTag < ApplicationRecord
  belongs_to :teaching_material, inverse_of: :teaching_material_tags
  belongs_to :tag, inverse_of: :teaching_material_tags

  validates :tag_id, uniqueness: { scope: :teaching_material_id }
end

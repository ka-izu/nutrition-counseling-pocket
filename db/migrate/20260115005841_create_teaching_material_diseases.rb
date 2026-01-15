class CreateTeachingMaterialDiseases < ActiveRecord::Migration[7.2]
  def change
    create_table :teaching_material_diseases do |t|
      t.references :teaching_material, null: false, foreign_key: true
      t.references :disease, null: false, foreign_key: true

      t.timestamps
    end
  end
end

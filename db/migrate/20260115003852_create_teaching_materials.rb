class CreateTeachingMaterials < ActiveRecord::Migration[7.2]
  def change
    create_table :teaching_materials do |t|
      t.string :title, null: false
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

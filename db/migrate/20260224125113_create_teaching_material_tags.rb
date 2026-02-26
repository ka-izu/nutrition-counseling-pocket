class CreateTeachingMaterialTags < ActiveRecord::Migration[7.2]
  def change
    create_table :teaching_material_tags do |t|
      t.references :teaching_material, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    # 同じ教材への同一タグの二重付与を拒否
    add_index :teaching_material_tags,
              [ :teaching_material_id, :tag_id ],
              unique: true,
              name: "index_tm_tags_uniqueness"
  end
end

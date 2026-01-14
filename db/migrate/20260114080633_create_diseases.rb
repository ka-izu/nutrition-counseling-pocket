class CreateDiseases < ActiveRecord::Migration[7.2]
  def change
    create_table :diseases do |t|
      t.string :name, null: false, default: ""
      t.string :slug, null: false
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end

    add_index :diseases, :slug, unique: true
  end
end

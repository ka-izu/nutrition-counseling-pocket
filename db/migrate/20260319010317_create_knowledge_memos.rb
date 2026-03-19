class CreateKnowledgeMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :knowledge_memos do |t|
      t.string :title, null: false
      t.text :content
      t.references :disease, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

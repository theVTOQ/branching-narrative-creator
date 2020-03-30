class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :passage
      t.belongs_to :narrative
      t.boolean :is_root

      t.timestamps
    end
  end
end

class CreateNarratives < ActiveRecord::Migration[5.2]
  def change
    create_table :narratives do |t|
      t.string :title
      t.integer :author_id
      t.boolean :is_public

      t.timestamps
    end
  end
end

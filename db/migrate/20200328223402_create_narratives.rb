class CreateNarratives < ActiveRecord::Migration[5.2]
  def change
    create_table :narratives do |t|
      t.string :title
      t.belongs_to :user
      t.boolean :is_public

      t.timestamps
    end
  end
end

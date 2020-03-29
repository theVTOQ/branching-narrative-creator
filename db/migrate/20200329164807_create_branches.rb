class CreateBranches < ActiveRecord::Migration[5.2]
  def change
    create_table :branches do |t|
      t.integer :parent_document_id
      t.integer :child_document_id

      t.timestamps
    end
  end
end

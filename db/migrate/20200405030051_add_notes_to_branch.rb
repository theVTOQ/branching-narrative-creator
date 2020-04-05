class AddNotesToBranch < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :notes, :string
  end
end

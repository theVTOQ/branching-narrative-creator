class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :uid
      t.references :user
      t.timestamps
    end
  end
end

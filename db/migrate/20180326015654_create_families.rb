class CreateFamilies < ActiveRecord::Migration[5.1]
  def change
    create_table :families do |t|
      t.string :family_name
      t.string :parent_first_name
      t.integer :user_id
      t.boolean :active

      t.timestamps
    end
  end
end

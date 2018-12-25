class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :registrations do |t|
      t.integer :camp_id
      t.integer :student_id
      t.text :payment

      t.timestamps
    end
  end
end

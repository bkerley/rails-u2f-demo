class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :key_handle
      t.belongs_to :user, index: true
      t.string :public_key
      t.text :certificate
      t.integer :counter

      t.timestamps null: false
    end
    add_foreign_key :registrations, :users
  end
end

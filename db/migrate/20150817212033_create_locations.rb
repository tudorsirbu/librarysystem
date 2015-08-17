class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :building
      t.string :room

      t.timestamps null: false
    end
  end
end

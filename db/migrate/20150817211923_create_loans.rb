class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :user_id
      t.integer :item_id
      t.timestamp :due_date

      t.timestamps null: false
    end
  end
end

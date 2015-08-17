class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :isbn
      t.integer :category_id
      t.integer :author_id
      t.string :publisher
      t.integer :year

      t.timestamps null: false
    end
  end
end

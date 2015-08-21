class RemoveIsbnFromItem < ActiveRecord::Migration
  def change
    remove_column :items, :isbn
  end
end

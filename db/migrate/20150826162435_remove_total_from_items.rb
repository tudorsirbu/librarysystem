class RemoveTotalFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :total
  end
end

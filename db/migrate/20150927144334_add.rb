class Add < ActiveRecord::Migration
  def change
    add_column :items, :copies, :integer, default: 0
  end
end

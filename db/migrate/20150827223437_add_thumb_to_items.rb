class AddThumbToItems < ActiveRecord::Migration
  def change
    add_column :items, :thumbnail, :string
  end
end

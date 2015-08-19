class RemoveAuthorIdFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :author_id
  end
end

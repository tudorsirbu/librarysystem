class AddReturnedOnToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :returned_on, :timestamp
  end
end

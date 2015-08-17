class AddBarcodeToItems < ActiveRecord::Migration
  def change
    add_column :items, :barcode, :string
  end
end

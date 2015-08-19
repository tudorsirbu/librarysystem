require 'csv'
class Item < ActiveRecord::Base
  def self.import
    items = Rails.root.join('db').join('items.csv')
    barcodes = Rails.root.join('db').join('barcodes.csv')

    CSV.foreach(items, :headers => true) do |row_item|
      barcode = nil
      CSV.foreach(barcodes,:headers => true) do |row_barcode|
        if row_item["id"] == row_barcode["item_id"]
          barcode = row_barcode["barcode"]
          break
        end
      end

      item = Item.new
      item.title = row_item["title"]
      if row_item["details"] && (row_item["details"].include? "ELTC")
          item.isbn = row_item["details"].split(//).last(8).join
      else
        item.isbn = row_item["isbn"]
      end
      if row_item["category_id"] == 0
        item.category_id = 1
      else
        item.category_id = row_item["category_id"]
      end

      item.publisher = row_item["publisher"]
      item.year = row_item["year"]
      item.barcode = barcode
      item.location_id = 1
      item.save
    end

  end
end

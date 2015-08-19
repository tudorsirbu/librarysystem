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
      item.isbn = row_item["isbn"]
      item.category_id = row_item["category_id"]
      item.publisher = row_item["publisher"]
      item.year = row_item["year"]
      item.barcode = barcode
      item.location_id = 1
      item.save
    end

  end

  def self.open_spreadsheet(file)
    case File.extname("items.csv")
      when ".csv" then Csv.new(file, nil, :ignore)
      else raise "Unknown file type:items.csv"
    end
  end
end

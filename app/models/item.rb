require 'csv'
class Item < ActiveRecord::Base
belongs_to :location
belongs_to :category
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
      items_total = row_item["total"]
      for i in 1..items_total.to_i
        item = Item.new
        item.title = row_item["title"]
        item.category_id = row_item["category_id"]
        item.publisher = row_item["publisher"]
        item.year = row_item["year"]
        item.barcode = barcode
        item.location_id = 1
        item.save
      end

    end

  end
  def self.category_search(category)
    joins(:category).where("LOWER(categories.name) LIKE ?","%#{category.downcase}%")
  end

  private
  def self.ransackable_scopes(auth_object = nil)
    [:category_search]
  end
end

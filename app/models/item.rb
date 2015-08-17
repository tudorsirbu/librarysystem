require 'csv'
class Item < ActiveRecord::Base
  def self.import
    file = Rails.root.join('db').join('items.csv')

    CSV.foreach(file, :headers => true) do |row|

      item = Item.new
      item.title = row["title"]
      item.isbn = row["isbn"]
      return item
    end
    # header = spreadsheet.row(1)
    # (2..spreadsheet.last_row).each do |i|
    #   # row = Hash[[header, spreadsheet.row(i)].transpose]
    #   # product = find_by_id(row["id"]) || new
    #   # product.attributes = row.to_hash.slice(*accessible_attributes)
    #   # product.save!
    #   puts spreadsheet.row(i).inspect
    # end
  end

  def self.open_spreadsheet(file)
    case File.extname("items.csv")
      when ".csv" then Csv.new(file, nil, :ignore)
      else raise "Unknown file type:items.csv"
    end
  end
end

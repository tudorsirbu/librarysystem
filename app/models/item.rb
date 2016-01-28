require 'csv'
class Item < ActiveRecord::Base
  belongs_to :location
  belongs_to :category
  has_many :loans
  has_many :item_requests

  validates_presence_of :barcode, :title, :year, :category

  def self.import
    items = Rails.root.join('db').join('items.csv')
    barcodes = Rails.root.join('db').join('barcodes.csv')

    CSV.foreach(items, :headers => true,encoding:'windows-1250') do |row_item|
      barcode = nil
      CSV.foreach(barcodes,:headers => true,encoding:'windows-1250') do |row_barcode|
        if row_item["id"] == row_barcode["item_id"]
          barcode = row_barcode["barcode"]
          break
        end
      end
      items_total = row_item["total"]
      # for i in 1..items_total.to_i
      item = Item.new
      item.title = row_item["title"]
      item.category_id = row_item["category_id"]
      item.publisher = row_item["publisher"]
      item.year = row_item["year"]
      item.barcode = barcode
      item.copies = row_item["total"].to_i
      item.location_id = 1
      item.save(validate: false)
      # end

    end

  end

  def self.fImportFile(file)
    CSV.foreach(file.path, headers: true, encoding:'windows-1250') do |row|
      item = find_by_id(row["id"]) || new
      item.title = row["Title"]
      item.publisher = row["Publisher"]
      item.barcode = row["Barcode"]
      item.year = row["Year"] || 9999
      item.category_id = row["Category"].to_i
      item.location_id = 1
      item.copies = row["Quantity"].to_i
      item.save(validate: false)
    end
  end

  def to_label
    if self.category_id
      if self.category.name
        "#{self.barcode || 'Missing barcode'} - #{self.title || 'Missing title'} - #{self.category.name}"
      else
        "#{self.barcode || 'Missing barcode'} - #{self.title || 'Missing title'} - Missing category name"
      end
    else
      "#{self.barcode || 'Missing barcode'} - #{self.title || 'Missing title'}"
    end
  end

  def return(user)
    loans = self.loans.where(returned_on: nil, user: user).order('due_date')
    if loans.nil? || loans.empty?
      false
    else
      loans.first.return!
      requests = self.item_requests.where(user_id: user.id)
      if requests.first
        requests.first.delete
      end
      true
    end
  end

  def notify_oldest_lender(user_id)
    oldest_loan = self.loans.where(returned_on: nil).where.not(user_id: user_id).order('created_at ASC').first
    UserMailer.item_requested(oldest_loan).deliver_now unless oldest_loan.nil?
  end

  def total_available
    loans = self.loans.where(returned_on: nil)
    self.copies - loans.size
  end

  def self.category_search(category)
    joins(:category).where("LOWER(categories.name) LIKE ?","%#{category.downcase}%")
  end

  def self.location_search(location)
    joins(:location).where("CONCAT(locations.building, ' - ',locations.room) LIKE ?","%#{location}%")
  end

  private
  def self.ransackable_scopes(auth_object = nil)
    [:category_search,:location_search]
  end
end

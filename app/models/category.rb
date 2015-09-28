class Category < ActiveRecord::Base
  has_many :items

  def self.import
    categories = Rails.root.join('db').join('categories.csv')

    CSV.foreach(categories, :headers => true,encoding:'windows-1250') do |row_category|

      category = Category.new
      category.name = row_category["name"]
      category.save(validate:false)
    end

  end

  def to_label
    "#{self.name}"
  end
end

class Category < ActiveRecord::Base
has_many :items
  def self.import
    categories = Rails.root.join('db').join('categories.csv')

    CSV.foreach(categories, :headers => true) do |row_category|

      category = Category.new
      category.name = row_category["name"]
      category.save
    end

  end

  def to_label
    "#{self.name}"
  end
end

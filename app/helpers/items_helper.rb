require 'openlibrary'
require 'outpan'
require 'httparty'

module ItemsHelper
  include HTTParty
  default_options.update(verify: false)

  def lookup_by_isbn(item)
    # check if the item's details can be found on open library
    lookup_by_isbn_openlib item

    unless item.valid?
      puts "now looking up on Google"
      lookup_by_isbn_google item
    end

    unless item.valid?
      puts "now looking up on outpan"
      lookup_by_isbn_outpan item
    end

    if !item.valid?
      if !item.title
        item.title = "Title missing"
      end
      if !item.year
        item.year = "Year missing"
      end
      if !item.category_id
        item.category_id = 1
      end
    end

  end


  private
  def lookup_by_isbn_openlib(item)
    # create instance to the oo
    data = Openlibrary::Data

    # lookup the item
    result = data.find_by_isbn item.barcode

    unless result.nil?
      puts result.to_s
      item.title = result.title unless result.title.nil?

      if result.publish_date.to_s.size == 4
        item.year = result.publish_date
      else
        item.year = Time.parse(result.publish_date).year unless result.publish_date.nil? || result.publish_date.empty?
      end
      # item.publisher = result.publishers.map{|p| }
    end
  end

  def lookup_by_isbn_outpan(item)
    result = Outpan.find(item.barcode)
    unless result.nil?
      item.title = result['name'] unless result['name'].nil? || result['name'].empty?

      unless result['attributes'].nil? || result['attributes'].empty?
        book_attributes = result['attributes']
        puts "££££ #{book_attributes['Publication Date'].to_s}"

        if book_attributes['Publication Date'].size == 4
          item.year = book_attributes['Publication Date']
        else
          item.year = Time.parse(book_attributes['Publication Date']).year unless book_attributes['Publication Date'].nil? || book_attributes['Publication Date'].empty?
        end
      end

      item.thumbnail = result['images'].first unless result['images'].nil? || result['images'].empty?
    end
  end

  def lookup_by_isbn_google(item)
    url = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{item.barcode}"
    response = HTTParty.get(url, verify: false)

    if !response.nil? && response['totalItems'] > 0
      puts response
      book = response['items'].first['volumeInfo']
      item.title = book['title'] unless book['title'].nil? || book['title'].empty?

      if book['publishedDate'].size == 4
        item.year = book['publishedDate']
      else
        item.year = Time.parse(book['publishedDate']).year unless  book['publishedDate'].nil? || book['publishedDate'].empty?
      end
      item.category = Category.find_or_create_by(name: book['categories'].first) unless book['categories'].nil? || book['categories'].empty?
      item.thumbnail = book['imageLinks']['smallThumbnail'] unless book['imageLinks']['smallThumbnail'].nil? || book['imageLinks']['smallThumbnail'].empty?
    end
  end

  def lookup_by_isbndb(isbn)
    url = "http://isbndb.com/api/books.xml?access_key=3X55ERZS&index1=isbn&value1=#{isbn}"
    response = HTTParty.get(url)
    response['ISBNdb']['BookList']['BookData']
  end
end

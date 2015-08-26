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
      lookup_by_isbn_google item
    end
  end


  private
  def lookup_by_isbn_openlib(item)
    # create instance to the oo
    data = Openlibrary::Data

    # lookup the item
    result = data.find_by_isbn item.barcode

    unless result.nil?
      item.title = result.title unless result.title.nil?
      item.year = Time.parse(result.publish_date).year unless result.publish_date.nil?
      # item.publisher = result.publishers.map{|p| }
    end
  end

  def lookup_by_isbn_outpan(isbn)
    Outpan.find(isbn)
  end

  def lookup_by_isbn_google(item)
    url = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{item.barcode}"
    response = HTTParty.get(url, verify: false)

    if response['totalItems'] > 0
      book = response['items'].first['volumeInfo']
      item.title = book['title'] unless book['title'].nil? || book['title'].empty?
      item.year = Time.parse(book['publishedDate']).year unless  book['publishedDate'].nil? || book['publishedDate'].empty?
      item.category = Category.find_or_create_by(name: book['categories'].first) unless book['categories'].nil? || book['categories'].empty?
    end
  end

  def lookup_by_isbndb(isbn)
    url = "http://isbndb.com/api/books.xml?access_key=3X55ERZS&index1=isbn&value1=#{isbn}"
    response = HTTParty.get(url)
    response['ISBNdb']['BookList']['BookData']
  end

  def lookup_by_isbn_db(isbn)
    url = "http://www.isbndb.com/api/books.xml?access_key=3X55ERZS&index1=isbn&value1=#{isbn}"
  end

  def lookup_by_isbn_amazon(isbn)
    # url = "http://webservices.amazon.com/onca/xml?
    #                 Service=AWSECommerceService
    #                 &Operation=ItemLookup
    #                 &ResponseGroup=Large
    #                 &SearchIndex=All
    #                 &IdType=ISBN
    #                 &ItemId=076243631X
    #                 &AWSAccessKeyId=AKIAJ6N4SNIJKQXKEEIQ
    #                 &AssociateTag=[Your_AssociateTag]
    #                 &Timestamp=[YYYY-MM-DDThh:mm:ssZ]
    #                 &Signature=[Request_Signature]"

    request = Vacuum.new
    request.configure(aws_access_key_id: 'AKIAJCBD436MLAFS6QHQ', aws_secret_access_key: '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', associate_tag: 'el09e-21')
    response = request.item_lookup(
        query: {
            'IsbnId' => isbn
        }
    )
  end
end

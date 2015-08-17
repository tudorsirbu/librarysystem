json.array!(@items) do |item|
  json.extract! item, :id, :title, :isbn, :category_id, :author_id, :publisher, :year
  json.url item_url(item, format: :json)
end

json.array!(@locations) do |location|
  json.extract! location, :id, :building, :room
  json.url location_url(location, format: :json)
end

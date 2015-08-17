json.array!(@users) do |user|
  json.extract! user, :id, :ucard_no, :surname, :forename, :job_title
  json.url user_url(user, format: :json)
end

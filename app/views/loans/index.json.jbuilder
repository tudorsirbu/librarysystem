json.array!(@loans) do |loan|
  json.extract! loan, :id, :user_id, :item_id, :due_date
  json.url loan_url(loan, format: :json)
end

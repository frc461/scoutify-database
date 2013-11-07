json.array!(@records) do |record|
  json.extract! record, :data, :team_id, :event_id, :user_id
  json.url record_url(record, format: :json)
end

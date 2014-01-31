json.array!(@matches) do |match|
  json.extract! match, :event_id, :match_number
  json.url match_url(match, format: :json)
end

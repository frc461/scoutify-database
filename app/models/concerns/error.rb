module Error
	extend ActiveSupport::Concern

	def tba_error(uri, code, body)
		raise "Error with TBA API:\nURI: #{uri}\nCode: #{code}\nBody: #{body}"
	end
end

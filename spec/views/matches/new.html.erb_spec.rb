require 'spec_helper'

describe "matches/new" do
	before(:each) do
		assign(:match, stub_model(Match,
		                          :event_id => 1,
		                          :match_number => "MyText"
		                          ).as_new_record)
	end

	it "renders new match form" do
		render

		# Run the generator again with the --webrat flag if you want to use webrat matchers
		assert_select "form[action=?][method=?]", matches_path, "post" do
			assert_select "input#match_event_id[name=?]", "match[event_id]"
			assert_select "textarea#match_match_number[name=?]", "match[match_number]"
		end
	end
end

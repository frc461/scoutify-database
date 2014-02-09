require 'spec_helper'

describe "matches/index" do
	before(:each) do
		assign(:matches, [
		                  stub_model(Match,
		                             :event_id => 1,
		                             :match_number => "MyText"
		                             ),
		                  stub_model(Match,
		                             :event_id => 1,
		                             :match_number => "MyText"
		                             )
		                 ])
	end

	it "renders a list of matches" do
		render
		# Run the generator again with the --webrat flag if you want to use webrat matchers
		assert_select "tr>td", :text => 1.to_s, :count => 2
		assert_select "tr>td", :text => "MyText".to_s, :count => 2
	end
end

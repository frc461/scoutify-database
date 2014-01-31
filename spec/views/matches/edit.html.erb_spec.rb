require 'spec_helper'

describe "matches/edit" do
  before(:each) do
    @match = assign(:match, stub_model(Match,
      :event_id => 1,
      :match_number => "MyText"
    ))
  end

  it "renders the edit match form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", match_path(@match), "post" do
      assert_select "input#match_event_id[name=?]", "match[event_id]"
      assert_select "textarea#match_match_number[name=?]", "match[match_number]"
    end
  end
end

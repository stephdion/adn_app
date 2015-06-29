require 'spec_helper'

describe "bodyparts/index" do
  before(:each) do
    assign(:bodyparts, [
      stub_model(Bodypart,
        :name_fr => "Name Fr",
        :code => "Code",
        :description => "Description"
      ),
      stub_model(Bodypart,
        :name_fr => "Name Fr",
        :code => "Code",
        :description => "Description"
      )
    ])
  end

  it "renders a list of bodyparts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name Fr".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end

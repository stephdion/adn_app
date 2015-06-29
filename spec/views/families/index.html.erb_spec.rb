require 'spec_helper'

describe "families/index" do
  before(:each) do
    assign(:families, [
      stub_model(Family,
        :user_id => 1,
        :parent_id => 2,
        :relationship => "Relationship"
      ),
      stub_model(Family,
        :user_id => 1,
        :parent_id => 2,
        :relationship => "Relationship"
      )
    ])
  end

  it "renders a list of families" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Relationship".to_s, :count => 2
  end
end

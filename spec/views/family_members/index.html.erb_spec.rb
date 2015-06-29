require 'spec_helper'

describe "family_members/index" do
  before(:each) do
    assign(:family_members, [
      stub_model(FamilyMember,
        :user_id => 1,
        :member => 2,
        :relationship => "Relationship"
      ),
      stub_model(FamilyMember,
        :user_id => 1,
        :member => 2,
        :relationship => "Relationship"
      )
    ])
  end

  it "renders a list of family_members" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Relationship".to_s, :count => 2
  end
end

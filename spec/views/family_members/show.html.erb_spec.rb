require 'spec_helper'

describe "family_members/show" do
  before(:each) do
    @family_member = assign(:family_member, stub_model(FamilyMember,
      :user_id => 1,
      :member => 2,
      :relationship => "Relationship"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Relationship/)
  end
end

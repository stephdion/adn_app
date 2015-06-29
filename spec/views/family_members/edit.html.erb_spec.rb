require 'spec_helper'

describe "family_members/edit" do
  before(:each) do
    @family_member = assign(:family_member, stub_model(FamilyMember,
      :user_id => 1,
      :member => 1,
      :relationship => "MyString"
    ))
  end

  it "renders the edit family_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => family_members_path(@family_member), :method => "post" do
      assert_select "input#family_member_user_id", :name => "family_member[user_id]"
      assert_select "input#family_member_member", :name => "family_member[member]"
      assert_select "input#family_member_relationship", :name => "family_member[relationship]"
    end
  end
end

require 'spec_helper'

describe "families/edit" do
  before(:each) do
    @family = assign(:family, stub_model(Family,
      :user_id => 1,
      :parent_id => 1,
      :relationship => "MyString"
    ))
  end

  it "renders the edit family form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => families_path(@family), :method => "post" do
      assert_select "input#family_user_id", :name => "family[user_id]"
      assert_select "input#family_parent_id", :name => "family[parent_id]"
      assert_select "input#family_relationship", :name => "family[relationship]"
    end
  end
end

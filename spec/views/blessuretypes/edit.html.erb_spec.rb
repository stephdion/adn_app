require 'spec_helper'

describe "blessuretypes/edit" do
  before(:each) do
    @blessuretype = assign(:blessuretype, stub_model(Blessuretype,
      :name_fr => "MyString",
      :code => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit blessuretype form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => blessuretypes_path(@blessuretype), :method => "post" do
      assert_select "input#blessuretype_name_fr", :name => "blessuretype[name_fr]"
      assert_select "input#blessuretype_code", :name => "blessuretype[code]"
      assert_select "input#blessuretype_description", :name => "blessuretype[description]"
    end
  end
end

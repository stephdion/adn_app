require 'spec_helper'

describe "blessuretypes/new" do
  before(:each) do
    assign(:blessuretype, stub_model(Blessuretype,
      :name_fr => "MyString",
      :code => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new blessuretype form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => blessuretypes_path, :method => "post" do
      assert_select "input#blessuretype_name_fr", :name => "blessuretype[name_fr]"
      assert_select "input#blessuretype_code", :name => "blessuretype[code]"
      assert_select "input#blessuretype_description", :name => "blessuretype[description]"
    end
  end
end

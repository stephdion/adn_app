require 'spec_helper'

describe "test_subcategories/edit" do
  before(:each) do
    @test_subcategory = assign(:test_subcategory, stub_model(TestSubcategory,
      :name => "MyString",
      :test_category_id => 1
    ))
  end

  it "renders the edit test_subcategory form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_subcategories_path(@test_subcategory), :method => "post" do
      assert_select "input#test_subcategory_name", :name => "test_subcategory[name]"
      assert_select "input#test_subcategory_test_category_id", :name => "test_subcategory[test_category_id]"
    end
  end
end

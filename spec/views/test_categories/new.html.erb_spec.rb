require 'spec_helper'

describe "test_categories/new" do
  before(:each) do
    assign(:test_category, stub_model(TestCategory,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new test_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_categories_path, :method => "post" do
      assert_select "input#test_category_name", :name => "test_category[name]"
    end
  end
end

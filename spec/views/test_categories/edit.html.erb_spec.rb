require 'spec_helper'

describe "test_categories/edit" do
  before(:each) do
    @test_category = assign(:test_category, stub_model(TestCategory,
      :name => "MyString"
    ))
  end

  it "renders the edit test_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_categories_path(@test_category), :method => "post" do
      assert_select "input#test_category_name", :name => "test_category[name]"
    end
  end
end

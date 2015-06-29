require 'spec_helper'

describe "test_subcategories/show" do
  before(:each) do
    @test_subcategory = assign(:test_subcategory, stub_model(TestSubcategory,
      :name => "Name",
      :test_category_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
  end
end

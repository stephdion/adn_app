require 'spec_helper'

describe "test_categories/show" do
  before(:each) do
    @test_category = assign(:test_category, stub_model(TestCategory,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end

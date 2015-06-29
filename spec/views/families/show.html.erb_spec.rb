require 'spec_helper'

describe "families/show" do
  before(:each) do
    @family = assign(:family, stub_model(Family,
      :user_id => 1,
      :parent_id => 2,
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

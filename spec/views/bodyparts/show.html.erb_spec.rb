require 'spec_helper'

describe "bodyparts/show" do
  before(:each) do
    @bodypart = assign(:bodypart, stub_model(Bodypart,
      :name_fr => "Name Fr",
      :code => "Code",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name Fr/)
    rendered.should match(/Code/)
    rendered.should match(/Description/)
  end
end

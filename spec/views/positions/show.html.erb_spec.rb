require 'spec_helper'

describe "positions/show" do
  before(:each) do
    @position = assign(:position, stub_model(Position,
      :position => "Position",
      :equipe => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Position/)
    rendered.should match(/1/)
  end
end

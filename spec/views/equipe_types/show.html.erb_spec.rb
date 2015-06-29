require 'spec_helper'

describe "equipe_types/show" do
  before(:each) do
    @equipe_type = assign(:equipe_type, stub_model(EquipeType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end

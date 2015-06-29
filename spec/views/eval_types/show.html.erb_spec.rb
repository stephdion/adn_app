require 'spec_helper'

describe "eval_types/show" do
  before(:each) do
    @eval_type = assign(:eval_type, stub_model(EvalType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end

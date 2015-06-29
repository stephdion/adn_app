require 'spec_helper'

describe "eval_types/index" do
  before(:each) do
    assign(:eval_types, [
      stub_model(EvalType,
        :name => "Name"
      ),
      stub_model(EvalType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of eval_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

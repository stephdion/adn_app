require 'spec_helper'

describe "eval_types/edit" do
  before(:each) do
    @eval_type = assign(:eval_type, stub_model(EvalType,
      :name => "MyString"
    ))
  end

  it "renders the edit eval_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => eval_types_path(@eval_type), :method => "post" do
      assert_select "input#eval_type_name", :name => "eval_type[name]"
    end
  end
end

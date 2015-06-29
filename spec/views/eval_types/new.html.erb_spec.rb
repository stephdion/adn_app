require 'spec_helper'

describe "eval_types/new" do
  before(:each) do
    assign(:eval_type, stub_model(EvalType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new eval_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => eval_types_path, :method => "post" do
      assert_select "input#eval_type_name", :name => "eval_type[name]"
    end
  end
end

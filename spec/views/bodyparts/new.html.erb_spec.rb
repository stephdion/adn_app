require 'spec_helper'

describe "bodyparts/new" do
  before(:each) do
    assign(:bodypart, stub_model(Bodypart,
      :name_fr => "MyString",
      :code => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new bodypart form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bodyparts_path, :method => "post" do
      assert_select "input#bodypart_name_fr", :name => "bodypart[name_fr]"
      assert_select "input#bodypart_code", :name => "bodypart[code]"
      assert_select "input#bodypart_description", :name => "bodypart[description]"
    end
  end
end

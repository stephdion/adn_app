require 'spec_helper'

describe "bodyparts/edit" do
  before(:each) do
    @bodypart = assign(:bodypart, stub_model(Bodypart,
      :name_fr => "MyString",
      :code => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit bodypart form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bodyparts_path(@bodypart), :method => "post" do
      assert_select "input#bodypart_name_fr", :name => "bodypart[name_fr]"
      assert_select "input#bodypart_code", :name => "bodypart[code]"
      assert_select "input#bodypart_description", :name => "bodypart[description]"
    end
  end
end

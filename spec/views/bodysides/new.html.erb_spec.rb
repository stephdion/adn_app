require 'spec_helper'

describe "bodysides/new" do
  before(:each) do
    assign(:bodyside, stub_model(Bodyside,
      :name_fr => "MyString",
      :code => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new bodyside form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bodysides_path, :method => "post" do
      assert_select "input#bodyside_name_fr", :name => "bodyside[name_fr]"
      assert_select "input#bodyside_code", :name => "bodyside[code]"
      assert_select "input#bodyside_description", :name => "bodyside[description]"
    end
  end
end

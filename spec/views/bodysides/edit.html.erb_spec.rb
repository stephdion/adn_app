require 'spec_helper'

describe "bodysides/edit" do
  before(:each) do
    @bodyside = assign(:bodyside, stub_model(Bodyside,
      :name_fr => "MyString",
      :code => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit bodyside form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bodysides_path(@bodyside), :method => "post" do
      assert_select "input#bodyside_name_fr", :name => "bodyside[name_fr]"
      assert_select "input#bodyside_code", :name => "bodyside[code]"
      assert_select "input#bodyside_description", :name => "bodyside[description]"
    end
  end
end

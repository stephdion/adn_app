require 'spec_helper'

describe "equipe_types/new" do
  before(:each) do
    assign(:equipe_type, stub_model(EquipeType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new equipe_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => equipe_types_path, :method => "post" do
      assert_select "input#equipe_type_name", :name => "equipe_type[name]"
    end
  end
end

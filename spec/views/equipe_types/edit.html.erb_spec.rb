require 'spec_helper'

describe "equipe_types/edit" do
  before(:each) do
    @equipe_type = assign(:equipe_type, stub_model(EquipeType,
      :name => "MyString"
    ))
  end

  it "renders the edit equipe_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => equipe_types_path(@equipe_type), :method => "post" do
      assert_select "input#equipe_type_name", :name => "equipe_type[name]"
    end
  end
end

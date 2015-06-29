require 'spec_helper'

describe "positions/new" do
  before(:each) do
    assign(:position, stub_model(Position,
      :position => "MyString",
      :equipe => 1
    ).as_new_record)
  end

  it "renders new position form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => positions_path, :method => "post" do
      assert_select "input#position_position", :name => "position[position]"
      assert_select "input#position_equipe", :name => "position[equipe]"
    end
  end
end

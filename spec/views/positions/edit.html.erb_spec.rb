require 'spec_helper'

describe "positions/edit" do
  before(:each) do
    @position = assign(:position, stub_model(Position,
      :position => "MyString",
      :equipe => 1
    ))
  end

  it "renders the edit position form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => positions_path(@position), :method => "post" do
      assert_select "input#position_position", :name => "position[position]"
      assert_select "input#position_equipe", :name => "position[equipe]"
    end
  end
end

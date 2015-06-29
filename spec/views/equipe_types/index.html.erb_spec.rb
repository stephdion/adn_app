require 'spec_helper'

describe "equipe_types/index" do
  before(:each) do
    assign(:equipe_types, [
      stub_model(EquipeType,
        :name => "Name"
      ),
      stub_model(EquipeType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of equipe_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

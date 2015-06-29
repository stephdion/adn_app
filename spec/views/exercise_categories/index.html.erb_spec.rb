require 'spec_helper'

describe "exercise_categories/index" do
  before(:each) do
    assign(:exercise_categories, [
      stub_model(ExerciseCategory,
        :name => "Name"
      ),
      stub_model(ExerciseCategory,
        :name => "Name"
      )
    ])
  end

  it "renders a list of exercise_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

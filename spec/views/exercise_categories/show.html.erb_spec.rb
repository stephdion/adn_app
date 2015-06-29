require 'spec_helper'

describe "exercise_categories/show" do
  before(:each) do
    @exercise_category = assign(:exercise_category, stub_model(ExerciseCategory,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end

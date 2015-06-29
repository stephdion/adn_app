require 'spec_helper'

describe "exercise_categories/edit" do
  before(:each) do
    @exercise_category = assign(:exercise_category, stub_model(ExerciseCategory,
      :name => "MyString"
    ))
  end

  it "renders the edit exercise_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => exercise_categories_path(@exercise_category), :method => "post" do
      assert_select "input#exercise_category_name", :name => "exercise_category[name]"
    end
  end
end

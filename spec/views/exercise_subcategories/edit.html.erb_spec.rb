require 'spec_helper'

describe "exercise_subcategories/edit" do
  before(:each) do
    @exercise_subcategory = assign(:exercise_subcategory, stub_model(ExerciseSubcategory,
      :name => "MyString",
      :exercise_category_id => 1
    ))
  end

  it "renders the edit exercise_subcategory form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => exercise_subcategories_path(@exercise_subcategory), :method => "post" do
      assert_select "input#exercise_subcategory_name", :name => "exercise_subcategory[name]"
      assert_select "input#exercise_subcategory_exercise_category_id", :name => "exercise_subcategory[exercise_category_id]"
    end
  end
end

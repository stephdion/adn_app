require 'spec_helper'

describe "exercise_categories/new" do
  before(:each) do
    assign(:exercise_category, stub_model(ExerciseCategory,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new exercise_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => exercise_categories_path, :method => "post" do
      assert_select "input#exercise_category_name", :name => "exercise_category[name]"
    end
  end
end

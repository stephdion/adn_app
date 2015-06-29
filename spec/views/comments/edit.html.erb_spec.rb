require 'spec_helper'

describe "comments/edit" do
  before(:each) do
    @comment = assign(:comment, stub_model(Comment,
      [:nom => "",
      :prenom => "",
      :type => "",
      :email => "",
      :telephone => "",
      :other => ""]
    ))
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path(@comment), :method => "post" do
      assert_select "input#comment_[nom", :name => "comment[[nom]"
      assert_select "input#comment_prenom", :name => "comment[prenom]"
      assert_select "input#comment_type", :name => "comment[type]"
      assert_select "input#comment_email", :name => "comment[email]"
      assert_select "input#comment_telephone", :name => "comment[telephone]"
      assert_select "input#comment_other", :name => "comment[other]"
    end
  end
end

require 'spec_helper'

describe "EvalTest pages" do

  subject { page }

  describe "Evaluation test page" do
    let(:eval_test) { FactoryGirl.create(:eval_test) }
    before { visit eval_test_path(user) }

    it { should have_selector('h1',    text: eval_test.name) }
    it { should have_selector('title', text: eval_test.name) }
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:eval_test) }
    before { visit edit_eval_test_path(eval_test) }

    describe "page" do
      it { should have_selector('h1',    text: "Mettre a jour le Test d'Evaluation") }
      it { should have_selector('title', text: "Test-mise a jour") }
    end

    describe "with invalid information" do
      before { click_button "Enregitrer" }

      it { should have_content('error') }
    end
  end
end

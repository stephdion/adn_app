require 'spec_helper'

describe "Authentication" do

  subject { page }

    describe "Ouverture de session" do
      before { visit ouverture_path }

      describe "with invalid information" do
          before { click_button "Ouverture de session" }

          it { should have_selector('h1',    text: 'Ouverture de session') }
          it { should have_selector('title', text: 'Ouverture de session') }

          describe "after visiting another page" do
        	  before { click_link "Home" }
        	  it { should_not have_selector('div.alert.alert-error') }
      		end
        end

      describe "with valid information" do
          let(:user) { FactoryGirl.create(:user) }
          before do
              fill_in "Courriel",    with: user.email.upcase
              fill_in "Mot de passe", with: user.password
              click_button "Ouverture de session"
            end

          it { should have_selector('title', text: user.name) }
          it { should have_link('Profile', href: user_path(user)) }
          it { should have_link('Fermeture de session', href: fermeture_path) }
          it { should have_link('Tests', href: fermeture_path) }
          it { should have_link('Exercices', href: fermeture_path) }
          it { should_not have_link('Ouerture de session', href: ouverture_path) }

          describe "followed by Fermeture de session" do
            before { click_link "Fermeture de session" }
            it { should have_link('Ouverture de session') }
          end
      end
    end
end
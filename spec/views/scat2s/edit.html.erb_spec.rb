require 'spec_helper'

describe "scat2s/edit" do
  before(:each) do
    @scat2 = assign(:scat2, stub_model(Scat2,
      :symptoms_physical => 1,
      :symptoms_mental => 1,
      :behaviour_change => "MyString",
      :unconsciousness => 1,
      :unconsciousness_time => 1,
      :balance_problem => 1,
      :glasgow_eye => 1,
      :glasgow_verbal => 1,
      :glasgow_mouvement => 1,
      :maddocks_state => 1,
      :maddocks_half_time => 1,
      :maddocks_last_goal => 1,
      :maddocks_last_team => 1,
      :maddocks_last_win => 1,
      :cognitive_month => 1,
      :cognitive_date => 1,
      :cognitive_day => 1,
      :cognitive_year => 1,
      :cognitive_hrs => 1,
      :concentration_inverse_month => 1,
      :stability_two_feet => 1,
      :stability_one_foot => 1,
      :stability_feet_aligned => 1,
      :coordination => 1,
      :cognition_differed_memory => 1
    ))
  end

  it "renders the edit scat2 form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => scat2s_path(@scat2), :method => "post" do
      assert_select "input#scat2_symptoms_physical", :name => "scat2[symptoms_physical]"
      assert_select "input#scat2_symptoms_mental", :name => "scat2[symptoms_mental]"
      assert_select "input#scat2_behaviour_change", :name => "scat2[behaviour_change]"
      assert_select "input#scat2_unconsciousness", :name => "scat2[unconsciousness]"
      assert_select "input#scat2_unconsciousness_time", :name => "scat2[unconsciousness_time]"
      assert_select "input#scat2_balance_problem", :name => "scat2[balance_problem]"
      assert_select "input#scat2_glasgow_eye", :name => "scat2[glasgow_eye]"
      assert_select "input#scat2_glasgow_verbal", :name => "scat2[glasgow_verbal]"
      assert_select "input#scat2_glasgow_mouvement", :name => "scat2[glasgow_mouvement]"
      assert_select "input#scat2_maddocks_state", :name => "scat2[maddocks_state]"
      assert_select "input#scat2_maddocks_half_time", :name => "scat2[maddocks_half_time]"
      assert_select "input#scat2_maddocks_last_goal", :name => "scat2[maddocks_last_goal]"
      assert_select "input#scat2_maddocks_last_team", :name => "scat2[maddocks_last_team]"
      assert_select "input#scat2_maddocks_last_win", :name => "scat2[maddocks_last_win]"
      assert_select "input#scat2_cognitive_month", :name => "scat2[cognitive_month]"
      assert_select "input#scat2_cognitive_date", :name => "scat2[cognitive_date]"
      assert_select "input#scat2_cognitive_day", :name => "scat2[cognitive_day]"
      assert_select "input#scat2_cognitive_year", :name => "scat2[cognitive_year]"
      assert_select "input#scat2_cognitive_hrs", :name => "scat2[cognitive_hrs]"
      assert_select "input#scat2_concentration_inverse_month", :name => "scat2[concentration_inverse_month]"
      assert_select "input#scat2_stability_two_feet", :name => "scat2[stability_two_feet]"
      assert_select "input#scat2_stability_one_foot", :name => "scat2[stability_one_foot]"
      assert_select "input#scat2_stability_feet_aligned", :name => "scat2[stability_feet_aligned]"
      assert_select "input#scat2_coordination", :name => "scat2[coordination]"
      assert_select "input#scat2_cognition_differed_memory", :name => "scat2[cognition_differed_memory]"
    end
  end
end

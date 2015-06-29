require 'spec_helper'

describe "scat2s/index" do
  before(:each) do
    assign(:scat2s, [
      stub_model(Scat2,
        :symptoms_physical => 1,
        :symptoms_mental => 2,
        :behaviour_change => "Behaviour Change",
        :unconsciousness => 3,
        :unconsciousness_time => 4,
        :balance_problem => 5,
        :glasgow_eye => 6,
        :glasgow_verbal => 7,
        :glasgow_mouvement => 8,
        :maddocks_state => 9,
        :maddocks_half_time => 10,
        :maddocks_last_goal => 11,
        :maddocks_last_team => 12,
        :maddocks_last_win => 13,
        :cognitive_month => 14,
        :cognitive_date => 15,
        :cognitive_day => 16,
        :cognitive_year => 17,
        :cognitive_hrs => 18,
        :concentration_inverse_month => 19,
        :stability_two_feet => 20,
        :stability_one_foot => 21,
        :stability_feet_aligned => 22,
        :coordination => 23,
        :cognition_differed_memory => 24
      ),
      stub_model(Scat2,
        :symptoms_physical => 1,
        :symptoms_mental => 2,
        :behaviour_change => "Behaviour Change",
        :unconsciousness => 3,
        :unconsciousness_time => 4,
        :balance_problem => 5,
        :glasgow_eye => 6,
        :glasgow_verbal => 7,
        :glasgow_mouvement => 8,
        :maddocks_state => 9,
        :maddocks_half_time => 10,
        :maddocks_last_goal => 11,
        :maddocks_last_team => 12,
        :maddocks_last_win => 13,
        :cognitive_month => 14,
        :cognitive_date => 15,
        :cognitive_day => 16,
        :cognitive_year => 17,
        :cognitive_hrs => 18,
        :concentration_inverse_month => 19,
        :stability_two_feet => 20,
        :stability_one_foot => 21,
        :stability_feet_aligned => 22,
        :coordination => 23,
        :cognition_differed_memory => 24
      )
    ])
  end

  it "renders a list of scat2s" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Behaviour Change".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => 14.to_s, :count => 2
    assert_select "tr>td", :text => 15.to_s, :count => 2
    assert_select "tr>td", :text => 16.to_s, :count => 2
    assert_select "tr>td", :text => 17.to_s, :count => 2
    assert_select "tr>td", :text => 18.to_s, :count => 2
    assert_select "tr>td", :text => 19.to_s, :count => 2
    assert_select "tr>td", :text => 20.to_s, :count => 2
    assert_select "tr>td", :text => 21.to_s, :count => 2
    assert_select "tr>td", :text => 22.to_s, :count => 2
    assert_select "tr>td", :text => 23.to_s, :count => 2
    assert_select "tr>td", :text => 24.to_s, :count => 2
  end
end

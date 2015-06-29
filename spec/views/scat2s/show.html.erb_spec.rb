require 'spec_helper'

describe "scat2s/show" do
  before(:each) do
    @scat2 = assign(:scat2, stub_model(Scat2,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Behaviour Change/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
    rendered.should match(/10/)
    rendered.should match(/11/)
    rendered.should match(/12/)
    rendered.should match(/13/)
    rendered.should match(/14/)
    rendered.should match(/15/)
    rendered.should match(/16/)
    rendered.should match(/17/)
    rendered.should match(/18/)
    rendered.should match(/19/)
    rendered.should match(/20/)
    rendered.should match(/21/)
    rendered.should match(/22/)
    rendered.should match(/23/)
    rendered.should match(/24/)
  end
end

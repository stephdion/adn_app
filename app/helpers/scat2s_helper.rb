module Scat2sHelper

  $scat2_symptoms = Array.new [
                             [I18n.t(:scat2_symp_headache),               'scat2_symp_headache'],
                             [I18n.t(:scat2_symp_pressure_head),          'scat2_symp_pressure_head'],
                             [I18n.t(:scat2_symp_pain_neck),              'scat2_symp_pain_neck'],
                             [I18n.t(:scat2_symp_nausea),                 'scat2_symp_nausea'],
                             [I18n.t(:scat2_symp_dizziness),              'scat2_symp_dizziness'],
                             [I18n.t(:scat2_symp_blurred_vision),         'scat2_symp_blurred_vision'],
                             [I18n.t(:scat2_symp_balance_problem),        'scat2_symp_balance_problem'],
                             [I18n.t(:scat2_symp_sensitivity_light),      'scat2_symp_sensitivity_light'],
                             [I18n.t(:scat2_symp_sensitivity_noise),      'scat2_symp_sensitivity_noise'],
                             [I18n.t(:scat2_symp_feeling_idle),           'scat2_symp_feeling_idle'],
                             [I18n.t(:scat2_symp_feeling_fog),            'scat2_symp_feeling_fog'],
                             [I18n.t(:scat2_symp_anomaly_sensation),      'scat2_symp_anomaly_sensation'],
                             [I18n.t(:scat2_symp_concentration_problem),  'scat2_symp_concentration_problem'],
                             [I18n.t(:scat2_symp_memory_problem),         'scat2_symp_memory_problem'],
                             [I18n.t(:scat2_symp_tired),                  'scat2_symp_tired'],
                             [I18n.t(:scat2_symp_confused),               'scat2_symp_confused'],
                             [I18n.t(:scat2_symp_drowsiness),             'scat2_symp_drowsiness'],
                             [I18n.t(:scat2_symp_difficulty_sleep),       'scat2_symp_difficulty_sleep'],
                             [I18n.t(:scat2_symp_emotionality),           'scat2_symp_emotionality'],
                             [I18n.t(:scat2_symp_irritability),           'scat2_symp_irritability'],
                             [I18n.t(:scat2_symp_sadness),                'scat2_symp_sadness'],
                             [I18n.t(:scat2_symp_nervousness),            'scat2_symp_nervousness'],
                         ]

  $scat2_side = Array.new [
                              [I18n.t(:scat2_side_right),             'scat2_side_right'],
                              [I18n.t(:scat2_side_left),              'scat2_side_left'],
                          ]

  $scat2_esti = Array.new [
                              [I18n.t(:scat2_esti_unchanged),             'scat2_esti_unchanged'],
                              [I18n.t(:scat2_esti_very_diff),             'scat2_esti_very_diff'],
                              [I18n.t(:scat2_esti_unknown),               'scat2_esti_unknown'],
                          ]

  $yesno = Array.new [
                         [I18n.t(:cd_yes), "cd_yes"],
                         [I18n.t(:cd_no), "cd_no"],
                     ]

  def get_value value, arrayValues
    if arrayValues
      arrayValues.each {
          |arrayValue|
        if arrayValue[1] == value
          return arrayValue[0]
        end
      }
    end
    return ""
  end

end

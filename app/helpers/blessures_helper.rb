module BlessuresHelper


  $operation= Array.new [
                            [I18n.t(:blessure_op_na), 'op_na'],
                            [I18n.t(:blessure_op_todo), 'op_todo'],
                            [I18n.t(:blessure_op_done), 'op_done'],
                         ]

  $mechanism = Array.new [
                             [I18n.t(:blessure_mch_dirch), 'mch_dirch'],
                             [I18n.t(:blessure_mch_ctc), 'mch_ctc'],
                             [I18n.t(:blessure_mch_noctc), 'mch_noctc'],
                             [I18n.t(:blessure_mch_rcp), 'mch_rcp'],
                             [I18n.t(:blessure_mch_cht), 'mch_cht'],
                             [I18n.t(:blessure_mch_cnt_bd), 'mch_cnt_bd'],
                         ]

  $surface = Array.new [
                           [I18n.t(:blessure_sf_gym), 'sf_gym'],
                           [I18n.t(:blessure_sf_grasssynth), 'sf_grasssynth'],
                           [I18n.t(:blessure_sf_grassnat), 'sf_grassnat'],
                           [I18n.t(:blessure_sf_glass), 'sf_glass'],
                           [I18n.t(:blessure_sf_other), 'sf_other'],
                       ]

  $symptomes = Array.new [
                             [I18n.t(:blessure_sp_saign), 'sp_saign'],
                             [I18n.t(:blessure_sp_visem), 'sp_visem'],
                             [I18n.t(:blessure_sp_ecc), 'sp_ecc'],
                             [I18n.t(:blessure_sp_crp), 'sp_crp'],
                             [I18n.t(:blessure_sp_etour), 'sp_etour'],
                             [I18n.t(:blessure_sp_fevr), 'sp_fevr'],
                             [I18n.t(:blessure_sp_head), 'sp_head'],
                             [I18n.t(:blessure_sp_dlprof), 'sp_dlprof'],
                             [I18n.t(:blessure_sp_dlart), 'sp_dlart'],
                             [I18n.t(:blessure_sp_dlmusc), 'sp_dlmusc'],
                             [I18n.t(:blessure_sp_dltend), 'sp_dltend'],
                             [I18n.t(:blessure_sp_infl), 'sp_infl'],
                             [I18n.t(:blessure_sp_other), 'sp_other'],
                         ]
  $yesno = Array.new [
                             [I18n.t(:c7777d_yes), true],
                             [I18n.t(:cd_no), false],
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

  def sport_name blessure
    if blessure && blessure.equipe_type_id
      return blessure.equipe_type.name
    end
  end

  def get_values value, arrayValues
    response = ""
    if value && arrayValues
      arrayValues.each {
          |arrayValue|
        if value.include? arrayValue[1]
          response += arrayValue[0] + ', '
        end
      }
      return response
    end
  end

  def correct_blessure_user?(id)
   blessure = Blessure.find(id)
   if @blessure.user
      @user = User.find(@blessure.user.id)
      return current_user?(@user)
   else
      return is_current_user_sysadmin?
   end
  end

  def build_injuries_map(blessures)
    injuriesmap = {}

    blessures.each do |blessure|

      code = blessure.partie_du_corp
      if code == "bp_ankle" || code == "bp_toe"
        code = "bp_ft"
      end
      if code == "bp_wrist" || code == "bp_fnt"
             code = "bp_hand"
      end
      if code == "bp_ischio"
        code = "bp_thigh"
      end
      if code == "bp_face"
        code = "bp_head"
      end
      if !blessure.cote_du_corp.nil? and !blessure.cote_du_corp.empty? and blessure.cote_du_corp != "bs_na"
        code += "_" + blessure.cote_du_corp
      end

      if !injuriesmap.has_key? code
        injuriesmap[code] = []
      end
      injuriesmap[code].push(blessure)
    end
    return injuriesmap
  end

  def nb_injuries(values)
    if values
      return values.length
    else
      return "";
    end
  end

  def list_injuries(values)
     response = ""
    if values
      values.each do |value|
        response += value.type_de_blessure_name + "\n"
      end
    end
    return response;
  end

end

class Scat2sController < ApplicationController
  include SessionsHelper

  before_filter :deny_athlete, only: [:index]
  before_filter :is_scat2_owner_or_admin?,   only: [:edit, :update, :destroy, :show]

  # GET /scat2s
  # GET /scat2s.json
  def index
    @scat2s = Scat2.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scat2s }
    end
  end

  # GET /scat2s/1
  # GET /scat2s/1.json
  def show
    @scat2 = Scat2.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scat2 }
    end
  end

  # GET /scat2s/new
  # GET /scat2s/new.json
  def new
    @scat2 = Scat2.new
    @scat2.owner_id = current_user.id;
    @scat2.incident_datetime = DateTime.now
    @scat2.evaluation_datetime = DateTime.now

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scat2 }
    end
  end

  # GET /scat2s/1/edit
  def edit
    @scat2 = Scat2.find(params[:id])
  end

  # POST /scat2s
  # POST /scat2s.json
  def create
    @scat2 = Scat2.new(scat2_params)

    respond_to do |format|

      @scat2.incident_datetime   = @scat2.s_to_date(params[:incident_datetime])
      @scat2.evaluation_datetime = @scat2.s_to_date(params[:evaluation_datetime])

      process_params(params)

      if @scat2.save
        format.html { redirect_to @scat2, notice: 'Scat2 was successfully created.' }
        format.json { render json: @scat2, status: :created, location: @scat2 }
      else
        format.html { render action: "new" }
        format.json { render json: @scat2.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scat2s/1
  # PATCH/PUT /scat2s/1.json
  def update
    @scat2 = Scat2.find(params[:id])

    @scat2.incident_datetime   = @scat2.s_to_date(params[:incident_datetime])
    @scat2.evaluation_datetime = @scat2.s_to_date(params[:evaluation_datetime])

    process_params(params)

    respond_to do |format|
      if @scat2.update_attributes(scat2_params)
        format.html { redirect_to @scat2, notice: 'Scat2 was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scat2.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scat2s/1
  # DELETE /scat2s/1.json
  def destroy
    @scat2 = Scat2.find(params[:id])
    @scat2.destroy

    respond_to do |format|
      format.html { redirect_to scat2s_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def scat2_params
      params.require(:scat2).permit(:balance_problem, :behaviour_change, :cognition_differed_memory, :cognitive_date,
                                    :cognitive_day, :cognitive_hrs, :cognitive_month, :cognitive_year,
                                    :concentration_inverse_month, :coordination, :glasgow_eye, :glasgow_mouvement,
                                    :glasgow_verbal, :maddocks_half_time, :maddocks_last_goal, :maddocks_last_team,
                                    :maddocks_last_win, :maddocks_state, :stability_feet_aligned, :stability_one_foot,
                                    :stability_two_feet, :symptoms_mental, :symptoms_physical, :unconsciousness,
                                    :unconsciousness_time, :user_id, :owner_id, :equipe_type_id, :incident_datetime, :evaluation_datetime,
                                    :hand_tested, :foot_tested, :return_to_competition)
    end

  def process_params(params)
    params[:symp].each do |value|
        symptom = @scat2.scat2_symptoms.where(code: value[0]).first
        if(symptom==nil && value[1]!=nil && value[1]!="")
          symptom = @scat2.scat2_symptoms.build
        end
        if(value[1]!=nil && value[1]!="")
          symptom.code = value[0];
          symptom.value = value[1];
        elsif(symptom!=nil && (value[1]==nil || value[1]==""))
          symptom.delete
        end
    end

    params[:memory].each do |value|
      memory = @scat2.scat2_memories.where(code: value[0]).first
      if(memory==nil && value[1]=="1")
        memory = @scat2.scat2_memories.build
      end
      if(value[1]=="1")
        memory.code = value[0];
        memory.value = value[1];
      elsif(value[1]=="0" && memory!=nil)
        memory.delete;
      end
    end

    params[:concentration].each do |value|
      concentration = @scat2.scat2_concentrations.where(code: value[0]).first
      if(concentration==nil && value[1]=="1")
        concentration = @scat2.scat2_concentrations.build
      end
      if(value[1]=="1")
        concentration.code = value[0];
        concentration.value = value[1];
      elsif(value[1]=="0" && concentration!=nil)
        concentration.delete;
      end
    end

    params[:cognition].each do |value|
      cognition = @scat2.scat2_cognitions.where(code: value[0]).first
      if(cognition==nil && value[1]=="1")
        cognition = @scat2.scat2_cognitions.build
      end
      if(value[1]=="1")
        cognition.code = value[0];
        cognition.value = value[1];
      elsif(value[1]=="0" && cognition!=nil)
        cognition.delete;
      end
    end
  end

  def is_scat2_owner_or_admin?
    if current_user.id != Scat2.find(params['id']).user_id &&
        is_current_user_in_role?("ATHLETE")
      redirect_to ouverture_url, notice: I18n.t(:general_access_denied)
    end
  end

end

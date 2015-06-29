class ParticipationsController < ApplicationController

  #no filters necessary - this model has no routes 

  def edit_multiple
    @equipe = Equipe.find(params[:id])
    @participations = @equipe.participations
    @positions = @equipe.equipe_type.positions + Position.where(:equipe_type_id => nil)
  end

  def update_multiple
    Participation.update(params[:participations].keys, params[:participations].values)
    redirect_to equipe_path(params[:equipe_id])
  end

  def edit_archives
    @equipe = Equipe.find(params[:id])
    @participations = @equipe.participations('archives').includes(:user)
  end
  
  def update_archives
    date_format_incorrect = false
    created_at_empty = false
    params[:participations].each do |athlete|
      if athlete[1][:created_at] != ""
        begin
          athlete[1][:created_at] = Date.parse(athlete[1][:created_at])
        rescue
          date_format_incorrect = true
        end
      else
        created_at_empty = true
      end
      if athlete[1][:archived] != ""
        begin
          athlete[1][:archived] = Date.parse(athlete[1][:archived])
        rescue
          date_format_incorrect = true
        end
      else
        athlete[1][:archived] = nil
      end
    end

    if date_format_incorrect
      flash[:notice] = I18n.t(:equipe_date_format_error)
      redirect_to :back
    elsif created_at_empty
      flash[:notice] = I18n.t(:equipe_archives_created_at)
      redirect_to :back
    else
      params[:participations].each do |athlete|
        part = Participation.find(athlete[0])
        part.archived = athlete[1][:archived]
        part.created_at = athlete[1][:created_at]
        part.save
      end
      #Participation.update(params[:participations].keys, params[:participations].values)
      redirect_to equipe_path(params[:equipe_id])
    end

  end
  

  end
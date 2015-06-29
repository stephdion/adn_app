# == Schema Information
#
# Table name: scat2s
#
#  id                          :integer          not null, primary key
#  user_id                     :integer          not null
#  equipe_type_id              :integer          not null
#  incident_datetime           :datetime         not null
#  evaluation_datetime         :datetime         not null
#  owner_id                    :integer          not null
#  symptoms_physical           :integer
#  symptoms_mental             :integer
#  behaviour_change            :string(255)
#  unconsciousness             :integer
#  unconsciousness_time        :integer
#  balance_problem             :integer
#  glasgow_eye                 :integer
#  glasgow_verbal              :integer
#  glasgow_mouvement           :integer
#  maddocks_state              :integer
#  maddocks_half_time          :integer
#  maddocks_last_goal          :integer
#  maddocks_last_team          :integer
#  maddocks_last_win           :integer
#  cognitive_month             :integer
#  cognitive_date              :integer
#  cognitive_day               :integer
#  cognitive_year              :integer
#  cognitive_hrs               :integer
#  concentration_inverse_month :integer
#  stability_two_feet          :integer
#  stability_one_foot          :integer
#  stability_feet_aligned      :integer
#  coordination                :integer
#  cognition_differed_memory   :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  foot_tested                 :string(255)
#  hand_tested                 :string(255)
#  symptoms_worst_physical     :integer
#  symptoms_worst_mental       :integer
#  global_estimation           :string(255)
#  return_to_competition       :string(255)
#

class Scat2 < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, class_name: "User"
  belongs_to :equipe_type

  has_many :scat2_symptoms
  has_many :scat2_memories
  has_many :scat2_concentrations
  has_many :scat2_cognitions

  validates :user_id, presence: true
  validates :equipe_type_id, presence: true
  validates :evaluation_datetime, presence: true
  validates :incident_datetime, presence: true

  def get_symp_value(code)
    symptom = self.scat2_symptoms.where(code: code).first
    if(symptom!=nil)
      return symptom.value
    end
    return nil
  end

  def get_memory_value(code)
    memory = self.scat2_memories.where(code: code).first
    if(memory!=nil)
      return memory.value==1
    end
    return false
  end

  def get_concentration_value(code)
    concentration = self.scat2_concentrations.where(code: code).first
    if(concentration!=nil)
      return concentration.value==1
    end
    return false
  end

  def get_cognition_value(code)
    cognition = self.scat2_cognitions.where(code: code).first
    if(cognition!=nil)
      return cognition.value==1
    end
    return false
  end

  def get_score_symptoms
    return  (22-self.scat2_symptoms.where("value!=0").size)
  end

  def get_score_symptoms_severity
    score = 0;
    self.scat2_symptoms.each do |symptom|
      score += symptom.value
    end
    return score;
  end

  def get_score_physical
    score = 2;
    score -= self.unconsciousness;
    score -= self.balance_problem;
    return score;
  end

  def get_score_glasgow
    score = 0;
    if(self.glasgow_eye!=nil)
      score += self.glasgow_eye;
    end
    if(self.glasgow_mouvement!=nil)
      score += self.glasgow_mouvement;
    end
    if(self.glasgow_verbal!=nil)
      score += self.glasgow_verbal;
    end
    return score;
  end

  def get_score_stability
    score = 0;
    if(self.stability_two_feet!=nil)
      score+=self.stability_two_feet;
    end
    if(self.stability_one_foot!=nil)
      score+=self.stability_one_foot;
    end
    if(self.stability_feet_aligned!=nil)
      score+=self.stability_feet_aligned;
    end
    return score;
  end

  def get_score_coordination
    return self.coordination;
  end

  def get_score_sub_total
    score = 0;
    score += get_score_symptoms
    score += get_score_physical
    score += get_score_glasgow
    score += get_score_stability

    score += get_score_coordination;
    return score;
  end

  def get_score_concentration
    return self.scat2_concentrations.where("value=1").size;
  end

  def get_score_memory
    return self.scat2_memories.where("value=1").size;
  end

  def get_score_cognition
    return [self.scat2_cognitions.where("value=1").size, 5].min
  end

  def get_score_orientation
    score = 0;
    score += self.cognitive_date;
    score += self.cognitive_day;
    score += self.cognitive_hrs;
    score += self.cognitive_month;
    score += self.cognitive_year;
    return score;
  end

  def get_score_sac
    score = 0;
    score += get_score_orientation

    score += get_score_memory;
    score += get_score_concentration;

    score += get_score_cognition;

    return score;
  end

  def get_score_scat2_total
    return get_score_sac+get_score_sub_total
  end

  def get_score_maddocks
    score = 0;
    score += self.maddocks_half_time;
    score += self.maddocks_last_goal;
    score += self.maddocks_last_team;
    score += self.maddocks_last_win;
    score += self.maddocks_state;

    return score;
  end

  def get_score
    return get_score_scat2_total+get_score_maddocks;
  end

  def date_to_s(date)
    return date!=nil ? date.strftime("%Y-%m-%d %H:%M") : nil
  end

  def s_to_date(dateStr)
    return dateStr!=nil ? DateTime.strptime(dateStr, "%Y-%m-%d %H:%M") : nil
  end
end

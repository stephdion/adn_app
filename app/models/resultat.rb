# == Schema Information
#
# Table name: resultats
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  equipe_id     :integer
#  athlete_id    :integer
#  evaluation_id :integer
#  eval_test_id  :integer
#  value         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contacted     :boolean
#  component     :integer
#  left_side     :integer
#

class Resultat < ActiveRecord::Base
    belongs_to :user
    belongs_to :athlete, :class_name => "User", :foreign_key => "athlete_id"
    belongs_to :equipe
    belongs_to :evaluation
    belongs_to :eval_test

    validate :validate_created_at_string

    public

    # use string_agg for PostgreSQL and group_concat for mysql

    def self.get_evaluation_results(eval_id, user_id, athlete_id, equipe_id, timestamp, time_offset, order)
        if order == "exercise_order"
            order_string = "test_sets.exercise_order ASC"
        else
            order_string = "test_sets.test_order ASC"
        end
        if equipe_id
            Resultat.joins('INNER JOIN test_sets ON resultats.eval_test_id = test_sets.eval_test_id AND resultats.evaluation_id = test_sets.evaluation_id').
                where(:evaluation_id => eval_id,
                      :user_id => user_id,
                      :created_at => (timestamp - 1.minute)..(timestamp + 1.minute),
                      :equipe_id => equipe_id).
                      order(order_string)
        else
            Resultat.joins('INNER JOIN test_sets ON resultats.eval_test_id = test_sets.eval_test_id AND resultats.evaluation_id = test_sets.evaluation_id').
                where(:evaluation_id => eval_id,
                      :user_id => user_id,
                      :created_at => (timestamp - 1.minute)..(timestamp + 1.minute),
                      :athlete_id => athlete_id).
                      order(order_string)
        end
    end



    def self.index_equipe(equipes)
        joins(:evaluation, :user, :equipe)
        .select("date(resultats.created_at) as eval_day,
             resultats.evaluation_id,
             resultats.equipe_id,
             resultats.user_id as admin_id,
             min(resultats.id) as resultat_id,
             string_agg(evaluations.name, ',') as evaluation_name,
             string_agg(users.first_name, ',') as user_first_name,
             string_agg(users.last_name, ',') as user_last_name,
             string_agg(equipes.name, ',') as equipe_name,
             min(equipes.user_id) as equipe_admin")
        .group("eval_day, resultats.evaluation_id, resultats.equipe_id, resultats.user_id")
        .where("equipe_id IN (?)", equipes)
        .order("eval_day DESC")
    end

    def self.index_individual(athletes)
        joins(:evaluation, :user, :athlete)
        .select("date(resultats.created_at) as eval_day,
             resultats.evaluation_id,
             resultats.athlete_id,
             resultats.user_id,
             min(resultats.id) as resultat_id,
             string_agg(evaluations.name, ',') as evaluation_name,
             string_agg(users.first_name, ',') as user_first_name,
             string_agg(users.last_name, ',') as user_last_name,
             string_agg(athletes_resultats.first_name, ',') as athlete_first_name,
             string_agg(athletes_resultats.last_name, ',') as athlete_last_name,
             sum((resultats.value + resultats.left_side%100)*resultats.component) as score")
        .group("eval_day, resultats.athlete_id, resultats.evaluation_id, resultats.user_id")
        .where("equipe_id IS NULL AND athlete_id IN (?)", athletes)
        .order("eval_day DESC")
    end

    def self.index_detail(eval_id, evaluator, equipe_id, timestamp)
        joins(:evaluation, :user, :athlete)
        .where(:evaluation_id => eval_id,
               :user_id => evaluator,
               :equipe_id => equipe_id,
               :created_at => (timestamp - 12.hours)..(timestamp + 12.hours))
        .select("athlete_id,
             equipe_id,
             min(resultats.created_at) as created_at,
             min(resultats.evaluation_id) as evaluation_id,
             min(resultats.user_id) as user_id,
             min(resultats.id) as resultat_id,
             sum((resultats.value + resultats.left_side%100)*resultats.component) as score,
             string_agg(athletes_resultats.first_name, ',') as athlete_first_name,
             string_agg(athletes_resultats.last_name, ',') as athlete_last_name")
        .group("athlete_id, equipe_id")
        .order("equipe_id ASC")
    end

    def self.dashboard(athletes, eval_id, date_from, date_to)
        joins(:evaluation, :user, :athlete)
        .where("athlete_id IN (?) AND evaluation_id = ? AND (resultats.created_at BETWEEN ? AND ?)", athletes, eval_id, date_from, date_to)
        .select("athlete_id,
             date(resultats.created_at) as eval_day,
             min(resultats.evaluation_id) as evaluation_id,
             sum((resultats.value + resultats.left_side%100)*resultats.component) as score,
             sum(
              CASE
                WHEN (resultats.value * resultats.left_side) = 0 THEN 0
                WHEN (resultats.left_side%100) = 0 THEN 0
                ELSE
                  abs(resultats.value-resultats.left_side)
                END) as differential,
             string_agg(athletes_resultats.first_name, ',') as athlete_first_name,
             string_agg(athletes_resultats.last_name, ',') as athlete_last_name")
        .group("eval_day, athlete_id")
    end

    def self.dashboard_by_eval_test(athletes, eval_id, eval_test_id, date_from, date_to)
        joins(:evaluation, :user, :athlete, :eval_test)
        .where("athlete_id IN (?) AND evaluation_id = ? AND eval_test_id = ? AND (resultats.created_at BETWEEN ? AND ?)", athletes, eval_id, eval_test_id, date_from, date_to)
        .select("athlete_id,
             date(resultats.created_at) as eval_day,
             min(resultats.evaluation_id) as evaluation_id,
             sum((resultats.value + resultats.left_side%100)*resultats.component) as score,
             sum(
              CASE
                WHEN (resultats.value * resultats.left_side) = 0 THEN 0
                WHEN (resultats.left_side%100) = 0 THEN 0
                ELSE
                  abs(resultats.value-resultats.left_side)
                END) as differential,
             string_agg(athletes_resultats.first_name, ',') as athlete_first_name,
             string_agg(athletes_resultats.last_name, ',') as athlete_last_name")
        .group("eval_day, athlete_id")
    end

    def self.injuries(athletes, eval_id, date_from, date_to)
        joins(:evaluation, :user, :athlete, :eval_test)
        .where("athlete_id IN (?) AND evaluation_id = ? AND (value = 0 OR left_side = 0) AND (resultats.created_at BETWEEN ? AND ?)", athletes, eval_id, date_from, date_to)
        .select("athlete_id,
               date(resultats.created_at) as eval_day,
               evaluations.name as evaluation_name,
               resultats.value as right_side,
               resultats.left_side as left_side,
               eval_tests.name as test_name,
               athletes_resultats.first_name as athlete_first_name,
               athletes_resultats.last_name as athlete_last_name")
        .order("eval_day DESC")
    end

    def self.special_cases(athletes, eval_test_id, value, date_from, date_to)
        joins(:user, :athlete, :eval_test, :evaluation)
        .where("athlete_id IN (?) AND eval_test_id = ? AND (value = ? OR left_side = ?) AND (resultats.created_at BETWEEN ? AND ?)", athletes, eval_test_id, value, value, date_from, date_to)
        .select("athlete_id,
               date(resultats.created_at) as eval_day,
               evaluations.name as evaluation_name,
               eval_tests.name as test_name,
               resultats.value as right_side,
               resultats.left_side as left_side,
               athletes_resultats.first_name as athlete_first_name,
               athletes_resultats.last_name as athlete_last_name")
        .order("eval_day DESC")
    end

    def self.left_right(athletes, eval_id, date_from, date_to)
        joins(:user, :athlete, :eval_test, :evaluation)
        .where("athlete_id IN (?) AND evaluation_id = ? AND (abs(value - left_side) = 2) AND (value != 0) AND (left_side != 0) AND (resultats.created_at BETWEEN ? AND ?)", athletes, eval_id, date_from, date_to)
        .select("athlete_id,
               date(resultats.created_at) as eval_day,
               evaluations.name as evaluation_name,
               eval_tests.name as test_name,
               resultats.value as right_side,
               resultats.left_side as left_side,
               athletes_resultats.first_name as athlete_first_name,
               athletes_resultats.last_name as athlete_last_name")
        .order("eval_day DESC")
    end

    def self.get_graph_stats_by_test(all_athletes, eval_id, date_from, date_to)
      joins(:user, :athlete, :eval_test, :evaluation)
      .where("athlete_id IN (?) AND evaluations.id = ? AND (resultats.created_at BETWEEN ? AND ?)", all_athletes, eval_id, date_from, date_to)
      .select('SUM(case when resultats.left_side < 99 then resultats.left_side else 0 end) AS nbr_left, 
               SUM(case when resultats.value < 99 then resultats.value else 0 end) AS nbr_value, 
               eval_tests.short_name,
               eval_tests.name, 
               eval_tests.id')
      .group("eval_tests.short_name, eval_tests.name, eval_tests.id")
    end

    def self.get_graph_stats_by_eval_test(all_athletes, eval_id, eval_test_id, date_from, date_to)
      joins(:user, :athlete, :eval_test, :evaluation)
      .where("athlete_id IN (?) AND evaluations.id = ? AND eval_test_id = ? AND (resultats.created_at BETWEEN ? AND ?)", all_athletes, eval_id, eval_test_id, date_from, date_to)
      .select('SUM(case when resultats.left_side < 100 then resultats.left_side else 0 end) AS nbr_left, 
               SUM(case when resultats.value < 99 then resultats.value else 0 end) AS nbr_value, 
               eval_tests.short_name, 
               eval_tests.name, 
               eval_tests.id')
      .group("eval_tests.short_name, eval_tests.name, eval_tests.id")
    end

    def self.resultat_records_for_update(creation_time, user_id, athlete_id, equipe_id)
        if equipe_id == nil
            where(:created_at => (creation_time - 1.minute)..(creation_time + 1.minute))
            .where(:user_id => user_id, :athlete_id => athlete_id)
        else
            where(:created_at => (creation_time - 1.minute)..(creation_time + 1.minute))
            .where(:user_id => user_id, :equipe_id => equipe_id)
        end
    end

    def evaluation_equipe?
        if self.equipe_id == nil
            return false
        else
            return true
        end
    end

    def read_attribute_name(attribute)
        if read_attribute(attribute)
            attribute = read_attribute(attribute)
            if attribute.include?(",")
                return attribute.split(',')[0]
            else
                return attribute
            end
        else return false
        end
    end

    def athlete_name
        if self.athlete_id == nil
            return I18n.t(:evaluation_equipe)
        elsif read_attribute_name('athlete_first_name') && read_attribute_name('athlete_last_name')
            return (read_attribute_name('athlete_first_name') + " " + read_attribute_name('athlete_last_name'))
        elsif self.athlete
            return self.athlete.name
        else
            return I18n.t(:general_unknown)
        end
    end

    def equipe_name
        if self.equipe_id == nil
            return I18n.t(:evaluation_athlete)
        elsif read_attribute_name('equipe_name')
            return read_attribute_name('equipe_name')
        elsif self.equipe
            return self.equipe.name
        else
            return I18n.t(:general_unknown)
        end
    end

    def evaluation_name
        if read_attribute_name('evaluation_name')
            return read_attribute_name('evaluation_name')
        elsif self.evaluation
            return self.evaluation.name
        else
            return I18n.t(:general_unknown)
        end
    end

    def user_name
        if read_attribute_name('user_first_name') && read_attribute_name('user_last_name')
            return read_attribute_name('user_first_name') + " " + read_attribute_name('user_last_name')
        elsif self.user
            return self.user.name
        else
            return I18n.t(:general_unknown)
        end
    end

    def left
        return self.left_side
    end

    def left_to_s
        if !self.left_side.nil? && self.left_side < 99
            return self.left_side
        else
            return I18n.t(:resultats_incomplete)
        end
    end

    def right
        return self.value
    end

    def right_to_s
        if self.value < 99
            return self.value
        else
            return I18n.t(:resultats_incomplete)
        end
    end

    def value_to_s
        self.right_to_s
    end

    def left=(val)
        self.left_side = val
    end

    def right=(val)
        return self.value = val
    end

    def print_exercises?
        if ((!self.left_side.nil?) && (self.left_side > 0) && (self.left_side < 3)) ||
            ((!self.value.nil?) && (self.value > 0) && (self.value < 3))
            return true
        else
            return false
        end
    end

    def left_right?
        if self.left_side == 100
            return false
        else
            return true
        end
    end

    def message(message)
        if message == "left"
            value = self.left
        elsif message == "right"
            value = self.right
        elsif message == "message"
            value = self.value
        else
            return "error"
        end
        if value == 3
            return self.evaluation.point_desc3
        elsif value == 2
            return self.evaluation.point_desc2
        elsif value == 1
            return self.evaluation.point_desc1
        elsif value == 0
            return self.evaluation.point_desc0
        else
            return value
        end
    end

    def get_prescription(message)
        if message == "left"
            value = self.left
        elsif message == "right"
            value = self.right
        elsif message == "message"
            value = self.value
        else
            return "error"
        end
        if value == 3
            return self.evaluation.point_presc3
        elsif value == 2
            return self.evaluation.point_presc2
        elsif value == 1
            return self.evaluation.point_presc1
        elsif value == 0
            return self.evaluation.point_presc0
        else
            return value
        end
    end

    def init_values(test)
        if test.component
            self.component = 0
        else
            self.component = 1
        end
        if test.left_right
            self.left = 99
            self.right = 99
        else
            self.left = 100
            self.right = 99
        end
    end

    def created_at_string
        if created_at.nil?
            @invalid_string
        else
            created_at.strftime("%Y-%m-%d %H:%M")
        end
    end

    def created_at_string=(created_at_str)
        self.created_at = Time.parse(created_at_str)
    rescue ArgumentError
        @created_at_invalid = true
        @invalid_string = created_at_str
    end

    def validate_created_at_string
        errors.add(:created_at, I18n.t(:error_in_date_format)) if @created_at_invalid
    end

end

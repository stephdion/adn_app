require "spec_helper"

describe ExerciseCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/exercise_categories").should route_to("exercise_categories#index")
    end

    it "routes to #new" do
      get("/exercise_categories/new").should route_to("exercise_categories#new")
    end

    it "routes to #show" do
      get("/exercise_categories/1").should route_to("exercise_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/exercise_categories/1/edit").should route_to("exercise_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/exercise_categories").should route_to("exercise_categories#create")
    end

    it "routes to #update" do
      put("/exercise_categories/1").should route_to("exercise_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/exercise_categories/1").should route_to("exercise_categories#destroy", :id => "1")
    end

  end
end

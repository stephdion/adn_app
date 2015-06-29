require "spec_helper"

describe ExerciseSubcategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/exercise_subcategories").should route_to("exercise_subcategories#index")
    end

    it "routes to #new" do
      get("/exercise_subcategories/new").should route_to("exercise_subcategories#new")
    end

    it "routes to #show" do
      get("/exercise_subcategories/1").should route_to("exercise_subcategories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/exercise_subcategories/1/edit").should route_to("exercise_subcategories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/exercise_subcategories").should route_to("exercise_subcategories#create")
    end

    it "routes to #update" do
      put("/exercise_subcategories/1").should route_to("exercise_subcategories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/exercise_subcategories/1").should route_to("exercise_subcategories#destroy", :id => "1")
    end

  end
end

require "spec_helper"

describe TestSubcategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/test_subcategories").should route_to("test_subcategories#index")
    end

    it "routes to #new" do
      get("/test_subcategories/new").should route_to("test_subcategories#new")
    end

    it "routes to #show" do
      get("/test_subcategories/1").should route_to("test_subcategories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/test_subcategories/1/edit").should route_to("test_subcategories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/test_subcategories").should route_to("test_subcategories#create")
    end

    it "routes to #update" do
      put("/test_subcategories/1").should route_to("test_subcategories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/test_subcategories/1").should route_to("test_subcategories#destroy", :id => "1")
    end

  end
end

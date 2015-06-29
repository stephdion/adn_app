class AddRoleAthlete < ActiveRecord::Migration
  def up
    #load default roles
    create_default_roles
  end

  def down
  end

private
  def create_default_roles
    Role.create(:code=>"ATHLETE",   :isSystem=>true, :name=>"Athlete");
  end
end

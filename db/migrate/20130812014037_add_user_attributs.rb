class AddUserAttributs < ActiveRecord::Migration
  def up
    add_column :users,         :role_id,            :int
    add_column :users,         :organization_id,    :int
    add_column :users,         :registration_token, :string
    add_column :roles,         :code,               :string,  :unique=>true
    add_column :organizations, :code,               :string,  :unique=>true
    add_column :roles,         :isSystem,           :boolean, :default=>false
    add_column :organizations, :isSystem,           :boolean, :default=>false

    #load default roles
    create_default_roles
    create_default_org
    create_default_role
  end

  def down
    remove_column :users,         :role_id
    remove_column :users,         :organization_id,    :int
    remove_column :users,         :registration_token, :string
    remove_column :roles,         :code,               :string,  :unique=>true
    remove_column :organizations, :code,               :string,  :unique=>true
    remove_column :roles,         :isSystem,           :boolean, :default=>false
    remove_column :organizations, :isSystem,           :boolean, :default=>false
  end

private
  def create_default_roles
    Role.create(:code=>"SYSADM",   :isSystem=>true, :name=>"Administrator System");
    Role.create(:code=>"PARENT",   :isSystem=>true, :name=>"Parent");
    Role.create(:code=>"TRAINER",  :isSystem=>true, :name=>"Entraineur");
    Role.create(:code=>"EXPHEL",   :isSystem=>true, :name=>"Profesionel de sante");
    Role.create(:code=>"DIR",      :isSystem=>true, :name=>"Directeur dassociation");
  end
  def create_default_org
    Organization.create(:code=>"ALL", :isSystem=>true, :name=>"**All organizations**")
  end
  def create_default_role
    Voucher.create(:token=>"admidathletique", :isSystem=>true, :organization_id=>1, :role_id=>1)
  end

end

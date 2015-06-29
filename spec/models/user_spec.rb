# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  last_name                :string(255)      not null
#  email                    :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  password_digest          :string(255)
#  remember_token           :string(255)
#  registration_token       :string(255)
#  is_enabled               :boolean          not null
#  first_name               :string(255)      not null
#  address                  :string(255)
#  city                     :string(255)
#  state                    :string(255)
#  postalCode               :string(255)
#  country                  :string(255)
#  birthday                 :date
#  sex                      :string(255)
#  change_password_required :boolean          default("false"), not null
#  photo_file_name          :string(255)
#  photo_content_type       :string(255)
#  photo_file_size          :integer
#  photo_updated_at         :datetime
#  banner_content_type      :string(255)
#  banner_file_size         :integer
#  banner_file_name         :string(255)
#  banner_updated_at        :datetime
#  user_phones_count        :integer          default("0"), not null
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:eval_tests) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
  
  #describe "eval_test associations" do

    #before { @user.save }
    #let!(:older_eval_test) do 
      #FactoryGirl.create(:eval_test, user: @user, created_at: 1.day.ago)
    #end
    #let!(:newer_eval_test) do
      #FactoryGirl.create(:eval_test, user: @user, created_at: 1.hour.ago)
    #end

    #it "should have the right eval_test in the right order" do
      #@user.eval_tests.should == [newer_eval_test, older_eval_test]
    #end
  #end
  
end

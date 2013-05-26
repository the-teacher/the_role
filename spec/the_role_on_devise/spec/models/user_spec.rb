# encoding: UTF-8

require 'spec_helper'

describe User do    
  describe "Create user without any Role" do
    before(:each) do
      FactoryGirl.create(:user)
      @user = User.first
    end

    it "Create test user" do
      User.count.should be 1
    end

    it "User have not any role" do
      @user.role.should be_nil
    end

    it "User should gives false on any request" do
      @user.has_role?(:pages, :index).should     be_false
      @user.has_role?(:moderator, :pages).should be_false
    end
  end

  describe "Create user with default Role" do
    before(:each) do
      TheRole.config.default_user_role = :user
      FactoryGirl.create(:role_user)
      FactoryGirl.create(:user)
      @user = User.first
    end
    
    it "User and Role should exists" do
      Role.count.should be 1
      User.count.should be 1
    end

    it "Role should nave name :user" do
      Role.first.name.should eq 'user'
    end

    it "User should have default Role" do
      @user.role.should_not be_nil
    end

    it "User has Role for Pages" do
      @user.has_role?(:pages, :index).should   be_true
      @user.has_role?(:pages, :destroy).should be_true
    end

    it "User has disabled rule" do
      @user.has_role?(:pages, :secret).should be_false
    end

    it "User try to have access to undefined rule" do
      @user.has_role?(:pages, :wrong_name).should be_false
    end

    it "User has not Role for Atricles" do
      @user.has_role?(:articles, :index).should be_false
    end
  end
end
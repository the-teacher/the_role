# encoding: UTF-8

require 'spec_helper'

describe User do
  describe "Owner check for User and object" do
    context "Regular user" do
      before(:each) do
        @user_1 = FactoryGirl.create(:user)
        @user_2 = FactoryGirl.create(:user)

        @user_1_page = FactoryGirl.create(:page, user: @user_1)
        @user_2_page = FactoryGirl.create(:page, user: @user_2)
      end

      it 'should have test varaibles' do
        @user_1.should be_instance_of User
        @user_2.should be_instance_of User

        @user_1_page.should be_instance_of Page
        @user_2_page.should be_instance_of Page
      end

      it 'should be owner of page' do
        @user_1.owner?(@user_1_page).should be_true
        @user_2.owner?(@user_2_page).should be_true
      end

      it 'should not be owner of page' do
        @user_1.owner?(@user_2_page).should be_false
        @user_2.owner?(@user_1_page).should be_false
      end
    end

    context "Moderator" do
      before(:each) do
        mrole = FactoryGirl.create(:role_moderator)

        @moderator = FactoryGirl.create(:user, role: mrole)
        @user      = FactoryGirl.create(:user)

        @moderator_page = FactoryGirl.create(:page, user: @moderator)
        @user_page      = FactoryGirl.create(:page, user: @user)
      end

      it 'Moderator is owner of any Page' do
        @moderator.owner?(@moderator_page).should be_true
        @moderator.owner?(@user_page).should      be_true
      end

      it 'User is owner of his Pages' do
        @user.owner?(@user_page).should      be_true
        @user.owner?(@moderator_page).should be_false
      end
    end

    context "Admin" do
      # not important. to implement later
    end

    # context "Custom Page relation to User" do
    #   before(:each) do
    #     Page.class_eval do
    #       belongs_to :user, class_name: User, foreign_key: 'person_id'
    #     end

    #     @user = FactoryGirl.create(:user)
    #     @page = FactoryGirl.create(:page, user: @user)
    #   end

    #   it 'relation via person_id' do
    #     @page.user_id.should   eq @user.id
    #     @page.person_id.should eq @user.id
    #   end
    # end
  end

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

    # Any
    it "should has any rules 1" do
      @user.has_role?(:pages, :index).should  be_true
      @user.has_role?(:pages, :update).should be_true

      @user.any_role?({ pages: :index  }).should be_true
      @user.any_role?({ pages: :update }).should be_true
      @user.any_role?({ pages: :index, pages: :update}).should be_true
    end

    it "should has any rules 2" do
      @user.has_role?(:pages,    :index).should be_true
      @user.has_role?(:articles, :index).should be_false

      @user.any_role?({ pages:    :index }).should be_true
      @user.any_role?({ articles: :index }).should be_false

      @user.any_role?({ articles: :index }).should be_false
      @user.any_role?({ pages: :index, articles: :index}).should be_true
      @user.any_role?({ pages: :index, pages:    :update}).should be_true
    end

    it "should has any rules 3, easy syntaxis" do
      @user.any_role?(articles: :index).should be_false
      @user.any_role?(pages: :index, articles: :index).should be_true
      @user.any_role?(pages: :index, pages:    :update).should be_true
    end
  end
end
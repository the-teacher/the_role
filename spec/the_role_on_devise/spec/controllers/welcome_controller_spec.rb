require 'spec_helper'

describe WelcomeController do
  describe "GET for GUESTS" do
    it "*INDEX* test *subject* object" do
      get 'index'
      subject.class.should == WelcomeController
    end

    it "*INDEX* returns http success" do
      get 'index'
      response.should be_success
    end

    it "*INDEX* render :index page" do
      get 'index'
      response.should render_template :index
    end

    it "*INDEX* *current_user* should be nil" do
      get 'index'
      subject.current_user.should be_nil
    end
    
    it "*PROFILE* will be redirect" do
      get 'profile'
      response.should be_redirect
    end

    it "*PROFILE* will be redirect to new_user_session_path page" do
      get 'profile'
      response.should redirect_to new_user_session_path
    end
  end

  describe "GET for LOGGED_IN users" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    after(:each) do
      User.destroy_all
    end

    it "One user should be exists" do
      User.count.should be 1
    end

    it "*PROFILE* should render :profile page" do
      get 'profile'
      response.should render_template :profile
    end

    it "*PROFILE* should not to be redirect" do
      get 'profile'
      response.should_not be_redirect
    end

    it "*PROFILE* *current_user* helper should return user" do
      get 'profile'
      subject.current_user.should == @user
    end
  end

end

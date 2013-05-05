require 'spec_helper'

describe Admin::RolesController do
  before(:all) do
    @role = FactoryGirl.create(:user_role)
    @user = FactoryGirl.create(:user, :role => @role)
  end

  after(:all) do
    Role.destroy_all
    User.destroy_all
  end

  describe "Admin Section" do

    describe 'Unauthorized' do
      describe "GET" do
        [:index, :new].each do |action|
          it "#{action.to_s.upcase}" do
            get action
            response.should redirect_to new_user_session_path
          end
        end

        it "EDIT" do
          get :edit, { :id => @role.id }
          response.should redirect_to new_user_session_path
        end
      end

      describe "PUT" do
        it "UPDATE" do
          get :update, { :id => @role.id }
          response.should redirect_to new_user_session_path
        end
      end

      describe "POST" do
        it "CREATE" do
          get :create, { :id => @role.id }
          response.should redirect_to new_user_session_path
        end
      end

      describe "DELETE" do
        it "DESTROY" do
          get :destroy, { :id => @role.id }
          response.should redirect_to new_user_session_path
        end
      end
    end

    describe "Authorized / Regular user" do
      before(:each) { sign_in @user }

      describe "GET" do
        [:index, :new].each do |action|
          it "#{action.to_s.upcase}" do
            get action
            response.body.should match 'access_denied: requires an role'
          end
        end

        it "EDIT" do
          get :edit, { :id => @role.id }
          response.body.should match 'access_denied: requires an role'
        end
      end

      describe "PUT" do
        it "UPDATE" do
          get :update, { :id => @role.id }
          response.body.should match 'access_denied: requires an role'
        end
      end

      describe "POST" do
        it "CREATE" do
          get :create, { :id => @role.id }
          response.body.should match 'access_denied: requires an role'
        end
      end

      describe "DELETE" do
        it "DESTROY" do
          get :destroy, { :id => @role.id }
          response.body.should match 'access_denied: requires an role'
        end
      end
    end

  end
end
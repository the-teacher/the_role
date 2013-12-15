require 'spec_helper'

describe Admin::RolesController do
  describe "Admin Section" do
    describe 'Unauthorized' do
      before(:each) do
        @request.env['HTTP_REFERER'] = '/'
        @role = FactoryGirl.create(:role_user)
      end

      %w{ index new }.each do |action|
        it action.upcase do
          get action
          response.should redirect_to new_user_session_path
        end
      end

      %w{ edit update create destroy }.each do |action|
        it action.upcase do
          get action, { id: @role.id }
          response.should redirect_to new_user_session_path
        end
      end
    end

    describe "Authorized / Regular user" do
      describe "Can't do something with Roles" do
        before(:each) do
          @request.env['HTTP_REFERER'] = '/'
          @user = FactoryGirl.create(:user)
          @role = FactoryGirl.create(:role_user)
          sign_in @user
        end

        %w{ index new }.each do |action|
          it action.upcase do
            get action
            response.body.should match access_denied_match
          end
        end

        %w{ edit update create destroy }.each do |action|
          it action.upcase do
            get action, { id: @role.id }
            response.body.should match access_denied_match
          end
        end
      end
    end

  end
end
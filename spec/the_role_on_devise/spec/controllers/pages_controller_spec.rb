require 'spec_helper'

describe PagesController do
  def valid_page_attrs
    {
      title:   Faker::Lorem.sentence,
      content: Faker::Lorem.sentence,
      state:   :published
    }
  end

  describe "Pages/Create" do
    before(:each) do
      @role = FactoryGirl.create(:role_user)
      @user = FactoryGirl.create(:user, role: @role)
      @page_params = valid_page_attrs.merge(user_id: @user.id)
    end

    describe 'AUTORIZED/NO ROLE/NOT OWNER' do
      before(:each) { sign_in @user } 

      it "CREATE / invalid page attr" do
        post :create, { page: { fake: true } }
        response.should render_template :new
      end

      it "CREATE / valid page attr" do
        post :create , { page: @page_params }
        assigns(:page).errors.should be_empty
      end

      it "CREATE / valid / redirect to SHOW" do
        post :create, { page: @page_params }
        response.should redirect_to page_path assigns(:page)
      end
    end
  end

  # end

  # before(:all) do
  #   @role = FactoryGirl.create(:role_user)
  #   @user = FactoryGirl.create(:user, :role => @role)
  #   @page = @user.pages.create! valid_page_attrs
  # end

  # describe :ACCESS do

    # describe "=> Public pages" do
    #   describe "GET" do

    #     it "INDEX" do
    #       get :index
    #       assigns(:pages).should eq [@page]
    #     end

    #     it "SHOW" do
    #       get :show, { :id => @page.id }
    #       assigns(:page).should eq @page
    #     end

    #   end
    # end

    # describe "=> Login && role" do
    #   describe "GET" do
    #     describe 'authorized' do
    #       before(:each) { sign_in @user }

    #       it "MY" do
    #         get :my
    #         response.should render_template :my
    #       end

    #       it "NEW" do
    #         get :new
    #         response.should render_template :new
    #       end
    #     end

    #     describe 'unauthorized' do
    #       it "NEW" do
    #         get :new
    #         response.should redirect_to new_user_session_path
    #       end          
    #     end
    #   end



    # describe "=> Login && role && ownership" do
    #   describe "GET" do
    #     describe "unauthorized" do
    #       it 'EDIT' do
    #         get :edit, { :id => @page }
    #         response.should redirect_to new_user_session_path
    #       end
    #     end

    #     describe "authorized" do
    #       describe "owner" do
    #         it 'EDIT' do
    #           sign_in @user
    #           get :edit, { :id => @page }
    #           response.should render_template :edit
    #         end
    #       end

    #       describe "NOT owner" do
    #         before(:all) do
    #           @another_user = FactoryGirl.create(:user, :role => @role)
    #           @another_page = Page.create! valid_page_attrs.merge(:user_id => @another_user.id)
    #         end

    #         it 'EDIT / Access denied ' do
    #           sign_in @user
    #           get :edit, { :id => @another_page }
    #           response.body.should match 'access_denied: requires an role'
    #         end
    #       end
    #     end
    #   end
    # end

    # describe "=> Only Admin or Moderator" do
    #   describe "Regular user" do
    #     it 'MANAGE / Access denied' do
    #       sign_in @user
    #       get :manage
    #       response.body.should match 'access_denied: requires an role'
    #     end
    #   end

    #   describe "Moderator" do
    #     before(:all) do
    #       role = FactoryGirl.create(:pages_moderator_role)
    #       @user.role = role
    #       @user.save
    #     end

    #     it 'MANAGE' do
    #       sign_in @user
    #       get :manage
    #       response.should render_template :manage
    #     end
    #   end

    #   describe "Admin" do
    #     before(:all) do
    #       role = FactoryGirl.create(:admin_role)
    #       @user.role = role
    #       @user.save
    #     end
        
    #     it 'MANAGE' do
    #       sign_in @user
    #       get :manage
    #       response.should render_template :manage
    #     end
    #   end
    # end

  # end
end
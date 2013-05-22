require 'spec_helper'

describe PagesController do
  def valid_page_attrs
    {
      title:   Faker::Lorem.sentence,
      content: Faker::Lorem.sentence,
      state:   :published
    }
  end

  describe "Guest" do
    describe 'NOT AUTORIZED/NO ROLE/NOT OWNER' do
      it "CREATE / but should be redirected" do
        post :create, { page: { fake: true } }
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "User" do
    before(:each) do
      @role        = FactoryGirl.create(:role_user)
      @owner       = FactoryGirl.create(:user, role: @role)
      @page_params = valid_page_attrs.merge(user_id: @owner.id)
    end

    describe 'AUTORIZED/HAS ROLE/OWNER' do
      before(:each) { sign_in @owner }

      context "CREATE" do
        it "valid" do
          expect {
            post :create , { page: @page_params }
          }.to change(Page, :count).from(0).to(1)

          expect {
            post :create , { page: @page_params }
          }.to_not change(Page, :count).by(1)
        end

        it "invalid params" do
          expect {
            post :create, { page: { fake: true } }
          }.to_not change(Page, :count)

          response.should render_template :new
        end

        it "valid, no errors" do
          post :create , { page: @page_params }
          assigns(:page).errors.should be_empty
        end

        it "valid, redirect to SHOW" do
          post :create, { page: @page_params }
          response.should redirect_to page_path assigns(:page)
        end
      end

      context "UPDATE" do
        before(:each) do
          sign_in @owner
          @owner.pages.create! @page_params
          @page = @owner.pages.first
        end

        it "should has test objects" do
          User.count.should    eq 1
          Page.count.should    eq 1
          Page.first.id.should eq User.first.id

          @owner.has_role?(:pages, :update).should be_true
        end

        it "page should be updated" do
          old_title = @page_params[:title]
          new_title = "test_title"

          expect {
            patch :update, id: @page, page: { title: "test_title" }
            @page.reload  
          }.to change(@page, :title).from(old_title).to(new_title)
        end
      end
    end

    describe 'AUTORIZED/HAS ROLE/NOT OWNER' do
      before(:each) do        
        @hacker = FactoryGirl.create(:user, role: @role)
        @owner.pages.create! @page_params
        @page = @owner.pages.last
      end

      it "hacker should be blocked" do
        sign_in @hacker
        patch :update, id: @page, page: { title: "test_title" }
        response.body.should match access_denied_match
      end
    end
  end

  describe "Moderator" do

  end
end

# assigns(:page).should eq @page
# response.should render_template :manage
# response.should redirect_to new_user_session_path
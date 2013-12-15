require 'spec_helper'

describe PagesController do
  def valid_page_attrs
    {
      title:   Faker::Lorem.sentence,
      content: Faker::Lorem.sentence,
      state:   :published
    }
  end

  def valid_page_for user
    valid_page_attrs.merge(user_id: user.id)
  end

  before(:each) do
    @role           = FactoryGirl.create(:role_user)
    @moderator_role = FactoryGirl.create(:role_moderator)

    @owner     = FactoryGirl.create(:user, role: @role)
    @hacker    = FactoryGirl.create(:user, role: @role)
    @moderator = FactoryGirl.create(:user, role: @moderator_role)
    
    @owner.pages.create! valid_page_for(@owner)
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
    describe 'AUTORIZED/HAS ROLE/OWNER' do
      before(:each) { sign_in @owner }

      context "CREATE" do
        it "valid" do
          expect {
            post :create , { page: valid_page_for(@owner) }
          }.to change(Page, :count).by(1)
        end

        it "invalid params" do
          expect {
            post :create, { page: { fake: true } }
          }.to_not change(Page, :count)

          response.should render_template :new
        end

        it "valid, no errors" do
          post :create , { page: valid_page_for(@owner) }
          assigns(:page).errors.should be_empty
        end

        it "valid, redirect to SHOW" do
          post :create, { page: valid_page_for(@owner) }
          response.should redirect_to page_path assigns(:page)
        end
      end

      context "UPDATE" do
        before(:each) do
          sign_in @owner
          @page = @owner.pages.last
        end

        it "users should has rules" do
          @owner.has_role?(:pages, :update).should  be_true
          @hacker.has_role?(:pages, :update).should be_true
        end

        it "page should be updated" do
          old_title = @page.title
          new_title = "test_title"

          expect {
            patch :update, id: @page, page: { title: new_title }
            @page.reload  
          }.to change(@page, :title).from(old_title).to(new_title)
        end
      end
    end

    describe 'AUTORIZED/HAS ROLE/NOT OWNER' do
      before(:each) { @page = @owner.pages.last }

      it "hacker should be blocked" do
        sign_in @hacker
        @request.env['HTTP_REFERER'] = '/'
        patch :update, id: @page, page: { title: "test_title" }
        response.body.should match access_denied_match
      end
    end
  end

  describe "Moderator" do
    before(:each) do
      @page = @owner.pages.last

      @old_title = @page.title
      @new_title = Faker::Lorem.sentence
    end

    it "Owner can update page" do
      sign_in @owner

      expect {
        patch :update, id: @page, page: { title: @new_title }
        @page.reload  
      }.to change(@page, :title).from(@old_title).to(@new_title)
    end

    it "Moderator can update page" do
      sign_in @moderator

      expect {
        patch :update, id: @page, page: { title: @new_title }
        @page.reload 
      }.to change(@page, :title).from(@old_title).to(@new_title)
    end

    it "Hacker cant update page" do
      sign_in @hacker
      @request.env['HTTP_REFERER'] = '/'

      expect {
        patch :update, id: @page, page: { title: @new_title }
        @page.reload  
      }.to_not change(@page, :title).from(@old_title).to(@new_title)
    end
  end
end

# assigns(:page).should eq @page
# response.should render_template :manage
# response.should redirect_to new_user_session_path
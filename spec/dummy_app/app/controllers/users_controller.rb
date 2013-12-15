class UsersController < ApplicationController
  before_filter :login_required
  before_filter :role_required

  before_filter :find_user,      :only   => [:edit, :update]
  before_filter :owner_required, :only   => [:edit, :update]

  def edit; end

  def update
    @user.update_attributes params[:user]
    flash[:notice] = 'User was successfully updated.'
    redirect_to edit_user_path @user
  end

  def change_role
    @user = User.find params[:user_id]
    @role = Role.find params[:role_id]
    @user.update_attribute(:role, @role)
    redirect_to edit_user_path @user
  end

  private

  def find_user
    @user = User.find params[:id]

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    @owner_check_object = @user
  end
end

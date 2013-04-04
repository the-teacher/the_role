module TheRole
  module Requires
    private
      def role_access_denied
        flash[:error] = t('the_role.access_denied')
        redirect_to root_path
      end

      def role_required
        role_access_denied unless current_user.has_role?(controller_path, action_name)
      end

      def owner_required
        role_access_denied unless current_user.owner?(@ownership_checking_object)
      end
  end
end

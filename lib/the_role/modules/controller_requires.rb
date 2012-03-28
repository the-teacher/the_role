module TheRole
  module Requires
    private
    
      def role_access_denied
        flash[:error] = t('the_role.access_denied')
        redirect_to root_path
      end
      
      # before_filter :role_require
      def role_require
        role_access_denied unless current_user.has_role?(controller_name, action_name)
      end

      # before_filter :simple_object_finder
      # define class variable for *owner_require* filter with Controller class name
      # @object_for_ownership_checking = @article
      def simple_object_finder
        variable_name                  = self.class.to_s.tableize.split('_').first.singularize.split('/').last
        @object_for_ownership_checking = self.instance_variable_get("@#{variable_name}")
      end

      # before_filter :owner_require
      def owner_require
        role_access_denied unless current_user.owner?(@object_for_ownership_checking)
      end
  end
end
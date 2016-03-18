module Ohmage
  module API
    module User
      #
      # ohmage user/read call
      # @see https://github.com/ohmage/server/wiki/User-Manipulation#userRead
      # @returns [Array: Ohmage::User objects] that match param criteria
      #
      def user_read(params = {})
        request = Ohmage::Request.new(self, :post, 'user/read', params)
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::User.new(k => v)
        end
        t
      end

      #
      # ohmage user_info/read call
      # @see https://github.com/ohmage/server/wiki/User-Manipulation#userInfoRead
      # @returns Object: detailed list of classes/campaign current user can access
      #
      def user_info_read
        request = Ohmage::Request.new(self, :post, 'user_info/read', {})
        Ohmage::User.new(request.perform[:data])
      end

      #
      # ohmage user/create call
      # @see https://github.com/ohmage/server/wiki/User-Manipulation#userCreate
      # @returns [Object: Ohmage::User]
      #
      def user_create(params = {})
        request = Ohmage::Request.new(self, :post, 'user/create', params)
        request.perform
        user_read(user_list: params[:username])
      end

      #
      # ohmage user/update call
      # @see https://github.com/ohmage/server/wiki/User-Manipulation#userUpdate
      # @returns [Object: Ohmage::User]
      #
      def user_update(params = {})
        request = Ohmage::Request.new(self, :post, 'user/update', params)
        request.perform
        user_read(user_list: params[:username])
      end

      def user_password(params = {}) # is this method name odd?
        # this api call demands current user's info.
        params[:user] = user
        params[:password] = password
        request = Ohmage::Request.new(self, :post, 'user/change_password', params)
        request.perform
      end

      def user_delete(params = {})
        request = Ohmage::Request.new(self, :post, 'user/delete', params)
        request.perform
      end

      #
      # ohmage user/setup call
      # @see https://github.com/ohmage/server/wiki/User-Manipulation#userSetup
      # @returns Hash with username and password param.
      #
      def user_setup(params = {})
        # server bug returns empty page if user setup disabled.
        return false unless server_config[:user_setup_enabled]
        request = Ohmage::Request.new(self, :post, 'user/setup', params)
        request.perform
      end

      #
      # ohmage user/search call. Admin only api
      # @see https://github.com/ohmage/server/wiki/User-Manipulation#userSetup
      # @returns Array of Ohmage::User objects. 
      #
      def user_search(params = {})
        request = Ohmage::Request.new(self, :post, 'user/search', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::User.new(k => v)
        end
        t
      end
    end
  end
end

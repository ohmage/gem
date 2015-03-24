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
          t << Ohmage::User.new({k => v})
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
      # @returns Object: Ohmage::User?
      #
      def user_create(params = {})
        request = Ohmage::Request.new(self, :post, 'user/create', params)
        resp = request.perform
        return user_read('username' => params['username'])
      end

      #
      # ohmage user/update call
      # @see https://github.com/ohmage/server/wiki/User-Manipulation#userUpdate
      # @returns 
    end
  end
end
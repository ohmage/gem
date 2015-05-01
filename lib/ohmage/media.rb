module Ohmage
  module API
    module Media
      #
      # ohmage media/read call
      # @see https://github.com/ohmage/server/wiki/Image-Manipulation#mediaRead
      # @returns [Binary File] from raw HTTP Response Body.
      def media_read(params = {})
        unless params[:size]
          request = Ohmage::Request.new(self, :get, 'media/read', params)
          request.perform
        else
          image_read(params)
        end
      end

      def image_read(params = {})
        request = Ohmage::Request.new(self, :get, 'image/read', params)
        request.perform
      end
    end
  end
end

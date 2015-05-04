module Ohmage
  module API
    module Media
      #
      # ohmage media/read call
      # @see https://github.com/ohmage/server/wiki/Media-Manipulation#mediaRead
      # @returns [Binary File] from raw HTTP Response Body.
      def media_read(params = {})
        # support for media/read exists only in 2.17+
        if server_config[:application_version].to_f >= 2.17
          # 2.17 beta does not currently support size param for images
          # in media/read. wire in image_read.
          if params[:size]
            image_read(params)
          else
            request = Ohmage::Request.new(self, :get, 'media/read', params)
            request.perform
          end
        else
          # finaly, if server ver is <= 2.16 fall back to image/read for all
          # media calls. yes, this is weird. but it works!
          image_read(params)
        end
      end
      alias_method :audio_read, :media_read
      alias_method :video_read, :media_read

      def image_read(params = {})
        request = Ohmage::Request.new(self, :get, 'image/read', params)
        request.perform
      end
    end
  end
end

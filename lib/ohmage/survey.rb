module Ohmage
  module API
    module Survey
      #
      # ohmage survey_response/read call
      # @see https://github.com/ohmage/server/wiki/Survey-Manipulation#surveyResponseRead
      # @returns [Array Ohmage::Survey objects] pertaining to request params.
      #
      def survey_response_read(params = {}) # rubocop:disable all
        params[:column_list] = params[:column_list] || 'urn:ohmage:special:all'
        params[:output_format] = params[:output_format] || 'json-rows'
        params[:user_list] = params[:user_list] || 'urn:ohmage:special:all'
        params[:prompt_id_list] = 'urn:ohmage:special:all' unless params[:prompt_id_list] || params[:survey_id_list]
        request = Ohmage::Request.new(self, :post, 'survey_response/read', params)
        t = []
        # We can't possibly make Ohmage::SurveyReponse objects unless we use json-rows. json-columns and csv output is so odd for this.
        if params[:output_format] == 'json-rows' && params[:collapse] != true
          request.perform[:data].each do |v|
            t << Ohmage::SurveyResponse.new(v[:survey_key] => v)
          end
          t
        else
          request.perform
        end
      end

      #
      # ohmage survey_response/update call
      # @see https://github.com/ohmage/server/wiki/Survey-Manipulation#surveyResponseUpdatePrivacyState
      # @returns success/fail as string.
      #
      def survey_response_update(params = {})
        request = Ohmage::Request.new(self, :post, 'survey_response/update', params)
        request.perform
      end

      #
      # ohmage survey_response/delete call
      # @see https://github.com/ohmage/server/wiki/Survey-Manipulation#surveyResponseDelete
      # @returns success/fail as string.
      #
      def survey_response_delete(params = {})
        request = Ohmage::Request.new(self, :post, 'survey_response/delete', params)
        request.perform
      end

      #
      # ohmage survey/upload call
      # @see https://github.com/ohmage/server/wiki/Survey-Manipulation#surveyUpload
      # @returns success/fail as string.
      #
      def survey_upload(params = {})
        # loop around params, finding attached images/files, set them as form data.
        params.each do |param|
          if /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/ =~ param.first
            @mime_type = /[^;]*/.match(`file -b --mime "#{param[1]}"`)[0]
            params[param[0]] = HTTP::FormData::File.new(param[1], mime_type: @mime_type)
          end
          next
        end
        request = Ohmage::Request.new(self, :post, 'survey/upload', params)
        request.perform
      end
    end
  end
end

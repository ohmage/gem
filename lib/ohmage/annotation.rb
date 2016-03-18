module Ohmage
  module API
    module Annotation
      #
      # ohmage annotation/survey_response/create call
      # @see https://github.com/ohmage/server/wiki/
      # @returns [Array: Ohmage::Annotation objects] matching criteria and output format
      #
      def annotation_survey_response_create(params = {})
        request = Ohmage::Request.new(self, :post, 'annotation/survey_response/create', params)
        request.perform
      end

      #
      # ohmage annotation/prompt_response/create call
      # @see https://github.com/ohmage/server/wiki/
      # @returns [Array: Ohmage::Annotation objects] matching criteria and output format
      #
      def annotation_prompt_response_create(params = {})
        request = Ohmage::Request.new(self, :post, 'annotation/prompt_response/create', params)
        request.perform
      end

      #
      # ohmage annotation/survey_response/read call
      # @see https://github.com/ohmage/server/wiki/
      # @returns [Array: Ohmage::Annotation objects] matching criteria and output format
      #
      def annotation_survey_response_read(params = {})
        request = Ohmage::Request.new(self, :post, 'annotation/survey_response/read', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::Annotation.new(k => v)
        end
        t
      end

      #
      # ohmage annotation/prompt_response/read call
      # @see https://github.com/ohmage/server/wiki/
      # @returns [Array: Ohmage::Annotation objects] matching criteria and output format
      #
      def annotation_prompt_response_read(params = {})
        request = Ohmage::Request.new(self, :post, 'annotation/prompt_response/read', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::Annotation.new(k => v)
        end
        t
      end

      #
      # ohmage annotation/delete call
      # @see https://github.com/ohmage/server/wiki/
      # @returns success/fail
      #
      def annotation_delete(params = {})
        request = Ohmage::Request.new(self, :post, 'annotation/delete', params)
        request.perform
      end
    end
  end
end

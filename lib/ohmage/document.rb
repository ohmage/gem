module Ohmage
  module API
    module Document
      #
      # ohmage document/read call
      # @see https://github.com/ohmage/server/wiki/Document-Manipulation#document-information-read
      # @returns [Array: Ohmage::Document objects] matching criteria and output format
      def document_read(params = {})
        request = Ohmage::Request.new(self, :post, 'document/read', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::Document.new(k => v)
        end
        t
      end
    end
  end
end

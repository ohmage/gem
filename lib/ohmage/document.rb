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

      def document_create(file, params = {})
        params[:document] = HTTP::FormData::File.new(file)
        # catch lack of document_name param, since we can just append the filename we have!
        params[:document_name] = File.basename(file) unless params.key?(:document_name)
        request = Ohmage::Request.new(self, :post, 'document/create', params)
        request.perform
        document_read(document_name_search: params[:document_name])
      end

      def document_delete(params = {})
        request = Ohmage::Request.new(self, :post, 'document/delete', params)
        request.perform
      end
    end
  end
end

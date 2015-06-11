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

      #
      # ohmage document/create call
      # @see https://github.com/ohmage/server/wiki/Document-Manipulation#documentCreate
      # @returns [Ohmage::Document object]
      #
      def document_create(params = {})
        params[:document] = HTTP::FormData::File.new(params[:document])
        # catch lack of document_name param, since we can just append the filename we have!
        request = Ohmage::Request.new(self, :post, 'document/create', params)
        request.perform
        document_read(document_name_search: params[:document_name])
      end

      #
      # ohmage document/update call
      # @see https://github.com/ohmage/server/wiki/Document-Manipulation#documentUpdate
      # @returns nil, can't be sure we can search for the updated file.
      #
      def document_update(params = {})
        params[:document] = HTTP::FormData::File.new(params[:document]) if params[:document]
        request = Ohmage::Request.new(self, :post, 'document/update', params)
        request.perform
      end

      #
      # ohmage document/delete call
      # @see https://github.com/ohmage/server/wiki/Document-Manipulation#documentDelete
      # @returns string with success/fail
      #
      def document_delete(params = {})
        request = Ohmage::Request.new(self, :post, 'document/delete', params)
        request.perform
      end

      #
      # ohmage document/read/contents call
      # @see https://github.com/ohmage/server/wiki/Document-Manipulation#documentUpdate
      # @returns [Binary File] from raw HTTP Response Body.
      #
      def document_contents(params = {})
        request = Ohmage::Request.new(self, :post, 'document/read/contents', params)
        request.perform
      end
    end
  end
end

module Ohmage
  module API
    module Clazz
      #
      # ohmage class/read call
      # @see https://github.com/ohmage/server/wiki/Class-Manipulation#classRead
      # @returns [Array: Ohmage::Class objects] matching criteria
      #
      def class_read(params = {})
        request = Ohmage::Request.new(self, :post, 'class/read', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::Clazz.new(k => v)
        end
        t
      end

      def class_create(params = {})
        request = Ohmage::Request.new(self, :post, 'class/create', params)
        request.perform
        class_read(class_urn_list: params[:class_urn])
      end

      def class_delete(params = {})
        request = Ohmage::Request.new(self, :post, 'class/delete', params)
        request.perform
      end
      def class_update(params = {})
        request = Ohmage::Request.new(self, :post, 'class/update', params)
        request.perform
        class_read(class_urn_list: params[:class_urn])
      end     
    end
  end
end

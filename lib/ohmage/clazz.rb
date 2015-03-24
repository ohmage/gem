module Ohmage
  module API
    module Clazz
      # 
      # ohmage class/read call
      # @see https://github.com/ohmage/server/wiki/Class-Manipulation#classRead
      # @returns [Array: Ohmage::Class objects] matching criteria
      def class_read(params = {})
        request = Ohmage::Request.new(self, :post, 'class/read', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::Clazz.new({k => v})
        end
        t
      end
    end
  end
end
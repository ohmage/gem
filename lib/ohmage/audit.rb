module Ohmage
  module API
    module Audit
      #
      # ohmage audit/read call
      # @see https://github.com/ohmage/server/wiki/Audit-APIs#auditRead
      # @returns [Array: Ohmage::Audit objects] matching criteria and output format
      def audit_read(params = {})
        request = Ohmage::Request.new(self, :post, 'audit/read', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:audits].each do |k, v|
          t << Ohmage::Audit.new(k => v)
        end
        t
      end
    end
  end
end

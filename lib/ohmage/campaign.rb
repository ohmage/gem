module Ohmage
  module API
    module Campaign
      #
      # ohmage campaign/read call
      # @see https://github.com/ohmage/server/wiki/Campaign-Manipulation#campaignRead
      # @returns [Array: Ohmage::Campaign objects] matching criteria and output format
      def campaign_read(params = {})
        request = Ohmage::Request.new(self, :post, 'campaign/read', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::Campaign.new({k => v})
        end
        t
      end
    end
  end
end
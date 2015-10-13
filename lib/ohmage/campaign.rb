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
          t << Ohmage::Campaign.new(k => v)
        end
        t
      end

      #
      # ohmage campaign/create call
      # @see https://github.com/ohmage/server/wiki/Campaign-Manipulation#campaignCreate
      # @returns [Ohmage::Campaign object] or nil if urn is not passed as param
      #
      def campaign_create(params = {})
        params[:xml] = HTTP::FormData::File.new(params[:xml]) unless params[:xml].include? '<?xml'
        request = Ohmage::Request.new(self, :post, 'campaign/create', params)
        request.perform
        # we cannot create a campaign object if campaign_urn is not passed as a param. returns nil otherwise
        campaign_read(campaign_urn_list: params[:campaign_urn], output_format: 'long') if params[:campaign_urn]
      end

      #
      # ohmage campaign/update call
      # @see https://github.com/ohmage/server/wiki/Campaign-Manipulation#campaignUpdate
      # @returns [Ohmage::Campaign object]
      #
      def campaign_update(params = {})
        params[:xml] = HTTP::FormData::File.new(params[:xml]) if params[:xml]
        request = Ohmage::Request.new(self, :post, 'campaign/update', params)
        request.perform
        campaign_read(campaign_urn_list: params[:campaign_urn], output_format: 'long')
      end

      #
      # ohmage campaign/delete call
      # @see https://github.com/ohmage/server/wiki/Campaign-Manipulation#campaignDelete
      # @returns string of success/fail
      #
      def campaign_delete(params = {})
        request = Ohmage::Request.new(self, :post, 'campaign/delete', params)
        request.perform
      end

      #
      # ohmage campaign/search call
      # @see https://github.com/ohmage/server/wiki/Campaign-Manipulation#campaignSearch
      # @returns [Array: Ohmage::Campaign objects]
      #
      def campaign_search(params = {})
        request = Ohmage::Request.new(self, :post, 'campaign/search', params)
        # TODO: make a utility to abstract creation of array of base objects
        t = []
        request.perform[:data].each do |k, v|
          t << Ohmage::Campaign.new(k => v)
        end
        t
      end
    end
  end
end

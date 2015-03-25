module Ohmage
  class Campaign
    # @return [String]
    attr_reader :urn, :name, :icon_url, :authored_by, :running_state, :privacy_state, :creation_timestamp, :description, :xml
    alias_method :author, :authored_by
    # @return [Array]
    attr_reader :user_roles, :classes
    alias_method :roles, :user_roles
    # @return [Hash]
    attr_reader :user_role_campaign

    def initialize(attrs = {})
      @urn = attrs.keys[0].to_s
      attrs.values[0].each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end

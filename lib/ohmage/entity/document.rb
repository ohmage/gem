module Ohmage
  class Document
    # @return [String]
    attr_reader :urn, :name, :size, :user_max_role, :user_role, :privacy_state, :last_modified, :description
    alias_method :id, :urn
    # @return [Hash]
    attr_reader :campaign_role, :class_role

    def initialize(attrs = {})
      @urn = attrs.keys[0].to_s
      attrs.values[0].each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end

module Ohmage
  class User
    # #return [String]
    attr_reader :username, :first_name, :last_name, :organization, :personal_id, :email_address
    alias_method :id, :username
    alias_method :user, :username
    alias_method :org, :organization
    alias_method :email, :email_address
    # @return [Object]
    attr_reader :permissions, :classes, :campaigns
    # @return [TrueClass, FalseClass]
    attr_reader :enabled, :can_setup_users, :new_account, :can_create_classes, :can_create_campaigns, :admin, :is_admin

    def initialize(attrs = {})
      @username = attrs.keys[0].to_s
      attrs.values[0].each do |k, v|
        instance_variable_set("@#{k}", v)
      end
      @permissions.each { |k, v| instance_variable_set("@#{k}", v) }
    end
  end
end

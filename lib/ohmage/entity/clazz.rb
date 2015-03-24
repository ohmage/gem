module Ohmage
  class Clazz
    # @return [String]
    attr_reader :urn, :name, :description, :role
    attr_reader :my_role, :role
    # @return [Hash]
    attr_reader :users

    def initialize(attrs = {})
      @urn = attrs.keys[0].to_s
      attrs.values[0].each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end
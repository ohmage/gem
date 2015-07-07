module Ohmage
  class Audit
    # @return [String]
    attr_reader :timestamp, :client, :request_type, :uri
    # @return [Hash]
    attr_reader :response, :request_parameters, :extra_data
    # @return [Fixnum]
    attr_reader :responded_millis, :received_millis

    def initialize(attrs = {})
      attrs.keys[0].each do |k, v|
        instance_variable_set("@#{k}", v)
      end
      @duration_millis = @responded_millis - @received_millis
    end
  end
end

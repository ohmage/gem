module Ohmage
  class SurveyResponse
    # @return [String]
    attr_reader :urn, :client, :privacy_state, :repeatable_set_id, :repeatable_set_iteration, :survey_description, :survey_id, :survey_title, :user, :timezone
    # @return [String] location stuffz
    attr_reader :location_accuracy, :location_provider, :location_status, :location_timestamp
    # @return [Long]
    attr_reader :latitude, :longitude
    # @return [Hash]
    attr_reader :launch_context_long, :launch_context_short, :responses
    # @return [Something Else]
    attr_reader :time, :utc_timestamp

    def initialize(attrs = {})
      @urn = attrs.keys[0].to_s
      attrs.values[0].each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end

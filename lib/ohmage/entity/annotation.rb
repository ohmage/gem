module Ohmage
  class Annotation
    # @return [String]
    attr_reader :time, :timezone, :annotation_id, :text, :author
    alias_method :id, :annotation_id
    alias_method :urn, :annotation_id

    def initialize(attrs = {})
      attrs.keys[0].each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end

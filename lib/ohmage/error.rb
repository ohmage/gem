module Ohmage
  class Error < StandardError
    ClientError = Class.new(self)
    BadRequest = Class.new(ClientError)
    Unauthorized = Class.new(ClientError)
    NotFound = Class.new(ClientError)
    NotAcceptable = Class.new(ClientError)
    InvalidToken = Class.new(ClientError)
    InvalidParameter = Class.new(ClientError)
    MobilityException = Class.new(ClientError)
    SurveyException = Class.new(ClientError)
    CampaignException = Class.new(ClientError)
    ImageException = Class.new(ClientError)
    ClassException = Class.new(ClientError)
    UserException = Class.new(ClientError)
    CatchAll = Class.new(ClientError)

    ServerError = Class.new(self)
    InternalServerError = Class.new(ServerError)
    BadGateway = Class.new(ServerError)
    ServiceUnavailable = Class.new(ServerError)
    GatewayTimeout = Class.new(ServerError)

    ERRORS = {
      888 => Ohmage::Error::CatchAll, # just, i don't know, catch 'em all.
      400 => Ohmage::Error::BadRequest,
      401 => Ohmage::Error::Unauthorized,
      404 => Ohmage::Error::NotFound,
      405 => Ohmage::Error::Unauthorized,
      406 => Ohmage::Error::NotAcceptable,
      500 => Ohmage::Error::InternalServerError,
      502 => Ohmage::Error::BadGateway,
      503 => Ohmage::Error::ServiceUnavailable,
      504 => Ohmage::Error::GatewayTimeout
    }
    # How ugly is this??
    STRING_ERRORS = {
      '0100' => Ohmage::Error::InternalServerError,
      '0101' => Ohmage::Error::InternalServerError,
      # Auth
      '0200' => Ohmage::Error::Unauthorized,
      '0201' => Ohmage::Error::Unauthorized,
      '0202' => Ohmage::Error::Unauthorized,
      '0203' => Ohmage::Error::InvalidToken
    }
    ('0300'..'0399').to_a.each do |e|
      STRING_ERRORS[e] = Ohmage::Error::InvalidParameter
    end
    ('0500'..'0599').to_a.each do |e|
      STRING_ERRORS[e] = Ohmage::Error::MobilityException
    end
    ('0600'..'0699').to_a.each do |e|
      STRING_ERRORS[e] = Ohmage::Error::SurveyException
    end
    ('0700'..'0799').to_a.each do |e|
      STRING_ERRORS[e] = Ohmage::Error::CampaignException
    end
    ('0800'..'0899').to_a.each do |e|
      STRING_ERRORS[e] = Ohmage::Error::ImageException
    end
    ('0900'..'0999').to_a.each do |e|
      STRING_ERRORS[e] = Ohmage::Error::ClassException
    end
    ('1000'..'1099').to_a.each do |e|
      STRING_ERRORS[e] = Ohmage::Error::UserException
    end
    ('1100'..'1899').to_a.each do |e|
      STRING_ERRORS[e] = Ohmage::Error::CatchAll
    end
    class << self
      # Create a new error from an HTTP response
      #
      # @param body [String]
      # @return [Ohmage::Error]
      def from_response(body)
        message, code = parse_error(body)
        # ohmage returns own error codes in body and as strings.
        if code.is_a? String
          new(message, 888)
        else
          new(message, code)
        end
      end

    private

      def parse_error(body)
        if body.nil? || body.empty?
          ['', nil]
        elsif body[:errors]
          extract_message_from_errors(body)
        end
      end

      def extract_message_from_errors(body)
        first = Array(body[:errors]).first
        [first[:text], first[:code]]
      end
    end
    # Initializes a new Error object
    #
    # @param message [Exception, String]
    # @param rate_limit [Hash]
    # @param code [Integer]
    # @return [Ohmage::Error]
    def initialize(message = '', code = nil)
      super(message)
      @code = code
    end
  end
end

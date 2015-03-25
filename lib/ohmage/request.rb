module Ohmage
  class Request
    def initialize(client, request_method, api, options = {}) # rubocop:disable MethodLength
      @client = client
      @uri = Addressable::URI.parse(@client.server_url + @client.path + api)
      @options = options
      @options['client'] = @client.client_string
      case api
      when 'config/read', 'user/auth_token', 'user/auth'
        # these calls don't need auth
      else
        @client.auth if @client.token.nil?
        @options['auth_token'] = @client.token
      end

      @request_method = request_method
    end
    def perform # rubocop:disable all
      response = HTTP.public_send(@request_method, @uri.to_s, params: @options)
      response_body = symbolize_keys!(response.parse)
      response_headers = response.headers
      begin
        fail_or_return_response_body(response.status, response_body, response_headers)
      rescue Ohmage::Error::InvalidToken
        @client.auth
        # refactor this, essentially recursively performs the request if it token failed
        # on the first try. bad, bad, bad.
        @options['auth_token'] = @client.token
        response = HTTP.public_send(@request_method, @uri.to_s, params: @options)
        response_body = symbolize_keys!(response.parse)
        response_headers = response.headers
        fail_or_return_response_body(response.status, response_body, response_headers)
      end
    end

    def symbolize_keys!(object)
      if object.is_a?(Array)
        object.each_with_index do |val, index|
          object[index] = symbolize_keys!(val)
        end
      elsif object.is_a?(Hash)
        object.keys.each do |key|
          object[key.to_sym] = symbolize_keys!(object.delete(key))
        end
      end
      object
    end

    def fail_or_return_response_body(code, body, headers)
      error = error(code, body, headers)
      fail(error) if error
      body
    end

    def error(code, body, _headers) # rubocop:disable all
      # ohmage doesn't really return HTTP error codes
      # so we're going to catch the real ones first, assuming
      # they are sent from the web server (like 502 or 404)
      klass = Ohmage::Error::ERRORS[code]
      if klass.nil?
        # we're not necessarily sure that this really isn't an error
        # so we have to inspect the response body to look for result:failure
        if body[:result] == 'failure'
          # then ohmage also considers this a failure. weird, but let's try a new way to handle this
          # we also want to smartly handle auth token errors, since we ohmage does not currently have
          # persistent tokens
          @code = body[:errors].first[:code]
          @message = body[:errors].first[:text]
          if @message =~ /token/ # rubocop:disable Metrics/BlockNesting
            @code = '0203' # a new fake error code for catching token errors
          end
          klass = Ohmage::Error::STRING_ERRORS[@code]
          klass.from_response(body) # refactor this.
        end # body has { "result": "success" }, so let's assume it isn't a failure.
      else
        # return the base error
        klass.from_response(body)
      end
    end
  end
end

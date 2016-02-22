require 'ohmage/api'
require 'ohmage/request'

module Ohmage
  class Client
    include Ohmage::API
    attr_accessor :port, :path, :client_string, :user, :password, :token, :server_config, :server_url, :server_debug
    def initialize(options = {}) # rubocop:disable MethodLength
      self.server_url = ENV['OHMAGE_SERVER_URL']
      self.user = ENV['OHMAGE_USER']
      self.password = ENV['OHMAGE_PASSWORD']
      self.client_string = 'ruby-ohmage'
      self.path = 'app/'
      self.port = 443
      self.server_debug = false
      options.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
      yield(self) if block_given?
      server_config_read
      self
    end

    #
    # ohmage config/read call
    # @returns [Hash] of server config details
    #
    def server_config_read
      request = Ohmage::Request.new(self, :get, 'config/read', {})
      resp = request.perform
      self.server_config = resp[:data]
    end

    #
    # ohmage user/auth_token call
    # @see https://github.com/ohmage/server/wiki/User-Authentication#statefulAuthentication
    # @returns String: auth_token valid for server's auth_token_lifetime param
    #
    def auth_token
      params = {}
      params['user'] = user
      params['password'] = password
      request = Ohmage::Request.new(self, :post, 'user/auth_token', params)
      resp = request.perform
      self.token = resp[:token]
      resp[:token]
    end
    alias_method :auth, :auth_token

    # Masking password from inspected client.
    # Lovingly lifted from https://github.com/octokit/octokit.rb,
    # The full text of the license for this work (MIT) can be found at
    # http://opensource.org/licenses/mit
    # @return [String]
    def inspect
      inspected = super
      inspected.gsub! @password, '*******' if @password
    end
  end
end

require 'ohmage/api'
require 'ohmage/request'

module Ohmage
  class Client 
    include Ohmage::API
    attr_accessor :host
    attr_accessor :port
    attr_accessor :path
    attr_accessor :client_string
    attr_accessor :user
    attr_accessor :password
    attr_accessor :token
    attr_accessor :server_config
    def initialize(options={})
      # Normalize key to String to allow indifferent access.
      options = options.inject({}) do |accu, (key, value)|
        accu[key.to_sym] = value
        accu
      end
      self.host = options[:host] || 'https://test.mobilizingcs.org'
      self.port = options[:port] || 443
      self.path = options[:path] || '/app/'
      self.user = options[:user] || 'mobilize-teacher'
      self.password = options[:password] || Object::ENV['ohmage_password']
      self.client_string = options[:client_string] || 'ruby-ohmage'
      server_config_read
      return self
    end
    #
    # ohmage config/read call
    # @returns [Hash] of server config details
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
      params['user'] = self.user
      params['password'] = self.password
      request = Ohmage::Request.new(self, :post, 'user/auth_token', params)
      resp = request.perform
      self.token = resp[:token]
      return resp[:token]
    end
    alias_method :auth, :auth_token
  end
end
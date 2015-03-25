require 'http'
require 'addressable/uri'
require 'ohmage/error'
require 'ohmage/client'
require 'ohmage/user'
require 'ohmage/request'
require 'ohmage/entity/user'
require 'ohmage/entity/clazz'
require 'ohmage/entity/campaign'
require 'ohmage/version'

module Ohmage
  # @return [Ohmage::Client]
  def self.client(options = {})
    Ohmage::Client.new(options)
  end

  # Delegate to Ohmage::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Ohmage::Client
  def self.respond_to?(method)
    client.respond_to?(method) || super
  end
end

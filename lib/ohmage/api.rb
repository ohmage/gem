require 'ohmage/user'
require 'ohmage/campaign'
require 'ohmage/clazz'
require 'ohmage/document'
require 'ohmage/media'

module Ohmage
  module API
    include Ohmage::API::User
    include Ohmage::API::Clazz
    include Ohmage::API::Campaign
    include Ohmage::API::Document
    include Ohmage::API::Media
  end
end

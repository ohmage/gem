require 'ohmage/user'
require 'ohmage/campaign'
require 'ohmage/clazz'

module Ohmage
  module API
    include Ohmage::API::User
    include Ohmage::API::Clazz
    include Ohmage::API::Campaign
  end
end
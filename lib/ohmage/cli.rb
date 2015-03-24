require 'thor'
require 'ohmage'
require 'ohmage/cli_helpers'

module Ohmage
  class CLI < Thor
    include Ohmage::CLI_Helpers

    class List < Thor
      class_option :table, :aliases => :t, :type => :boolean, :desc => 'formats output as table'

      desc "ls campaign <options>", "Lists campaigns current user has access to"
      option :search, :aliases => :s, :desc => 'a search string to limit the returned campaign list'
      def campaign
        ls = Ohmage.campaign_read({'campaign_name_search' => options[:search], 'output_format' => 'short'})
        Ohmage::CLI_Helpers.format_output(ls, options[:table], [:name, :urn, :description], :urn)
      end

      desc "ls class <options>", "Lists classes current user has access to"
      method_option :aliases => "class"
      def classes(urn_list=nil)
        ls = Ohmage.class_read('class_urn_list' => urn_list)
        Ohmage::CLI_Helpers.format_output(ls, options[:table], [:name, :urn, :description, :role, :users], :urn)
      end

      desc "ls user <options>", "Lists users that match criteria of search, all viewable if no search"
      option :search, :aliases => :s, :desc => 'a search string to limit the returned user list'
      def user(username=nil)
        ls = Ohmage.user_read('user_list' => username, 'username_search' => options[:search])
        Ohmage::CLI_Helpers.format_output(ls, options[:table], [:username, :email_address, :enabled], :username)
      end
    end

    class Create < Thor

      desc "create user <username> <options>", "creates a new ohmage user with parameters"
      option :password, :required => true, :aliases => :p, :desc => 'value for new user password'
      option :admin, :type => :boolean, :default => false, :desc => 'is user admin?'
      option :enabled, :type => :boolean, :default => true, :desc => 'is user enabled?'
      option :new, :type => :boolean, :aliases => :first_login, :default => true, :desc => 'force password reset on first login?'
      def user(username)
        new_user = Ohmage.user_create('username' => username, 
                                  'password' => options[:password], 
                                  'admin' => options[:admin],
                                  'enabled' => options[:enabled],
                                  'new_account' => options[:new])
        Ohmage::CLI_Helpers.format_output(new_user, options[:table], [:username], :username)
      end
    end

    desc "hi", "returns current config"
    def hi
      conf = Ohmage.client()
      puts "Server: "+conf.host
      puts "Current User: "+conf.user
      conf.server_config.each do |k,v|
        puts k.to_s+": "+v.to_s
      end
    end

    # Allow use of either ls or list. I don't see any reference to aliasing subcommands
    # so i'll just do this for now!
    %w(ls list).each do |l|
      desc "#{l} <entity>", "lists specified entity current user has access to"
      subcommand l, List
    end

    desc "create <entity>", "creates an entity matching the required info."
    subcommand "create", Create

  end
end

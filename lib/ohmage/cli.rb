require 'thor'
require 'ohmage'
require 'ohmage/cli_helpers'

module Ohmage
  class CLI < Thor
    include Ohmage::CliHelpers

    class List < Thor
      class_option :table, aliases: :t, type: :boolean, desc: 'formats output as table'

      desc 'ls campaign <options>', 'Lists campaigns current user has access to'
      option :search, aliases: :s, desc: 'a search string to limit the returned campaign list'
      def campaign
        ls = Ohmage.campaign_read(campaign_name_search: options[:search], output_format: 'short')
        Ohmage::CliHelpers.format_output(ls, options[:table], [:name, :urn, :description], :urn)
      end

      desc 'ls class <options>', 'Lists classes current user has access to'
      def clazz(urn_list = nil)
        ls = Ohmage.class_read(class_urn_list: urn_list)
        Ohmage::CliHelpers.format_output(ls, options[:table], [:name, :urn, :description, :role, :users], :urn)
      end
      map :class => :clazz

      desc 'ls user <options>', 'Lists users that match criteria of search, all viewable if no search'
      option :search, aliases: :s, desc: 'a search string to limit the returned user list'
      def user(username = nil)
        ls = Ohmage.user_read(user_list: username, username_search: options[:search])
        Ohmage::CliHelpers.format_output(ls, options[:table], [:username, :first_name, :last_name, :email_address, :enabled, :admin, :new_account], :username)
      end
    end

    class Create < Thor
      class_option :table, aliases: :t, type: :boolean, desc: 'formats output as table'

      desc 'create user <username> <options>', 'creates a new ohmage user with parameters'
      option :password, required: true, aliases: :p, desc: 'value for new user password'
      option :admin, type: :boolean, default: false, desc: 'is user admin?'
      option :enabled, type: :boolean, default: true, desc: 'is user enabled?'
      option :new, type: :boolean, aliases: :first_login, default: true, desc: 'force password reset on first login?'
      def user(username)
        new_user = Ohmage.user_create(username: username,
                                      password: options[:password],
                                      admin: options[:admin],
                                      enabled: options[:enabled],
                                      new_account: options[:new])
        Ohmage::CliHelpers.format_output(new_user, options[:table], [:username], :username)
      end

      desc 'create class <class_urn> <class_name> <options>', 'creates a new ohmage class with parameters'
      option :description, aliases: :d, type: :string, desc: 'description of class'
      def clazz(urn, name)
        new_class = Ohmage.class_create(class_urn: urn,
                                        class_name: name,
                                        description: options[:description])
        Ohmage::CliHelpers.format_output(new_class, options[:table], [:urn, :name, :description], :urn)
      end
      map :class => :clazz
    end

    class Delete < Thor
      desc 'delete class <class_urn>', 'deletes an existing ohmage class'
      def clazz(urn)
        Ohmage.class_delete(class_urn: urn)
      end
      map :class => :clazz

      desc 'delete user <username>', 'deletes an existing ohmage user'
      def user(username)
        Ohmage.user_delete(user_list: username)
      end

      desc 'delete campaign <campaign_urn>', 'deletes an existing ohmage campaign'
      def campaign(urn)
        Ohmage.campaign_delete(campaign_urn: urn)
      end
    end

    class Update < Thor
      class_option :table, aliases: :t, type: :boolean, default: true, desc: 'formats output as table'

      desc 'update user <username> <options>', 'updates provided values for a given username'
      option :admin, type: :boolean, desc: 'is user admin?'
      option :usersetup, type: :boolean, desc: 'user_setup privilege?'
      option :new, type: :boolean, desc: 'force pw reset on login?'
      def user(username)
        updated_user = Ohmage.user_update(username: username,
                                          admin: options[:admin],
                                          enabled: options[:enabled],
                                          user_setup_privilege: options[:user_setup],
                                          new_account: options[:new])
        Ohmage::CliHelpers.format_output(updated_user, options[:table], [:username, :admin, :enabled, :new_account], :username)
      end

      desc 'update password <username> <options>', "updates provided user's password"
      option :password, required: true, aliases: :p, desc: 'new password for user'
      def password(username)
        Ohmage.user_password(username: username, new_password: options[:password])
      end
    end

    desc 'hi', 'returns current config'
    def hi
      conf = Ohmage.client
      puts 'Server: ' + conf.host
      puts 'Current User: ' + conf.user
      conf.server_config.each do |k, v|
        puts k.to_s + ': ' + v.to_s
      end
    end

    # Allow use of either ls or list. I don't see any reference to aliasing subcommands
    # so i'll just do this for now!
    %w(ls list).each do |l|
      desc "#{l} <entity>", 'lists specified entity current user has access to'
      subcommand l, List
    end

    desc 'create <entity>', 'creates an entity matching the required info.'
    subcommand 'create', Create

    desc 'delete <entity>', 'deletes an entity matching required info'
    subcommand 'delete', Delete

    desc 'update <entity>', 'updates an entity matching info'
    subcommand 'update', Update
  end
end

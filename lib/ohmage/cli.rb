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
      map class: :clazz

      desc 'ls user <options>', 'Lists users that match criteria of search, all viewable if no search'
      option :search, aliases: :s, desc: 'a search string to limit the returned user list'
      def user(username = nil)
        ls = Ohmage.user_read(user_list: username, username_search: options[:search])
        Ohmage::CliHelpers.format_output(ls, options[:table], [:username, :first_name, :last_name, :email_address, :enabled, :admin, :new_account], :username)
      end

      desc 'ls document <options>', 'Lists documents that match criteria and parameters'
      option :search, aliases: :s, desc: 'a search string to limit the returned user list'
      option :campaign, desc: 'limit results to only documents attached to given urn list'
      option :class, desc: 'limit results to only documents attached to given urn list'
      option :description, aliases: :d, desc: 'limit results to those with this string in description'
      option :personal, type: :boolean, desc: 'will return only documents explicitly related to user if true'
      def document()
        ls = Ohmage.document_read(document_name_search: options[:search],
                                  document_description_search: options[:description],
                                  campaign_urn_list: options[:campaign],
                                  class_urn_list: options[:class],
                                  personal_documents: options[:personal])
        Ohmage::CliHelpers.format_output(ls, options[:table], [:urn, :name, :description, :privacy_state], :name)
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
      map class: :clazz

      desc 'create document <file> <options>', 'creates a new document with parameters'
      option :description, aliases: :d, type: :string, desc: 'description of document'
      option :name, aliases: :n, type: :string, desc: 'name of document (defaults to filename if not passed)'
      option :share, type: :boolean, default: false, desc: 'is document private or shared?'
      option :class_role, type: :string, desc: 'class_role param: like urn:class:public;reader'
      option :campaign_role, type: :string, desc: 'campaign_role param: like urn:campaign:snack;reader'
      def document(file)
        case options[:share]
        when false
          privacy_state = 'private'
        else
          privacy_state = 'shared'
        end
        if options[:campaign_role].nil? && options[:class_role].nil?
          puts 'must supply one of [--class_role, --campaign_role]'
        elsif options[:name].nil?
          new_document = Ohmage.document_create(file,
                                                document_class_role_list: options[:class_role],
                                                document_campaign_role_list: options[:campaign_role],
                                                privacy_state: privacy_state,
                                                description: options[:description])
        else
          new_document = Ohmage.document_create(file,
                                                document_class_role_list: options[:class_role],
                                                document_campaign_role_list: options[:campaign_role],
                                                privacy_state: privacy_state,
                                                description: options[:description],
                                                document_name: options[:name])
        end          
          Ohmage::CliHelpers.format_output(new_document, options[:table], [:urn, :name, :description, :privacy_state], :name)
      end

    end

    class Delete < Thor
      desc 'delete class <class_urn>', 'deletes an existing ohmage class'
      def clazz(urn)
        Ohmage.class_delete(class_urn: urn)
      end
      map class: :clazz

      desc 'delete user <username>', 'deletes an existing ohmage user'
      def user(username)
        Ohmage.user_delete(user_list: username)
      end

      desc 'delete campaign <campaign_urn>', 'deletes an existing ohmage campaign'
      def campaign(urn)
        Ohmage.campaign_delete(campaign_urn: urn)
      end

      desc 'delete document <document_id>', 'deletes an existing ohmage document'
      def document(id)
        Ohmage.document_delete(document_id: id)
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

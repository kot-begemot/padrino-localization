require 'padrino-localization/middleware'

module Padrino
  module Localization
    MAPPING = '/(:locale)/'.freeze

    module Urls
      def self.registered(app)
        app.helpers self
      end

      def self.included(base)
        base.instance_eval do
          alias_method_chain :url, :locale
        end
      end

      ###
      # Generates an URL with a current locale, for a resource, inside of application.
      #
      # Example:
      #
      #   url_for_with_locale(:users) # /ru/users
      #
      #   url_for_with_locale('/') # /ru/
      #
      #   url_for_with_locale(:posts, :new, :locale => 'se') # /se/posts/new
      #
      def url_with_locale *args
        locale_scope = (::I18n.locale == ::I18n.default_locale) ? {} : {locale: ::I18n.locale}
        if args.last.kind_of? Hash
          # should not overwrite provided locale
          args.last.merge!(locale_scope)
          url_without_locale *args
        else
          url_without_locale *args, locale_scope
        end.gsub('//','/')
      end

      ###
      # Returns a link, unless application locale is equivalent to those from URL.
      #
      # Examples:
      #
      #   link_to_unless_current_locale :ru, "Main page", url(:main, :index, :locale => :ru)
      #   # => "Main page"
      #
      #   link_to_unless_current_locale :ru, "Main page", url(:main, :index, :locale => :ru)
      #   # => "Main page"
      #
      def link_to_unless_current_locale *opts, &block
        locale = opts.shift.to_s
        if locale == ::I18n.locale.to_s
          opts.first
        else
          link_to *opts, &block
        end
      end
    end
  end
end
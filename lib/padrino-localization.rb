require 'padrino-localization/middleware'

module Padrino
  module Localization
    MAPPING = '/(:locale)/'.freeze

    module Urls
      def self.registered(app)
        app.helpers self
        app.extend ::Padrino::Localization::Urls::ClassMethods
        app.instance_eval do
          alias :url_without_locale :url
          alias :url :url_with_locale
          alias :url_for :url_with_locale
        end
      end

      module ClassMethods

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
          opts = args.extract_options!
          locale_scope = opts.delete(:locale) || ::I18n.locale
          locale_scope = ::I18n.locale unless Padrino::Localization::Middleware.languages.include?(locale_scope.to_s)
          args << opts
          link = url_without_locale *args
          link.insert(0,"/#{locale_scope}") if (locale_scope.to_s != ::I18n.default_locale.to_s)
          link
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
end
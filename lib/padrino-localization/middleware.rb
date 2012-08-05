module Padrino
  module Localization
    class Middleware
      attr_reader :languages
      alias_method :langs, :languages

      def initialize(app, langs)
        @app = app
        self.languages = langs
      end

      def call(env)
        @env = env
        set_locale
        response_array = @app.call(@env)
        unset_locale
        response_array
      end

      private

      def languages= langs
        @languages = langs.collect do |l|
          raise ArgumentError.new("An arguments should be 2 latters long") unless l.to_s =~ /\A[a-z]{2}\Z/i
          l.to_s
        end
      end
      alias_method :langs=, :languages=

      def locale_pattern
        @locale_pattern ||= /\A\/(#{langs.join('|')})?(\/?.*|)/i
      end

      def set_locale
        ::I18n.locale = locale_from_url.to_sym if locale_defined_in_url?
      end

      def unset_locale
        ::I18n.locale = ::I18n.default_locale if locale_defined_in_url?
        @locale_set = @locale = nil
      end

      ###
      # Determine locale from the request URL and return it as a string, it it
      # is matching any of provided locales
      # If locale matching failed an empty String will be returned.
      #
      # Examples:
      #
      #   #http://www.example.com/se
      #   locale_from_url # => 'se'
      #
      #   #http://www.example.com/de/posts
      #   locale_from_url # => 'se'
      #
      #   #http://www.example.com/ursers
      #   locale_from_url # => ''
      #
      def locale_from_url path_info = nil
        @locale_set ||= begin
          @locale ||= (match = (path_info || @env['PATH_INFO']).match(locale_pattern)) ? match[1] : nil
          @env['PATH_INFO'] = match[2] if match && @env.try(:fetch, 'PATH_INFO')
          true
        end
        @locale
      end

      ###
      # Try to determine, weather the locale is defined, from request URL, if it is matching any of
      # provided locales, and returns boolean as a result.
      #
      # Examples:
      #
      #   #http://www.example.com/se
      #   locale_from_url # => true
      #
      #   #http://www.example.com/de/posts
      #   locale_from_url # => true
      #
      #   #http://www.example.com/ursers
      #   locale_from_url # => false
      #
      def locale_defined_in_url?
        !locale_from_url.blank?
      end
    end
  end
end
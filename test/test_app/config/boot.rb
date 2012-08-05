require 'bundler'
# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

# Only have default and environemtn gems
Bundler.setup(:default, :test)
# Only require default and environment gems
Bundler.require(:default, :test)

##
# Add here your before load hooks
#
Padrino.before_load do
  ::I18n.default_locale = :en
end

##
# Add here your after load hooks
#
Padrino.after_load do
end

Padrino.load!

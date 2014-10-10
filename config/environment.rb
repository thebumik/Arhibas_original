RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# bootstrap the rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # gems dependencies
  config.gem 'haml',
              :version => '2.2.8',
              :source => 'http://gemcutter.org'

  config.gem 'configatron',
              :version => '2.5.1',
              :source => 'http://gemcutter.org'

  config.gem 'authlogic',
              :version => '2.1.2',
              :source => 'http://gemcutter.org'

  config.gem 'maruku',
              :version => '0.6.0',
              :source => 'http://gemcutter.org'

  config.gem 'paperclip',
              :version => '2.3.1.1',
              :source => 'http://gemcutter.org'

  config.gem 'will_paginate',
              :version => '2.3.11',
              :source => 'http://gemcutter.org'

  config.gem 'mail_form',
              :version => '1.0.0',
              :source => 'http://gemcutter.org'

  # use current load order for plugins
  config.plugins = [:exception_notification, :all]

  # default timezone
  config.time_zone = 'Bucharest'
end

# haml configuration
Haml::Template.options = { :format => :xhtml, :ugly => false }

MISSING_TRANSLATION = '! missing translation...'
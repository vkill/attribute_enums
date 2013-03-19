#coding: utf-8
require "rubygems"
require "bundler/setup"

require "attribute_enums/active_record"
require 'i18n'

I18n.load_path << Dir[ File.expand_path("../support/locales/**/*.{rb,yml}", __FILE__) ]
I18n.reload!

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end


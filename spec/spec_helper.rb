#encoding: utf-8

ENV["RAILS_ENV"] ||= 'test'
require "rails3_0_app/config/environment"
ActiveRecord::Migrator.migrate(File.expand_path("../rails3_0_app/db/migrate", __FILE__))
I18n.load_path << Dir[ File.expand_path("../support/locales/**/*.{rb,yml}", __FILE__) ]
I18n.reload!


require "rubygems"
require "bundler/setup"
require "attribute_enums"
require "pry"

require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rspec'
require 'timecop'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end


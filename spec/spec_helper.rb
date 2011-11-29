#encoding: utf-8

ENV["RAILS_ENV"] ||= 'test'
require "rails3_0_app/config/environment"

require "rubygems"
require "attribute_enums"
require "pry"

require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rspec'
require 'timecop'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.before do
    ActiveRecord::Migrator.migrate(File.expand_path("../rails3_0_app/db/migrate", __FILE__))
  end
end

I18n.locale = :en
I18n.load_path << File.expand_path("../support/locales/user_en.yml", __FILE__)

ActiveRecord::Migrator.migrate(File.expand_path("../rails3_0_app/db/migrate", __FILE__))


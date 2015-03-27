# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.before(:suite) do
    neo4j_url = 'http://localhost:7475'
    uri = URI.parse(neo4j_url)
    server_url = "http://#{uri.host}:#{uri.port}"
    Neo4j::Session.open(:server_db, server_url, basic_auth: { username: uri.user, password: uri.password})
    Neo4j::Session.current._query('MATCH (c) OPTIONAL MATCH (c)-[r]-n DELETE n,r,c')
  end

  def delete_all
    IsA::Category.destroy_all
    IsA::Characteristic.destroy_all
  end

  config.before(:each) do |example|
    delete_all
  end

  config.after(:all) do |example|
    delete_all
  end

end

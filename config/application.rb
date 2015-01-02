require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require 'neo4j'
require 'neo4j/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ContextManager
  class Application < Rails::Application

    config.generators do |g|
      g.orm             :neo4j
      g.test_framework  :rspec, :fixture => false
    end

    config.neo4j.session_type = :server_db
    config.neo4j.session_path = ENV["GRAPHENEDB_URL"] || 'http://localhost:7474'
    config.neo4j.storage_path = "#{config.root}/db/neo4j-#{Rails.env}"
    config.neo4j.identity_map = false
  end

end


#Neo4j::Session.open :server_db, "http://localhost:7474"


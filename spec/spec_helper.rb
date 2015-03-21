require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
end

require 'rubygems'
require 'database_cleaner'
require 'rake'
require 'gramercy'
require 'neo4j'
require 'approvals/rspec'

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

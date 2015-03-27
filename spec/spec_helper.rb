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


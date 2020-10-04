$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'byebug'
require 'pry-byebug'

require 'activemodel/associations'
ActiveModel::Associations::Hooks.init

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

# Test Class
class User < ActiveRecord::Base; end

ActiveRecord::Migration.verbose = false

if ActiveRecord.version <= Gem::Version.new("5.2.0")
  ActiveRecord::MigrationContext.new(
    File.expand_path("../db/migrate", __FILE__)
  ).migrate
elsif ActiveRecord.version >= Gem::Version.new("6.0.0")
  ActiveRecord::MigrationContext.new(
    File.expand_path("../db/migrate", __FILE__),
    ActiveRecord::SchemaMigration
  ).migrate
else
  raise "Unsupported Rails version"
end

require 'database_cleaner'

RSpec.configure do |config|
  config.order = :random

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

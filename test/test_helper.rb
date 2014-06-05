require 'top_hits'
require 'erb'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/mini_test'
require 'active_record'
require 'database_cleaner'
require 'fakeweb'
 
connection_info = YAML.load(ERB.new(File.read("./test/config/database.yml")).result)
ActiveRecord::Base.establish_connection(connection_info)

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end



require 'dotenv/load'
require 'active_record'
require 'json'
require 'faraday'

Dir['models/**.rb', 'services/**.rb'].each { |file| require_relative file }

ActiveRecord::Base.establish_connection(ENV['DB_URL'])
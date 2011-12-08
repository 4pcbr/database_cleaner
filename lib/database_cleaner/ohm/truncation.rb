require 'database_cleaner/ohm/base'
require 'database_cleaner/generic/truncation'
require 'database_cleaner/mongo/truncation'

module DatabaseCleaner
  module Ohm
    class Truncation
      include ::DatabaseCleaner::Ohm::Base
      include ::DatabaseCleaner::Generic::Truncation

      private

      def clean
        database.flushdb
        true
      end
      
      def database
        Ohm.redis
      end

  end
  end
end

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
        if @only
          collections.each { |c| c.remove if @only.include?(c.name) }
        else
          collections.each { |c| c.remove unless @tables_to_exclude.include?(c.name) }
        end
        true
      end

      def collections
        database.collections.select { |c| c.name !~ /^system\./ }
      end

      def database
        ::Ohm.redis
      end

  end
  end
end

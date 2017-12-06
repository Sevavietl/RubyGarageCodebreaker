require 'csv'

module Codebreaker
  module Storage
    # Storage that uses csv file as data container.
    class CsvStorage
      def initialize(filename)
        @filename = filename
      end

      def save(record)
        CSV.open(filename, 'a') { |csv| csv << record }
      end

      def to_a
        CSV.read filename
      end

      private

      attr_accessor :filename
    end
  end
end

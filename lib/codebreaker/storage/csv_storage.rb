require 'csv'

module Codebreaker
  module Storage
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

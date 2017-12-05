module Codebreaker
  module Storage
    class InMemoryStorage
      def initialize
        @data = []
      end

      def save(record)
        data << record
      end

      def to_a
        data
      end

      private

      attr_accessor :data
    end
  end
end

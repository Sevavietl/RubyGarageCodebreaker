module Codebreaker
  module Storage
    # Storage that uses plain array as data container.
    # Be aware, that all data kept in memory,
    # so it all will be gone after program stops.
    # Used simply for fall back solition,
    # when no other storage is specified for the game.
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

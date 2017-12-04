require 'csv'

module Codebreaker
  class Storage
    def initialize(filename)
      @filename = filename
    end

    def save(player_name, number_of_attempts, result)
      CSV.open(@filename, 'a') do |csv|
        csv << [player_name, number_of_attempts, result]
      end
    end

    def to_a
      CSV.read(@filename)
    end
  end
end

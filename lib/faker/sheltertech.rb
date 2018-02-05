# frozen_string_literal: true

module Faker
  class ShelterTech < Base
    class << self
      def description
        fetch 'shelter_tech.description'
      end
    end
  end
end

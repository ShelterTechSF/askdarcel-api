# frozen_string_literal: true

module Services
  module Services
    include Errors

    def self.deactivate(id)
      service = Service.find id
      raise Errors::PreconditionFailed unless service.approved?

      service.inactive!
      remove_from_algolia(service)
    end

    def self.remove_from_algolia(service)
      service.remove_from_index!
    rescue StandardError
      puts 'failed to remove service ' + service.id.to_s + ' from algolia index'
    end
  end
end

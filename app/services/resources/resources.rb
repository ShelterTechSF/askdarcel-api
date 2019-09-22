# frozen_string_literal: true

module Services
  module Resources
    include Errors

    def self.deactivate(id)
      resource = Resource.find id
      raise Errors::PreconditionFailed unless resource.approved?

      resource.inactive!
      remove_from_algolia(resource)
      resource.services.each do |service|
        Services.deactivate service
      end
    end

    def self.remove_from_algolia(resource)
      resource.remove_from_index!
    rescue StandardError
      puts 'failed to remove resource ' + resource.id.to_s + ' from algolia index'
    end
  end
end

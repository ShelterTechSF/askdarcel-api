# frozen_string_literal: true

module Eligibilities
  module ResourceCounts
    # Given a list of eligibility ids, return a map from eligibility id to number
    # of resources associated with that eligibility.
    #
    # Performance note: For efficiency, this method only executes two SQL
    # queries. It relies on the assumption that the number of associations
    # between eligibilities and resources is small enough to fit in memory easily
    # (i.e. on the order of 100s).
    #
    # @param :eligibility_ids [ Array<Integer> ] array of eligibility ids
    # @return [ Hash ] map whose keys are eligibility ids and whose values are
    # the number of resources associated with the eligibility
    def self.compute(eligibility_ids)
      # Compute map from eligibility_id to set of service_ids
      pairs = EligibilitiesService.where(eligibility_id: eligibility_ids).pluck(:eligibility_id, :service_id)
      eligibility_to_services = compute_eligibility_to_services(pairs)
      service_ids = pairs.map(&:last).uniq

      # Compute map from service_id to resource_id
      service_to_resource = Service.where(id: service_ids).pluck(:id, :resource_id).to_h

      # Using two maps above, compute map from eligibility_id to set of resource_ids
      eligibility_to_resources = compute_eligibility_to_resources(eligibility_to_services, service_to_resource)

      # Compute map from eligibility to resource_id count
      eligibility_to_resources.map do |eligibility_id, resource_ids|
        [eligibility_id, resource_ids.size]
      end.to_h
    end

    # Given a list of [eligibility_id, service_id] pairs, compute a hash that
    # maps from eligibility_id to set of service_ids.
    def self.compute_eligibility_to_services(eligibility_service_pairs)
      ret = Hash.new { |h, k| h[k] = Set.new }
      eligibility_service_pairs.each do |eligibility_id, service_id|
        ret[eligibility_id] << service_id
      end
      ret
    end

    private_class_method :compute_eligibility_to_services

    # Using the relationships in these hashes:
    # - map from eligibility_id to set of service_ids
    # - map from service_id to resource_id
    # return hash that maps from eligibility_id to set of resource_ids.
    def self.compute_eligibility_to_resources(eligibility_to_services, service_to_resource)
      ret = Hash.new { |h, k| h[k] = Set.new }
      eligibility_to_services.each do |eligibility_id, service_ids|
        service_ids.each do |service_id|
          resource_id = service_to_resource[service_id]
          next if resource_id.nil?

          ret[eligibility_id] << resource_id
        end
      end
      ret
    end

    private_class_method :compute_eligibility_to_resources
  end
end

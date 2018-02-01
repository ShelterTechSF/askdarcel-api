class ProgramsPresenter < Jsonite
	property :id
	property :name
	property :alternate_name
	property :description
	property(:services) do
    	# Filter services in Ruby to avoid ignoring prefetched rows and generating
    	# a new query.
    	approved_services = services.select(&:approved?)
    	ServicesPresenter.present(approved_services)
  	end
end
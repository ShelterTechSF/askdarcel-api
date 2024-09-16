class OrganizationsController < ApplicationController
    '''Organizations Controller. Key names changed to be HSDS compliant'''
    def index
        organization = Resource.order(:name)
        # push elements into list to meet formatting requirements for HSDS 
        organization_container = []
        organization.each do |element|
            organization_container.push(element)
        end
        render json: OrganizationsPresenter.present(organization_container)
    end
    def show
        # Find the relevant resource and adjust variables for HSDS form
        resource = Resource.find([params[:id]])
        
        render json: OrganizationsPresenter.present(resource)
    end
    
    def destroy
        org = Resource.find params[:id]
        org.delete
    end
    
    def organization
        # Note: We *must* use #preload instead of #includes to force Rails to make a
        # separate query per table. Otherwise, it creates one large query with many
        # joins, which amplifies the amount of data being sent between Rails and the
        # DB by several orders of magnitude due to duplication of tuples.
        Resource.preload(:resources)
    end
end

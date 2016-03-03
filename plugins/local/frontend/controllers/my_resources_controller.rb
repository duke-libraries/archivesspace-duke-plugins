# plugins/local/frontend/controllers/my_resources_controller.rb
# just adds a default sort param to the index action of the resources_controller
# can do a similar tweak to others, like accessions. 

require Rails.root.join('app/controllers/resources_controller')

class ResourcesController < ApplicationController


  def index
    params["sort"] ||= "create_time desc"
    @search_data = Search.for_type(session[:repo_id], params[:include_components]==="true" ? ["resource", "archival_object"] : "resource", params_for_backend_search.merge({"facet[]" => SearchResultData.RESOURCE_FACETS}))
  end

end
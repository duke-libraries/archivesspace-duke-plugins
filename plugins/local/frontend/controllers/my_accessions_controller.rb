# plugins/local/frontend/controllers/my_resources_controller.rb
# just adds a default sort param to the index action of the accession_controller
# can do a similar tweak to others, like accessions. 

require Rails.root.join('app/controllers/accessions_controller')

class AccessionsController < ApplicationController


  def index
    params["sort"] ||= "create_time desc"
     @search_data = Search.for_type(session[:repo_id], "accession", params_for_backend_search.merge({"facet[]" => SearchResultData.ACCESSION_FACETS}))
  end

end
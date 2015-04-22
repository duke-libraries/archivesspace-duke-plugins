# plugins/local/frontend/models/search_result_data.rb
# redefines facets, which you can see at:
# https://github.com/archivesspace/archivesspace/blob/master/frontend/app/models/search_result_data.rb#L215-L257


require Rails.root.join('app/models/search_result_data')

class SearchResultData

# this changes what facets are requested for Resource searches. Display order follows the order in the array. 
 def self.ACCESSION_FACETS
   ["accession_date_year","creators","subjects"]
 end

 def self.RESOURCE_FACETS
   ["level","publish","creators"]
 end
 
 def self.SUBJECT_FACETS
   ["first_term_type","source"]
 end
 
end
# plugins/local/backend/model/solr.rb
# simply adds a solr param to sort by index (alpha) rather than count. 

class Solr::Query

  
   def to_solr_url
     raise "Missing pagination settings" unless @pagination
     add_solr_param(:"facet.sort", "index") # add the sort
     unless @show_excluded_docs
       add_solr_param(:fq, "-exclude_by_default:true")
     end
     if @show_published_only
       add_solr_param(:fq, "publish:true")
     end
     unless @show_suppressed
       add_solr_param(:fq, "suppressed:false")
     end
     add_solr_param(:facet, "true")
     unless @facet_fields.empty?
       add_solr_param(:"facet.field", @facet_fields)
     end
     if @query_type == :edismax
       add_solr_param(:defType, "edismax")
       add_solr_param(:pf, "four_part_id^4")
       add_solr_param(:qf, "four_part_id^3 title^2 fullrecord")
     end
     Solr.search_hooks.each do |hook|
       hook.call(self)
     end
     url = @solr_url
     # retain path if present i.e. "solr/aspace/select" when using an external
     # Solr with path required
     url.path += "/select"
     url.query = URI.encode_www_form([[:q, @query_string],
     [:wt, @writer_type],
     [:start, (@pagination[:page] - 1) * @pagination[:page_size]],
     [:rows, @pagination[:page_size]]] +
     @solr_params)
     url
   
   end
  
end
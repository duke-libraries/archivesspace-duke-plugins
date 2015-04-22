# Customized for Duke
# Text fields
AdvancedSearch.define_field(:name => 'agents', :type => :text, :visibility => [:staff], :solr_field => 'agents')
AdvancedSearch.define_field(:name => 'created_by', :type => :text, :visibility => [:staff], :solr_field => 'created_by')
AdvancedSearch.define_field(:name => 'last_modified_by', :type => :text, :visibility => [:staff], :solr_field => 'last_modified_by')
AdvancedSearch.define_field(:name => 'accession_id_0', :type => :text, :visibility => [:staff], :solr_field => 'accession_id_0_u_ustr')
AdvancedSearch.define_field(:name => 'accession_id_1', :type => :text, :visibility => [:staff], :solr_field => 'accession_id_1_u_ustr')
AdvancedSearch.define_field(:name => 'user_defined_string_1', :type => :text, :visibility => [:staff], :solr_field => 'string_1_u_utext')


# Booleans
AdvancedSearch.define_field(:name => 'restrictions_apply', :type => :boolean, :visibility => [:staff], :solr_field => 'restrictions_apply')
AdvancedSearch.define_field(:name => 'access_restrictions', :type => :boolean, :visibility => [:staff], :solr_field => 'access_restrictions')
AdvancedSearch.define_field(:name => 'use_restrictions', :type => :boolean, :visibility => [:staff], :solr_field => 'use_restrictions')
AdvancedSearch.define_field(:name => 'has_external_documents', :type => :boolean, :visibility => [:staff], :solr_field => 'has_external_documents')
AdvancedSearch.define_field(:name => 'has_rights_statements', :type => :boolean, :visibility => [:staff], :solr_field => 'has_rights_statements_u_ubool')

# Dates
AdvancedSearch.define_field(:name => 'date_begin', :type => :date, :visibility => [:staff], :solr_field => 'date_begin_u_udate')
AdvancedSearch.define_field(:name => 'date_end', :type => :date, :visibility => [:staff], :solr_field => 'date_end_u_udate')
AdvancedSearch.define_field(:name => 'accession_date', :type => :date, :visibility => [:staff], :solr_field => 'accession_date_u_udate')

# Enums
AdvancedSearch.define_field(:name => 'accession_acquisition_type', :type => :enum, :visibility => [:staff], :solr_field => 'acquisition_type')
#AdvancedSearch.define_field(:name => 'extent_extent_type', :type => :enum, :visibility => [:staff], :solr_field => 'extent_type_u_ustr')
#AdvancedSearch.define_field(:name => 'linked_agent_role', :type => :enum, :visibility => [:staff], :solr_field => 'agent_roles_u_ustr')
AdvancedSearch.define_field(:name => 'collection_management_processing_priority', :type => :enum, :visibility => [:staff], :solr_field => 'collection_management_processing_priority_u_ustr')
AdvancedSearch.define_field(:name => 'collection_management_processing_status', :type => :enum, :visibility => [:staff], :solr_field => 'collection_management_processing_status_u_ustr')
AdvancedSearch.define_field(:name => 'user_defined_enum_1', :type => :enum, :visibility => [:staff], :solr_field => 'enum_1_u_ustr')
AdvancedSearch.define_field(:name => 'user_defined_enum_3', :type => :enum, :visibility => [:staff], :solr_field => 'enum_3_u_ustr')
AdvancedSearch.define_field(:name => 'resource_finding_aid_status', :type => :enum, :visibility => [:staff], :solr_field => 'resource_finding_aid_status_u_ustr')
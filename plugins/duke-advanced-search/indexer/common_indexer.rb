class CommonIndexer
  self.add_attribute_to_resolve("linked_events")

  self.add_indexer_initialize_hook do |indexer|
    # Index extra Accession fields
    indexer.add_document_prepare_hook {|doc, record|
      if doc['primary_type'] == 'accession'
        # Accession Fields
        doc['accession_id_0_u_ustr'] = record['record']['id_0']
        doc['accession_id_1_u_ustr'] = record['record']['id_1']
        doc['accession_content_description_u_utext'] = record['record']['content_description']
        doc['accession_condition_description_u_utext'] = record['record']['condition_description']
        doc['accession_inventory_u_utext'] = record['record']['inventory']
        doc['accession_provenance_u_utext'] = record['record']['provenance']
        doc['accession_general_note_u_utext'] = record['record']['general_note']

        accession_date = fuzzy_time_parse(record['record']['accession_date'])
        if accession_date
          doc['accession_date_u_udate'] = accession_date
        end
      end
    }

    # Index extra fields for all records
    indexer.add_document_prepare_hook {|doc, record|
      # linked agent roles
      if record['record']['linked_agents']
        doc['agent_roles_u_ustr'] = record['record']['linked_agents'].collect{|link| link['role']}
      end

      # record has external documents?
      doc['has_external_documents_u_ubool'] =  (record['record']['external_documents'] || []).length > 0

      # record has rights statements?
      doc['has_rights_statements_u_ubool'] =  (record['record']['rights_statements'] || []).length > 0

      # Extent
      if record['record']['extents']
        doc['extent_number_u_ustr'] = record['record']['extents'].collect{|extent| extent["number"]}.compact
        doc['extent_type_u_ustr'] = record['record']['extents'].collect{|extent| extent["extent_type"]}.compact
        doc['extent_container_summary_u_utext'] = record['record']['extents'].collect{|extent| extent["container_summary"]}.compact
        doc['extent_physical_details_u_utext'] = record['record']['extents'].collect{|extent| extent["physical_details"]}.compact
      end

      # Dates
      if record['record']['dates']
        doc['date_begin_u_udate'] = record['record']['dates'].collect{|date|
          fuzzy_time_parse(date['begin'])
        }.compact
        doc['date_end_u_udate'] = record['record']['dates'].collect{|date|
          fuzzy_time_parse(date['end'])
        }.compact
      end

      # Collection Management Record
      if record['record']['collection_management']
        doc['collection_management_processing_priority_u_ustr'] = record['record']['collection_management']['processing_priority']
        doc['collection_management_processing_status_u_ustr'] = record['record']['collection_management']['processing_status']
        doc['collection_management_processors_u_utext'] = record['record']['collection_management']['processors']
      end

      # Linked Events
      if record['record']['linked_events']
        event_begin = []
        event_end = []
        event_type = []
        event_outcome = []

        record['record']['linked_events'].each do |event|
          if event['_resolved']['date']
            event_begin << fuzzy_time_parse(event['_resolved']['date']['begin'])
            event_end << fuzzy_time_parse(event['_resolved']['date']['end'])
          end
          event_type << event['_resolved']['event_type']
          event_outcome << event['_resolved']['outcome']
        end

        doc['event_begin_u_udate'] = event_begin.compact
        doc['event_end_u_udate'] = event_end.compact
        doc['event_type_u_ustr'] = event_type.compact
        doc['event_outcome_u_ustr'] = event_outcome.compact
      end
    }

    # Index user defined fields
    indexer.add_document_prepare_hook {|doc, record|
      if record['record']['user_defined']
        doc['string_1_u_ustr'] = record['record']['user_defined']['string_1']
        doc['string_3_u_ustr'] = record['record']['user_defined']['string_3']

        doc['text_1_u_utext'] = record['record']['user_defined']['text_1']
        doc['text_2_u_utext'] = record['record']['user_defined']['text_2']
        doc['text_3_u_utext'] = record['record']['user_defined']['text_3']
        doc['text_4_u_utext'] = record['record']['user_defined']['text_4']

        doc['enum_1_u_ustr'] = record['record']['user_defined']['enum_1']
        doc['enum_2_u_ustr'] = record['record']['user_defined']['enum_2']
        doc['enum_3_u_ustr'] = record['record']['user_defined']['enum_3']
      end
    }
  end

  def self.fuzzy_time_parse(time_str)
    return if time_str.nil?

    begin
      time = if time_str.length == 4 && time_str[/^\d\d\d\d/]
        Time.parse("#{time_str}-01-01")

      elsif time_str.length == 7 && time_str[/^\d\d\d\d-\d\d/]
        Time.parse("#{time_str}-01")

      else
        Time.parse(time_str)
      end

      "#{time.strftime("%Y-%m-%d")}T00:00:00Z"
    rescue
      nil
    end
  end

end
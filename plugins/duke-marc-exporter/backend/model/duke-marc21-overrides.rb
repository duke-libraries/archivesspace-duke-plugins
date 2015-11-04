class MARCModel < ASpaceExport::ExportModel
  model_for :marc21

  include JSONModel
#controlfield - replace u at position 18 with a for AACR2
  def self.from_resource(obj)
    marc = self.from_archival_object(obj)
    marc.apply_map(obj, @resource_map)
    marc.leader_string = "00000np$ a2200000 a 4500"
    marc.leader_string[7] = obj.level == 'item' ? 'm' : 'c'

    marc.controlfield_string = assemble_controlfield_string(obj)

    marc
  end


#Hard code OCLC code of NDD for 040 $a $e. Our OCLC code is different than repository code NcD stored in Aspace repo record
  def handle_repo_code(repository)
    repo = repository['_resolved']
    return false unless repo

    sfa = repo['org_code'] ? repo['org_code'] : "Repository: #{repo['repo_code']}"
#Remove 852 from mapping, may cause problems with auto-loading HOL record in Aleph/OLE import?
#    df('852', ' ', ' ').with_sfs(
#                        ['a', sfa],
#                        ['b', repo['name']]
#                      )
    df('040', ' ', ' ').with_sfs(['a', 'NDD'], ['c', 'NDD'])
  end

#Add 099 second indicator 9 for 'local scheme', remove 852 $c from export (see above)
  def handle_id(*ids)
    ids.reject!{|i| i.nil? || i.empty?}
    df('099', ' ', '9').with_sfs(['a', ids.join('.')])
#    df('852', ' ', ' ').with_sfs(['c', ids.join('.')])
  end

#Add comma after title in 245$a before dates in $f
  def handle_title(title)
    title_with_comma = "#{title}, "
    df('245', '1', '0').with_sfs(['a', title_with_comma])
  end

#Supply terminal period after dates in title
  def handle_dates(dates)
    return false if dates.empty?

    dates = [["single", "inclusive", "range"], ["bulk"]].map {|types| 
      dates.find {|date| types.include? date['date_type'] } 
    }.compact

    dates.each do |date|
      code = date['date_type'] == 'bulk' ? 'g' : 'f' 
      val = nil
      if date['expression'] && date['date_type'] != 'bulk' 
        val = date['expression']
      elsif date['date_type'] == 'single'
        val = date['begin']
      else
        val = "#{date['begin']} - #{date['end']}"
      end
#supply terminal period after dates
      df('245', '1', '0').with_sfs([code, "#{val}."])
    end
  end

#Modifications to Agents:remove "former owner" from export for linked agents wth role=source (to fix export of center names). No other changes.  
  def handle_agents(linked_agents)

    handle_primary_creator(linked_agents)

    subjects = linked_agents.select{|a| a['role'] == 'subject'}

    subjects.each_with_index do |link, i|
      subject = link['_resolved']
      name = subject['display_name']
      relator = link['relator']
      terms = link['terms']
      ind2 = source_to_code(name['source'])

      case subject['agent_type']

      when 'agent_corporate_entity'
        code = '610'
        ind1 = '2'
        sfs = [
                ['a', name['primary_name']],
                ['b', name['subordinate_name_1']],
                ['b', name['subordinate_name_2']],
                ['n', name['number']],
                ['g', name['qualifier']],
              ]

      when 'agent_person'
        joint, ind1 = name['name_order'] == 'direct' ? [' ', '0'] : [', ', '1']
        name_parts = [name['primary_name'], name['rest_of_name']].reject{|i| i.nil? || i.empty?}.join(joint)
        ind1 = name['name_order'] == 'direct' ? '0' : '1'
        code = '600'
        sfs = [
                ['a', name_parts],
                ['b', name['number']],
                ['c', %w(prefix title suffix).map {|prt| name[prt]}.compact.join(', ')],
                ['q', name['fuller_form']],
                ['d', name['dates']],
                ['g', name['qualifier']],
              ]

      when 'agent_family'
        code = '600'
        ind1 = '3'
        sfs = [
                ['a', name['family_name']],
                ['c', name['prefix']],
                ['d', name['dates']],
                ['g', name['qualifier']],
              ]

      end

      terms.each do |t|
        tag = case t['term_type']
          when 'uniform_title'; 't'
          when 'genre_form', 'style_period'; 'v'
          when 'topical', 'cultural_context'; 'x'
          when 'temporal'; 'y'
          when 'geographic'; 'z'
          end
        sfs << [(tag), t['term']]
      end

      if ind2 == '7'
        sfs << ['2', subject['source']]
      end

      df(code, ind1, ind2, i).with_sfs(*sfs)
    end


    creators = linked_agents.select{|a| a['role'] == 'creator'}[1..-1] || []
    creators = creators + linked_agents.select{|a| a['role'] == 'source'}

    creators.each do |link|
      creator = link['_resolved']
      name = creator['display_name']
      relator = link['relator']
      terms = link['terms']
      role = link['role']

      if relator
        relator_sf = ['4', relator]
      elsif role == 'source'
#Don't supply $e for linked agents with role=source
        #relator_sf =  ['e', 'former owner']
      else
        relator_sf = ['e', 'creator']
      end

      ind2 = ' '

      case creator['agent_type']

      when 'agent_corporate_entity'
        code = '710'
        ind1 = '2'
        sfs = [
                ['a', name['primary_name']],
                ['b', name['subordinate_name_1']],
                ['b', name['subordinate_name_2']],
                ['n', name['number']],
                ['g', name['qualifier']],
              ]

      when 'agent_person'
        joint, ind1 = name['name_order'] == 'direct' ? [' ', '0'] : [', ', '1']
        name_parts = [name['primary_name'], name['rest_of_name']].reject{|i| i.nil? || i.empty?}.join(joint)
        ind1 = name['name_order'] == 'direct' ? '0' : '1'
        code = '700'
        sfs = [
                ['a', name_parts],
                ['b', name['number']],
                ['c', %w(prefix title suffix).map {|prt| name[prt]}.compact.join(', ')],
                ['q', name['fuller_form']],
                ['d', name['dates']],
                ['g', name['qualifier']],
              ]

      when 'agent_family'
        ind1 = '3'
        code = '700'
        sfs = [
                ['a', name['family_name']],
                ['c', name['prefix']],
                ['d', name['dates']],
                ['g', name['qualifier']],
              ]
      end

      sfs << relator_sf
      df(code, ind1, ind2).with_sfs(*sfs)
    end

  end


#Remove scopecontent note from MARC 520 export; Remove processinfo and physloc from 500 mapping
  def handle_notes(notes)

    notes.each do |note|

      prefix =  case note['type']
                when 'dimensions'; "Dimensions"
                when 'physdesc'; "Physical Description note"
                #when 'prefercite'; "Preferred Citation"
                when 'materialspec'; "Material Specific Details"
                #when 'physloc'; "Location of resource"
                when 'phystech'; "Physical Characteristics / Technical Requirements"
                when 'physfacet'; "Physical Facet"
                #when 'processinfo'; "Processing Information"
                when 'separatedmaterial'; "Materials Separated from the Resource"
                else; nil
                end

      marc_args = case note['type']

                  when 'arrangement', 'fileplan'
                    ['351','b']
#Remove processinfo and physloc from 500 mapping, add altformavail (may need to clean in MARC)
                  when 'odd', 'dimensions', 'physdesc', 'materialspec', 'phystech', 'physfacet', 'separatedmaterial', 'altformavail'
                    ['500','a']
                  when 'accessrestrict'
                    ['506','a']
#Suppress full scopecontent from export
                  #when 'scopecontent'
                  #  ['520', '2', ' ', 'a']
                  when 'abstract'
                    ['520', '3', ' ', 'a']
#Prefercite incorrectly mapped to 534; changed to 524, suppress from export
                  #when 'prefercite'
                  #  ['524', '8', ' ', 'a']
                  when 'acqinfo'
                    ind1 = note['publish'] ? '1' : '0'
                    ['541', ind1, ' ', 'a']
#Suppress relatedmaterial from export - formatting is too complex in AS
                  #when 'relatedmaterial'
                  #  ['544','a']
                  when 'bioghist'
                    ['545','a']
                  when 'custodhist'
                    ind1 = note['publish'] ? '1' : '0'
                    ['561', ind1, ' ', 'a']
                  when 'appraisal'
                    ind1 = note['publish'] ? '1' : '0'
                    ['583', ind1, ' ', 'a']
                  when 'accruals'
                    ['584', 'a']
                  when 'altformavail'
                    ['535', '2', ' ', 'a']
                  #when 'originalsloc'
                  #  ['535', '1', ' ', 'a']
                  when 'userestrict', 'legalstatus'
                    ['540', 'a']
                  when 'langmaterial'
                    ['546', 'a']
                  else
                    nil
                  end

      unless marc_args.nil?
        text = prefix ? "#{prefix}: " : ""
        text += ASpaceExport::Utils.extract_note_text(note)
        df!(*marc_args[0...-1]).with_sfs([marc_args.last, *Array(text)])
      end

    end
  end
#end notes


#Change 'finding aid online: ' to 'Collection guide'. Change 856$z to $y. Remove 555 $u
  def handle_ead_loc(ead_loc)
    df('555', ' ', ' ').with_sfs(
                                  ['a', "Collection guide available online"]
                                  #['u', ead_loc]
                                )
    df('856', '4', '2').with_sfs(
                                  ['y', "Collection guide"],
                                  ['u', ead_loc]
                                )
  end


end

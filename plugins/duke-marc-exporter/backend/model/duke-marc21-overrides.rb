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


#Hard code OCLC code of NDD for 040 $a $e
  def handle_repo_code(repository)
    repo = repository['_resolved']
    return false unless repo

    sfa = repo['org_code'] ? repo['org_code'] : "Repository: #{repo['repo_code']}"
#Remove 852 from mapping, may cause problems wiht auto-loading HOL record in Aleph import?
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


#Remove scopecontent note from MARC 520 export; Remove processinfo and physloc from 500 mapping
  def handle_notes(notes)

    notes.each do |note|

      prefix =  case note['type']
                when 'dimensions'; "Dimensions"
                when 'physdesc'; "Physical Description note"
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
#Prefercite incorrectly mapped to 534; changed to 524
                  when 'prefercite'
                    ['524', '8', ' ', 'a']
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
#Remove altformavail and originals loc mapping (added to 500 instead). These fields are used just for location, no description of copies/originals 
                  #when 'altformavail'
                  #  ['535', '2', ' ', 'a']
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

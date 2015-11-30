require 'nokogiri'
require 'securerandom'

class EADSerializer < ASpaceExport::Serializer
  serializer_for :ead


    def serialize_digital_object(digital_object, xml, fragments)
    return if digital_object["publish"] === false && !@include_unpublished
    file_versions = digital_object['file_versions']
    title = digital_object['title']
    date = digital_object['dates'][0] || {}
    
    atts = digital_object["publish"] === false ? {:audience => 'internal'} : {}

    content = ""
    content << title if title
    content << ": " if date['expression'] || date['begin']
    if date['expression']
      content << date['expression']
    elsif date['begin']
      content << date['begin']
      if date['end'] != date['begin']
        content << "-#{date['end']}"
      end
    end
    atts['xlink:title'] = digital_object['title'] if digital_object['title']
    
    
    if file_versions.empty?
#A hack to put the digital object ID (typically an ARK) in the dao/@xpointer attribute
      atts['xpointer'] = digital_object['digital_object_id']
      atts['xlink:href'] = digital_object['digital_object_id']
      atts['xlink:actuate'] = 'onRequest'
      atts['xlink:show'] = 'new'
      xml.dao(atts) # REMOVE <daodesc> tagging-it's redundant {
#        xml.daodesc{ sanitize_mixed_content(content, xml, fragments, true) } if content
#      }
    else
      file_versions.each do |file_version|
#A hack to put the digital object ID (typically an ARK) in the dao/@xpointer attribute
		atts['xpointer'] = digital_object['digital_object_id']
		atts['xlink:href'] = file_version['file_uri'] || digital_object['digital_object_id']
        atts['xlink:actuate'] = file_version['xlink_actuate_attribute'] || 'onRequest'
        atts['xlink:show'] = file_version['xlink_show_attribute'] || 'new'
#Added below to serialize role attribute (use statement)
        atts['xlink:role'] = file_version['use_statement'] || 'undefined'
        xml.dao(atts) # REMOVE <daodesc> tagging-it's redundant {
#          xml.daodesc{ sanitize_mixed_content(content, xml, fragments, true) } if content
#        }
      end
    end
    
  end



end
# archivesspace-duke-plugins
Local plugins for customizing ArchivesSpace at Duke

Each plugin is a directory within the /plugins directory with the name of the plugin (e.g. aspace-search-identifier, lcnaf, local)

To install plugins:

   1. Stop the application
   2. Move the individual plugin directories into the archivesspace/plugins directory
   3. Overwrite the default config.rb file in archivesspace/config with this modified one
   4. Run /archivesspace/scipts/setup-database.sh
   5. Restart the application /archivesspace/archivesspace.sh

The plugins in this repo make the following changes:

- **archivesspace-delete-safety-plugin**: Modified display of Delete button in resource tree view to distinguish between deleting entire resource and archival object.  Plugin courtesy of Trevor Thorton (NCSU): https://github.com/trevorthornton/archivesspace-delete-safety-plugin
- **aspace-search-identifier**: Adds Identifier column to search result and browse screens
- **aspace-public-formats**: Exposes EAD, MARCXML, PDF, etc. through public interface.  Links available in sidebar.
- **duke-advanced-search**: Adds advanced search fields to index (including user-defined fields) and to drop-downs: Four-part-ID, Primary Collector, etc.
- **duke-ead-exporter**: customizes EAD exporter to supply dao/@xlink:role attribue in EAD based on value of File Version Use Statement (e.g. image-service, audio-streaming, etc.)
- **duke-export-option-defaults**: changes default options for exporting EAD in staff interface drop-down menu (include_unpublished=false, include_daos=true, numbered_cs=true)
- **user_defined_in_basic**: adds selected user_defined fields for accession records to the Basic Informaiton Tab of the accession record form and removes the user-defined fields section entirely. Requires modification of config.rb and /plugins/local/frontend/locales/en.yml.  See: https://github.com/hudmol/user_defined_in_basic
- **local**:
     - Adds branding (RL icon, welcome messages, etc)
     - Adds fields to advanced search drop-down (search_definitions.rb)
     - Changes labels and tooltips for user-defined fields and some collection management fields
     - Moves accession date facet to top (search_result_data.rb)
     - Adds translations for user defined list values
     - Relaxes date constraint from YYYY-MM-DD to YYYY. See: https://gist.github.com/cfitz/87ec5cfa2bcd5f347949
     - backend/model/solr.rb - changes default facet sort to alpha order instead of hit count order
     - changes default sort to 'modified descending' for resources and accessions: /local/frontend/controllers
- **config.rb**:
      - Changes default number of search results from 10 to 50
      - Activates plugins (line 127)
      - Specifies public-format links for various serializations (EAD, MARCXML, etc.)

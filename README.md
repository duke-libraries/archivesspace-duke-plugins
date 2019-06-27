# archivesspace-duke-plugins
Local plugins for customizing ArchivesSpace at Duke

Each plugin is a directory within the /plugins directory with the name of the plugin (e.g. aspace-search-identifier, lcnaf, local)

To install plugins:

   1. Stop the application
   2. Move the individual plugin directories into the archivesspace/plugins directory
   3. Modify config.rb (in archivesspace/config) to list plugins below, change search result limit from 10 to 20, and specify public-format-links
   4. Run /archivesspace/scipts/setup-database.sh
   5. Restart the application /archivesspace/archivesspace.sh

The plugins in this repo make the following changes:

- **archivesspace-delete-safety-plugin**: Modified display of Delete button in resource tree view to distinguish between deleting entire resource and archival object.  Plugin courtesy of Trevor Thorton (NCSU): https://github.com/trevorthornton/archivesspace-delete-safety-plugin
- **duke-advanced-search**: Adds advanced search fields to index (including user-defined fields) and to drop-downs: Four-part-ID, Primary Collector, etc. Must run setup-database.sh with each new upgrade. Modeled after: https://github.com/hudmol/extended_advanced_search
- **duke-ead-exporter**: customizes EAD exporter to export File Version Use Statement (e.g. image-service, audio-streaming, etc.) as dao/@xlink:role and digital object identifier (typically an ARK) as dao/@xlink:xpointer. Also removes redundant daodesc tags.
- **duke-marc-exporter**: customizes MARCXML exports to conform to local best practices at Duke. MARCXML records can be imported in OCLC Connexion, validated and further modified (control headings, adjust fixed fields, ect.). Some notes on modifications: https://docs.google.com/spreadsheets/d/1OcnmC-QJIlIv3uN--wr8we50EAxM_566xpj7Vd1wr2w/edit?usp=sharing
- **duke-export-option-defaults**: changes default options for exporting EAD in staff interface drop-down menu (include_unpublished=false, include_daos=true, numbered_cs=true)
- **user_defined_in_basic**: adds selected user_defined fields for accession records to the Basic Informaiton Tab of the accession record form and removes the user-defined fields section entirely. Requires modification of config.rb and /plugins/local/frontend/locales/en.yml.  See: https://github.com/hudmol/user_defined_in_basic
- **printcss**: modifies default print format to remove clutter (applicaton buttons, etc.). Ideal for printing 1-page accession records to attach to boxes on arrival. Developed by Mark Custer at Yale.
- **local**:
     - Adds branding (RL icon, welcome messages, etc)
     - Adds fields to advanced search drop-down (search_definitions.rb)
     - Changes labels and tooltips for user-defined fields and some collection management fields (en.yml)
     - Modifies facet labels in search/browse result pages (en.yml)
     - Moves accession date facet to top (search_result_data.rb)
     - Modifies accession record schema to add validation rules on record save (schemas/accession.rb)
     - Modified user_defined record schema to add validations rules on record save (schemas/user_defined.rb)
     - Adds translations for user defined list values (enums/en.yml)
     - Relaxes date constraint from YYYY-MM-DD to YYYY. See: https://gist.github.com/cfitz/87ec5cfa2bcd5f347949
     - changes default sort to 'created descending' for accessions and resources: /local/frontend/controllers
- **config_modifications.txt**:
      - Changes default number of search results from 10 to 20
      - Activates plugins
      - Sets user_defined_in_basic plugin configuration

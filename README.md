# archivesspace-duke-plugins
Local plugins for customizing ArchivesSpace at Duke

Each plugin is a directory within the /plugins directory with the name of the plugin (e.g. aspace-search-identifier, lcnaf, local)

To install plugins:


   1. Move the individual plugin directories into the archivesspace/plugins directory
   2. Overwrite the default config.rb file in archivesspace/config with this modified one
   3. Restart the application

The plugins in this repo make the following changes:

   *aspace-search-identifier: Adds Identifier column to search result and browse screens
   *local:
     *Adds branding (RL icon, welcome messages, etc)
     *Adds fields to advanced search drop-down
     *Changes labels for user-defined fields
     *Move accession date facet to top (search_result_data.rb)
     *Adds translations for user defined list values
   *config.rb:
      *Change default number of search results from 10 to 50
      *Activate plugins (line 127)

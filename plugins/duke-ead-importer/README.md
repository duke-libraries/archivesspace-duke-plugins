Duke EAD Importer plugin
=================

Modifies EAD importer to make all notes 'published' be default unless @audience='internal' in imported EAD

Usage
-----

1. Download the plugin to the archivesspace/plugins folder. 
2. Add the name of the plugin in `archivesspace/config/config.rb`:
```
AppConfig[:plugins] << "duke-ead-importer"
```
3. Restart ArchivesSpace.

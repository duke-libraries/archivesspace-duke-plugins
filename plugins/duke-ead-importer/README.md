Duke EAD Importer plugin
=================

Modifies EAD importer to make all notes 'published' be default unless @audience='internal' in imported EAD

Usage
-----

Download the plugin to the archivesspace/plugins folder. Add the name of the plugin in `config.rb`:
```
AppConfig[:plugins] << "duke-ead-importer"
```
Restart ArchivesSpace.
---

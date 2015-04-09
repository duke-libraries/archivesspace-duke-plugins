Search identifier
=================

Add an identifier column to search and advanced search results pages in the staff ui. Displays value for:

- Agents (authority id if defined)
- Accessions
- Archival Objects (component id if defined)
- Digital Objects
- Resources
- Subjects (authority id if defined)

Usage
-----

Download the plugin to the plugins folder. Add the plugin in `config.rb`:

```
AppConfig[:plugins] << "aspace-search-identifier"
```

Restart ArchivesSpace.

---

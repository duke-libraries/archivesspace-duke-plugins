Extended Reports 
===========

Add customized reports to ArchivesSpace

# Getting Started

Download the latest release from the Releases tab in Github:

  https://github.com/lcdhoffman/extended_reports/releases

Unzip the release and move it to:

    /path/to/archivesspace/plugins

Unzip it:

    $ cd /path/to/archivesspace/plugins
    $ unzip extended_reports.zip -d extended_reports

Enable the plugin by editing the file in `config/config.rb`:

    AppConfig[:plugins] = ['some_plugin', 'extended_reports']

(Make sure you uncomment this line (i.e., remove the leading '#' if present))

See also:

  https://github.com/archivesspace/archivesspace/blob/master/plugins/README.md




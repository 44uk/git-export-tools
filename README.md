Export Tools
====

Export files from git repository.



git-export-copy.rb
----

Export {SHA} fileset.

    $ git-export-copy.rb {SHA}
      -a {type}          # ARCHIVE FORMAT (zip, tar, tgz, tar.gz)
      -o {/path/to}      # OUTPUT DIRECTORY TARGET
      -f {format_string} # DIRECTORY NAME WITH FORMAT



git-export-diff.rb
----

Export diff files between {SHA1} and {SHA2}.

    $ git-export-diff.rb {SHA1} {SHA2}
      -a {type}          # ARCHIVE FORMAT (zip, tar, tgz, tar.gz)
      -o {/path/to}      # OUTPUT DIRECTORY TARGET
      -f {format_string} # DIRECTORY NAME WITH FORMAT



Specification
----

* If already exist directory or archive, attach suffix "-%03d".
* In the case set custom action(SourceTree), set $SHA to parameters.
* Load config from git-export-config.yml if exist in repository. (use sample)
* cli parameter overwrite git-export-config.yml parameters.



Configuration file
----

You can also set parameters above by *git-export-config.yml* exists in repository

use this sample:

    copy:
      archive: zip # or tar, tgz, tar.gz
      output: ../
      #format: "EXPORT-%y%m%d_%H%M"
    diff:
      archive: zip # or tar, tgz, tar.gz
      output: ../
      #format: "DIFF-%y%m%d_%H%M"




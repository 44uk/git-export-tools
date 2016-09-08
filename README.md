Export Tools
====

[![Join the chat at https://gitter.im/44uk/git-export-tools](https://badges.gitter.im/44uk/git-export-tools.svg)](https://gitter.im/44uk/git-export-tools?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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



git-export-deleted.rb
----

Export deleted file list between {SHA1} and {SHA2}.

    $ git-export-deleted.rb {SHA1} {SHA2}
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
    deleted:
      output: ../
      #format: "DELETED-%y%m%d_%H%M"



SourceTree for Windows users
----

Install ruby and git.

1. Install ruby for Windows [RubyInstaller for Windows](http://rubyinstaller.org/)
2. Install git for Windows [Git for Windows](http://msysgit.github.io/)
3. Set ruby and git in PATH.

### git-export-diff.rb

1. Set "ruby" to Script to run.
2. Set "{path/to/script.rb} -a zip $SHA" to Parameters

Unfortunately, *tar* doesn't work well on Windows. So *output* is limited zip format.


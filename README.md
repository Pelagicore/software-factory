
# Software Factory
PELUX Software Factory documentation

Software Factory is maintained at https://github.com/Pelagicore/software-factory

Maintainer: Joakim Gross <joakim.gross@pelagicore.com>


## Dependencies
* cmake
* Sphinx
* sphinxcontrib-seqdiag
* sphinxcontrib-blockdiag
* sphinxcontrib-actdiag
* sphinxcontrib-manpage
* sphinx\_rtd\_theme
* texlive-latex-base (when building PDF)
* texlive-latex-extra (when building PDF)
* texlive-latex-recommended (when building PDF)

###  Install build dependencies on Debian

``` bash
sudo apt-get install cmake python-pip
sudo pip install sphinxcontrib-seqdiag sphinxcontrib-blockdiag \
              sphinxcontrib-actdiag sphinxcontrib-manpage sphinx_rtd_theme
```


## Building
The project uses cmake to configure the build. Supported options are:

* `ENABLE_PDF` - Enables building the docs in PDF format. Set to OFF by default
* `PERFORM_SPELL_CHECK` - Performs a spell check on files. Set to ON by default

Check out the swf-blueprint submodule like so:
``` bash
    git submodule update --init
```

Configure and build from the git top dir like so:
``` bash
    cmake -H. -Bbuild
    cd build
    make
```

After a successfull build you can find the documentation in `build/docs/html/`
if you open the `index.html` in your browser you will see the entry point.

### Understanding Spell Check
A spell check is performed during the build step by default. It uses in-built
language specific dictionaries and project specific dictionaries (aspell.en.pws)
to verify the spellings and causes the build to fail in case of any typos.

The project, which uses this blueprint, should have its own custom dictionary,
similar to the one in blueprint (aspell.en.pws). Also a link to the
check_spelling.sh script in the repository should be created. The symlink to
check_spelling.sh and the project specific dictionary should be kept in the same
directory for the script to run correctly.

To build without spell check, configure cmake as below:

    cmake -H. -Bbuild -DPERFORM_SPELL_CHECK=OFF

To invoke the spell check utility directly, run the command below:

    ./check_spelling.sh

The spell checker has various modes and options, which can be seen by:

    ./check_spelling.sh --help

New words can be added to the dictionary by the script interface itself. Run
the script as below to view all typos and add one or all words:

    ./check_spelling.sh --all

The dictionary can also be modified manually, by adding words to the end of the
aspell.en.pws file.

# License and Copyright
Copyright (C) Pelagicore AB 2017

This work is licensed under the Creative Commons
Attribution-ShareAlike 4.0 International License. To view a copy of
this license, visit http://creativecommons.org/licenses/by-sa/4.0/ or
send a letter to Creative Commons, PO Box 1866, Mountain View, CA
94042, USA.

Code and scripts are licensed under LGPL 2.1

SPDX-License-Identifier: CC-BY-SA-4.0


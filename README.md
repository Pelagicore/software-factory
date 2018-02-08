
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
* sphinxcontrib-spelling
* sphinx\_rtd\_theme
* texlive-latex-base (when building PDF)
* texlive-latex-extra (when building PDF)
* texlive-latex-recommended (when building PDF)

###  Install build dependencies on Debian

``` bash
sudo apt-get install cmake python-pip
sudo pip install sphinxcontrib-seqdiag sphinxcontrib-blockdiag \
    sphinxcontrib-actdiag sphinxcontrib-manpage sphinxcontrib-spelling \
    sphinx_rtd_theme
```


## Building
The project uses cmake to configure the build. Supported options are:

* `ENABLE_PDF` - Enables building the docs in PDF format. Set to OFF by default

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
language specific dictionaries and project specific dictionaries
(spelling_wordlist.txt) to verify the spellings and causes the build to fail in
case of any typos.

The project, which uses this blueprint, should have its own custom dictionary,
similar to the one in blueprint (spelling_wordlist.txt). Currently, the
sphinxcontrib-spelling module does not support multiple wordlists, so one should
concatenate all wordlists to one specific list. In CMake, that can be done as
follows:

    add_custom_target(spelling
        find "${CMAKE_CURRENT_SOURCE_DIR}" -iname "${WORDLIST_FILE}" -type f | xargs cat > ${BINARY_BUILD_DIR}/${WORDLIST_FILE}
        COMMAND ${SPHINX_EXECUTABLE}
            -W -b spelling
            -c "${BINARY_BUILD_DIR}"
            -d "${SPHINX_CACHE_DIR}"
            "${CMAKE_CURRENT_SOURCE_DIR}"
            "${CMAKE_BINARY_DIR}/spelling"
        COMMENT "Spell-checking documentation with Sphinx"

`WORDLIST_FILE` is added to `conf.py` as the source for spelling, which the
sphinx spelling module then picks up.

The spell checker is added as a custom target, so to run it manually, simply
type (after running cmake):

    make spelling

To build the docs without checking the spelling, type:

    make sphinx-html

# License and Copyright
Copyright (C) Pelagicore AB 2017

This work is licensed under the Creative Commons
Attribution-ShareAlike 4.0 International License. To view a copy of
this license, visit http://creativecommons.org/licenses/by-sa/4.0/ or
send a letter to Creative Commons, PO Box 1866, Mountain View, CA
94042, USA.

Code and scripts are licensed under LGPL 2.1

SPDX-License-Identifier: CC-BY-SA-4.0


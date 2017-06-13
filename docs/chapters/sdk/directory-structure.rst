Source code repository directory structure
==========================================

In order to make it easier to navigate through new repositories they
should follow a common directory structure. The tree structure below
shows a repository with two components sharing a 'doc' directory and
'component-test' directory. Many repos will likely contain only one
component, in which case the structure should be the same but with only
one subdirectory with the source code etc.

.. code-block:: bash

    .
    ├── cmake_modules
    ├── component-A
    │   ├── include
    │   ├── src
    │   ├── unit-test
    │   │   ├── test-data
    ├── component-B
    │   ├── include
    │   ├── src
    │   ├── unit-test
    │   │   ├── test-data
    ├── component-test
    │   ├── test-data
    ├── doc
    │   ├── images
    │   │   └── *.png
    │   ├── design.md
    │   ├── mainpage.h
    ├── scripts
    ├── DEPENDENCIES
    ├── LICENSE
    └── README.md

The table below describes the directories and their purpose. The
<component-subdir> represents e.g. the 'component-A' or 'component-B'
directories in the tree structure above. Some directories are only
relevant in some situations, e.g. a 'test-data' dir is only relevant
if there is any actual test data of course.

====================================== ===========
Directory                              Description
====================================== ===========
scripts                                Contains e.g. utility scripts that might be needed to e.g. set up an environment or such like.
cmake_modules                          Contains any CMake 'find' modules.
doc                                    Contains doxygen files for generating reference documentation that is not part of any class
                                       etc, e.g. introductory pages and topic overviews. Contains design.md, describing the design
                                       of the component in an arc42 structure.
doc/images                             Contains images for the design and doxygen documentation.
                                       The preferred file format is png. If the image is generated from another document, it is
                                       recommended to keep that document here as well, e.g. a UML model.
component-test                         Contains tests and any stubs used in component tests.
component-test/test-data               Contains any test data that the component tests uses.
<component-subdir>/include             Contains any public header files, those that would typically be installed in a development package.
<component-subdir>/src                 Contains source and private header files.
<component-subdir>/unit-test           Contains unit tests and any stubs used in unit tests.
<component-subdir>/unit-test/test-data Contains any test data that the unit tests uses.
====================================== ===========

Mandatory files
---------------

Certain files should be found in every repository, those files are described below.

=============== ===========
File            Description
=============== ===========
README(.md)     A top-level README giving a brief introduction to the repository.
                How to build, how to run tests, other "good to know" information.
                The .md suffix for markdown syntax may be used.
LICENSE         The source code and project license.
DEPENDENCIES    Describes any non-trivial dependency used by a component.
                Typically a library linked against such as libfoo would be listed while a compiler and libstdc++ would not be listed.
CONTRIBUTING.md For OSS projects this file should exist and contain the following information:
                    * How and where to file bug reports and what information is expected in them.
                    * How the development flow works, for instance forks and merge requests.
                    * Brief about code standard
doc/mainpage.h  Introductory component documentation.
=============== ===========

Directory naming
----------------

All directories should be lower case only, and using "-" as a separator
between words. No other symbols other than [a..z], [0..9] and "-" are
allowed. Exceptions are allowed if there is a technical need which is
cumbersome to work around.

File naming
-----------

The source code and header files should be named using lower case letters
only, without any word separator. No other symbols other than [a..z] and
[0..9] are allowed. C++ source files should be suffixed ".cpp" and header
files ".h". The exception is test code files where an underscore is used
to separate the name of what is tested and a suffix showing that it is a
test, e.g. a unit with the name 'mymodule.cpp'/'mymodule.h' would have a
corresponding unit test implemented in a file named
'mymodule_unittest.cpp'.

.. note:: The repository meta data files such as the readme, license and makefiles are allowed to use upper case letters in their naming.
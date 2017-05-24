Prerequisites for building PELUX
================================

The following packages must be installed in order to build PELUX from source:

.. code-block:: bash

    git sed wget cvs subversion git-core coreutils unzip gawk python-pysqlite2
    diffstat help2man make gcc build-essential g++ chrpath libxml2-utils
    libsdl1.2-dev texinfo python3

Dependencies for Debian users
-----------------------------

On Debian-based systems, the following command can be used to install these dependencies:

.. code-block:: bash

    $ apt-get update
    $ apt-get install git sed wget cvs subversion git-core coreutils unzip gawk
    python-pysqlite2 diffstat help2man make gcc build-essential g++ chrpath
    libxml2-utils libsdl1.2-dev texinfo python3

In addition to these tools, the `repo` tool must also be installed, this is covered in :ref:`using-the-repo-tool`.

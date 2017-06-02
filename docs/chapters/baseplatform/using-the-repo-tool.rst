.. _using-the-repo-tool:

Using the repo tool
===================

The ``repo`` tool is used to obtain the sources of a PELUX release. ``repo`` was originally developed by the Android [#android]_ project, and it is used to clone specific versions of git repositories into specific locations.

Obtaining the repo tool
-----------------------

If you already have a directory in your ``$PATH`` for placing user-specific runnables, you should use that location; otherwise perform the following steps to add ``~/bin`` (or any directory of your choice) to your ``$PATH``:

.. literalinclude:: snippets/export.sh
    :language: bash

Note that you need to replace ``~/.bashrc`` with the correct rc-file for your shell.

Then download the repo tool binary to ``~/bin``:

.. literalinclude:: snippets/curl.sh
    :language: bash

The ``repo`` command should now be available from your shell.

.. [#android] http://source.android.com

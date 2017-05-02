# This file is part of the Software Factory project
# Copyright (C) Pelagicore AB
# SPDX-License_identifier: LGPL-2.1
# This file is subject to the terms of the LGPL-2.1 license.
# Please see the LICENSE file for details.

find_program(SPHINX_EXECUTABLE NAMES sphinx-build
    HINTS
    $ENV{SPHINX_DIR}
    PATH_SUFFIXES bin
    DOC "Sphinx documentation generator"
)

include(FindPackageHandleStandardArgs)
 
find_package_handle_standard_args(Sphinx DEFAULT_MSG
    SPHINX_EXECUTABLE
)

mark_as_advanced(SPHINX_EXECUTABLE)

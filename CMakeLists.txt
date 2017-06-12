# This file is part of the Software Factory project
# Copyright (C) Pelagicore AB
# SPDX-License_identifier: LGPL-2.1
# This file is subject to the terms of the LGPL-2.1 license.
# Please see the LICENSE file for details.

cmake_minimum_required(VERSION 3.0.2)

set(MAJOR_VERSION 0)
set(MINOR_VERSION 1)
set(PATCH_LEVEL 0)

# The VERSION variable is used in the Sphinx config when creating a
# version string.
set(VERSION ${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_LEVEL})

add_subdirectory(docs)


# This file is part of the Software Factory project
# Copyright (C) Pelagicore AB
# SPDX-License_identifier: LGPL-2.1
# This file is subject to the terms of the LGPL-2.1 license.
# Please see the LICENSE file for details.

cmake_minimum_required(VERSION 3.0.2)

find_program(git_binary git)
if(git_binary)
    execute_process(COMMAND ${git_binary} "rev-parse" "--short" "HEAD" OUTPUT_VARIABLE REVISION_RAW)
    string(REPLACE "\n" "" REVISION "${REVISION_RAW}")
else()
    set(REVISION "unknown")
endif()

string(TIMESTAMP DATE "%Y-%m-%d")

add_custom_target(doc ALL)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules)

find_package(Sphinx REQUIRED)

if(NOT DEFINED SPHINX_THEME)
    set(SPHINX_THEME default)
endif()

if(NOT DEFINED SPHINX_THEME_DIR)
    set(SPHINX_THEME_DIR)
endif()

# configured documentation tools and intermediate build results
set(BINARY_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/_build")

# Sphinx cache with pickled ReST documents
set(SPHINX_CACHE_DIR "${CMAKE_CURRENT_BINARY_DIR}/_doctrees")

# HTML output directory
set(SPHINX_HTML_DIR "${CMAKE_CURRENT_BINARY_DIR}/html")

# PDF output directory
set(SPHINX_PDF_DIR "${CMAKE_CURRENT_BINARY_DIR}/pdflatex")

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/conf.py.in"
    "${BINARY_BUILD_DIR}/conf.py"
    @ONLY)

add_custom_target(spelling
    ${SPHINX_EXECUTABLE}
        -W -b spelling
        -c "${BINARY_BUILD_DIR}"
        -d "${SPHINX_CACHE_DIR}"
        "${CMAKE_CURRENT_SOURCE_DIR}"
        "${CMAKE_BINARY_DIR}/spelling"
    COMMENT "Spell-checking documentation with Sphinx"
)

add_custom_target(sphinx-html
    ${SPHINX_EXECUTABLE}
        -q -W -b html
        -c "${BINARY_BUILD_DIR}"
        -d "${SPHINX_CACHE_DIR}"
        "${CMAKE_CURRENT_SOURCE_DIR}"
        "${SPHINX_HTML_DIR}"
    COMMENT "Building HTML documentation with Sphinx"
)

add_custom_target(sphinx-latexpdf
    ${SPHINX_EXECUTABLE}
        -q -b latex
        -c "${BINARY_BUILD_DIR}"
        -d "${SPHINX_CACHE_DIR}"
        "${CMAKE_CURRENT_SOURCE_DIR}"
        "${SPHINX_PDF_DIR}"
    COMMENT "Building Latex/PDF documentation with Sphinx")

add_dependencies(doc spelling sphinx-html)

option(ENABLE_PDF "Enable building documentation in PDF format" OFF)
if(ENABLE_PDF)
    add_dependencies(doc sphinx-latexpdf)
endif()


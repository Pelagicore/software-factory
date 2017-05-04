#!/bin/bash

# This file is part of the Software Factory project
# Copyright (C) Pelagicore AB
# SPDX-License_identifier: LGPL-2.1
# This file is subject to the terms of the LGPL-2.1 license.
# Please see the LICENSE file for details.

set -e

### Abort if the build is dirty
if [[ "`git diff --shortstat 2> /dev/null | tail -n1`" != "" ]]
then
    echo "Aborting publication of documentation due to the repository being 'dirty'"
    exit 1
fi

### Fetch the gh-pages branch and switch to it ###
git fetch origin gh-pages
git checkout -qf FETCH_HEAD
git checkout -f gh-pages || git checkout -bf gh-pages
git reset --hard FETCH_HEAD

### Setting git author ###
if [[ "`git config user.name`" == "" ]]
then
    git config user.email "noreply@pelagicore.com"
    git config user.name "Jenkins"
fi

### Moving docs to root directory and committing ###
DOCS_ROOT="."

cp -r build/docs/html/* "${DOCS_ROOT}"

rm -fr build

git add "${DOCS_ROOT}"
git commit -m "Built new docs on master"

### Pushing to github ###
git push origin gh-pages -f

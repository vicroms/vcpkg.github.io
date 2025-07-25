#!/bin/bash

set -e

cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")"
if [ ! -e ../vcpkg ]; then
    vcpkg_commit=$(cat commit.txt)
    if [ ! -e commit.txt ]; then exit 1; fi
    git init ../vcpkg
    git -C ../vcpkg fetch https://github.com/microsoft/vcpkg $vcpkg_commit
    git -C ../vcpkg checkout FETCH_HEAD
fi

npm ci
rm -rf ../en
node generateDocs.js
node generateGitHubStars.js ../vcpkg $1
node generatePackages.js ../vcpkg
node generateDetailedPages.js
node validateLinks.js


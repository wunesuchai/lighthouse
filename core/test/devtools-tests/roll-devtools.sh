#!/usr/bin/env bash

##
# @license Copyright 2020 The Lighthouse Authors. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
##

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LH_ROOT="$SCRIPT_DIR/../../.."

roll_devtools() {
  # Roll devtools. Besides giving DevTools the latest lighthouse source files,
  # this also copies over the e2e tests.
  cd "$LH_ROOT"
  yarn devtools "$DEVTOOLS_PATH"
  cd -
}

cd "$DEVTOOLS_PATH"
git --no-pager log -1
roll_devtools

# Needed to re-generate ninja rules, because there may possibly be e2e test files
# referenced in the rules initially generated by `download-devtools.sh` that
# `yarn devtools` deleted.
gclient sync --delete_unversioned_trees --reset

# Build devtools. This creates `out/Default/gen/front_end`.
autoninja -C out/Default
cd -

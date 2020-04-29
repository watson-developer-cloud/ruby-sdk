#!/bin/bash
#
# (C) Copyright IBM Corp. 2018, 2019.  All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#

# Apply patches to the generated code from the Ruby SDK generator.
#
# Usage:
#     ruby-sdk/scripts/ruby_tasks.sh <Path to generation directory>
#
# Example
#     bash ruby-sdk/scripts/ruby_tasks.sh "/Users/max/workspace/public/ruby-sdk/lib/ibm_watson"

cd ./ruby-sdk/scripts/ruby-tasks
rake patch[$1]
cd ./../../..

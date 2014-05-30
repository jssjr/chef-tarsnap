# Cookbook Name:: tarsnap
# Attributes:: tarsnapper
#
# Copyright 2011,2012, ZephirWorks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['tarsnapper']['retention']   = '1d 7d 30d 365d'
default['tarsnapper']['jobs'] =  Hash.new

default['tarsnapper']['cron']['setup'] = true
default['tarsnapper']['cron']['minute'] = 30
default['tarsnapper']['cron']['hour'] = 3

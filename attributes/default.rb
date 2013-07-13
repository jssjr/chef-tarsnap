# Author:: Scott Sanders (ssanders@taximagic.com)
# Copyright:: Copyright (c) 2013 RideCharge, Inc.
# License:: Apache License, Version 2.0
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


# source install options
default['tarsnap']['version'] = "1.0.34"
default['tarsnap']['sha256'] = "14c0172afac47f5f7cbc58e6442a27a0755685711f9d1cec4195c4f457053811"

# tarsnap options
default['tarsnap']['bin_path'] = '/usr/local/bin'
default['tarsnap']['cachedir'] = '/var/tarsnap/cache'
default['tarsnap']['data_bag'] = 'tarsnap_keys'
default['tarsnap']['key_path'] = '/root'
default['tarsnap']['key_file'] = 'tarsnap.key'

# change this to false if you want to omit the default rotation schedule
default['tarsnap']['use_default_schedule'] = true

# set crontab interval
default['tarsnap']['cron']['minute'] = "*/5"
default['tarsnap']['cron']['hour'] = "*"

# feather scheduler
default['tarsnap']['feather']['backup_args'] = "--one-file-system --checkpoint-bytes 104857600"
default['tarsnap']['feather']['max_runtime'] = "3600"

# feather install options
default['tarsnap']['feather']['repo_url'] = "git://github.com/danrue/feather.git"
default['tarsnap']['feather']['repo_rev'] = "master"
default['tarsnap']['feather']['key_path'] = "/root"

case node['platform']
when "freebsd"
  default['tarsnap']['conf_dir'] = '/usr/local/etc'
  default['tarsnap']['packages'] = [ 'py-yaml' ]
  default['tarsnap']['install_packages'] = [ ]
else
  default['tarsnap']['conf_dir'] = '/etc'
  default['tarsnap']['packages'] = [ 'python-yaml', 'gcc', 'make', 'libssl-dev', 'zlib1g-dev', 'e2fslibs-dev' ]
  default['tarsnap']['install_packages'] = [ 'gcc', 'make', 'libssl-dev', 'zlib1g-dev', 'e2fslibs-dev' ]
end

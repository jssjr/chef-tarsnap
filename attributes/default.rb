# Author:: Scott Sanders (scott@jssjr.com)
# Copyright:: Copyright (c) 2013 Scott Sanders
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
default['tarsnap']['url'] = 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.35.tgz'
default['tarsnap']['version'] = '1.0.35'
default['tarsnap']['sha256'] = '6c9f6756bc43bc225b842f7e3a0ec7204e0cf606e10559d27704e1cc33098c9a'

# Should we install tarsnapper?
default['tarsnap']['use_tarsnapper'] = true

# tarsnap options
default['tarsnap']['cachedir'] = '/var/tarsnap/cache'
default['tarsnap']['data_bag'] = 'tarsnap_keys'
default['tarsnap']['key_path'] = '/root'
default['tarsnap']['key_file'] = 'tarsnap.key'

# tarsnap.conf settings
default['tarsnap']['nodump'] = true
default['tarsnap']['print-stats'] = true
default['tarsnap']['checkpoint-bytes'] = '1G'
default['tarsnap']['aggressive-networking'] = false
default['tarsnap']['lowmem'] = false
default['tarsnap']['verylowmem'] = false

# change this to false if you want to omit the default rotation schedule
default['tarsnap']['use_default_schedule'] = true

case node['platform']
when 'freebsd'
  default['tarsnap']['conf_dir'] = '/usr/local/etc'
  default['tarsnap']['packages'] = ['py-yaml']
  default['tarsnap']['install_packages'] = []
when /ubuntu|debian/
  default['tarsnap']['conf_dir'] = '/etc'
  default['tarsnap']['packages'] = ['python-yaml']
  default['tarsnap']['install_packages'] = %w(gcc make libssl-dev zlib1g-dev e2fslibs-dev)
else
  default['tarsnap']['conf_dir'] = '/etc'
  default['tarsnap']['packages'] = ['PyYAML']
  default['tarsnap']['install_packages'] = %w(gcc make glibc-devel openssl-devel zlib-devel e2fsprogs-devel)
end

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

require 'chef/knife/tarnsnap/core'

class Chef
  class Knife
    class TarsnapKeyShow

      include Knife::Tarsnap::Core

      banner "knife tarsnap key show NODE (options)"

      def run
        unless name_args.size == 1
          ui.fatal "You must provide a node name"
          exit 1
        end

        n = name_args.first

        if lookup_key(n)
          existing_key = Chef::EncryptedDataBagItem.load('tarsnap_keys', canonicalize(n))
          ui.msg existing_key['key']
        end
      end

    end
  end
end


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

require 'chef/knife/tarsnap/core'

class Chef
  class Knife
    class TarsnapKeyFromFile < Knife

      include Knife::Tarsnap::Core

      banner "knife tarsnap key from file KEYFILE NODE (options)"

      def run
        unless name_args.size == 2
          ui.fatal "You must provide a key file and a node name"
          exit 1
        end

        k = name_args.first
        n = name_args.last
        cn = canonicalize(n)

        match = lookup_node(n)
        unless match.is_a? Chef::Node
          ui.fatal "#{n} is not a node. Skipping..."
          exit 1
        end

        if tarsnap_keys.include?(cn)
          existing_key = lookup_key(n)
          ui.warn "A key for #{n} already exists! Overwrite it with a new key?"
          ui.warn "The old key will be saved to #{ENV['HOME']}/tarsnap.#{n}.key.old"
          ui.confirm "Continue"

          IO.write("#{ENV['HOME']}/tarsnap.#{n}.key.old", existing_key['key'])
        end

        begin
          data = { "id" => cn, "node" => n, "key" => IO.read(k) }
          item = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data, Chef::EncryptedDataBagItem.load_secret(config[:secret_file]))
          data_bag = Chef::DataBagItem.new
          data_bag.data_bag("tarsnap_keys")
          data_bag.raw_data = item
          data_bag.save
          ui.info ui.color("Data bag created from file!", :green)
        rescue Exception => e
          ui.msg "Error: #{e}"
          ui.warn ui.color("Key creation failed!", :red)
          exit 1
        end 

      end

    end
  end
end

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
    class TarsnapKeyList

      include Knife::Tarsnap::Core

      banner "knife tarsnap key list (options)"

      def run

        query_nodes = Chef::Search::Query.new
        tarsnap_nodes = Array.new
        query_nodes.search(:node) do |n|
          node_item = {
            "node" => n['fqdn'],
            "key" => tarsnap_keys.include?(canonicalize(n['fqdn']))
          }
          tarsnap_nodes << node_item
        end

        ui.msg ui.color("Node (green nodes have valid keys)", :bold)
        tarsnap_nodes.each do |n|
          if n['key']
            ui.msg ui.color(n['node'], :green)
          else
            ui.msg ui.color(n['node'], :red)
          end
        end
      end

    end
  end
end

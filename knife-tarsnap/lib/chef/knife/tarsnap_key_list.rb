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
    class TarsnapKeyList < Knife

      include Knife::Tarsnap::Core

      banner "knife tarsnap key list (options)"

      def run

        ui.msg ui.color('status      node', :bold)

        tarsnap_nodes.each do |n|
          if n['key'] == 'pending'
            ui.msg "#{ui.color('pending     ', :orange)}#{n['node']}"
          elsif n['key']
            ui.msg "#{ui.color('registered  ', :green)}#{n['node']}"
          end
        end
      end

    end
  end
end

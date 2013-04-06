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

class Chef
  class Knife
    class Tarsnap
      module Core

        def self.included(includer)
          includer.class_eval do
            deps do
              require 'chef/knife'
              Chef::Knife.load_deps
            end
          end
        end

        def keygen_tool
          @_keygen_path || @_keygen_path = which('tarsnap-keygen')
        end

        def tarsnap_tool
          @_tarsnap_path || @_tarsnap_path = which('tarsnap')
        end

        def canonicalize(fqdn)
          fqdn.gsub(".","_")
        end

        def tarsnap_keys
          @_tarsnap_keys || @_tarsnap_keys = Chef::DataBag.load('tarsnap_keys').map { |k,v| k }
        end

        def lookup_node(fqdn)
          Shell::Extensions.extend_context_object(self)
          nodes.find("fqdn:#{fqdn}").first
        end

        def lookup_key(fqdn)
          Chef::EncryptedDataBagItem.load('tarsnap_keys', canonicalize(fqdn)) || nil
        end

        def which(binary)
          which_cmd = "which #{binary}"
          which_shell = Mixlib::ShellOut.new(which_cmd)
          which_shell.run_command
          unless which_shell.status.exitstatus == 0
            raise TarsnapNotFoundException, "Unable to locate the tarsnap tool (#{binary}). Is it installed and in your path?"
          end
          which_shell.stdout.chomp
        end

      end
    end
  end
end

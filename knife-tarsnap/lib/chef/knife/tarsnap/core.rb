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

        # :nodoc:
        # Would prefer to do this in a rational way, but can't be done b/c of
        # Mixlib::CLI's design :(
        def self.included(includer)
          includer.class_eval do

            deps do
              require 'chef/knife'
              require 'chef/shell/ext'
              Chef::Knife.load_deps
            end

            option :tarsnap_username,
              :short => "-A USERNAME",
              :long => "--tarsnap-username KEY",
              :description => "Your Tarsnap Username",
              :proc => Proc.new { |key| Chef::Config[:knife][:tarsnap_username] = key }

            option :tarsnap_password,
              :short => "-K SECRET",
              :long => "--tarsnap-password SECRET",
              :description => "Your Tarsnap Password",
              :proc => Proc.new { |key| Chef::Config[:knife][:tarsnap_password] = key }

            option :tarsnap_data_bag,
              :short => "-B BAG_NAME",
              :long => "--tarsnap-data-bag BAG_NAME",
              :description => "The data bag containing Tarsnap keys",
              :proc => Proc.new { |key| Chef::Config[:knife][:tarsnap_data_bag] = key },
              :default => "tarsnap_keys"

          end
        end

        # Convenience methods for options

        def tarsnap_username
          if Chef::Config[:knife][:tarsnap_username]
            Chef::Config[:knife][:tarsnap_username]
          else
            raise StandardError, "Please provide the tarsnap account username"
          end
        end

        def tarsnap_password
          if Chef::Config[:knife][:tarsnap_password].nil?
            Chef::Config[:knife][:tarsnap_password] = ui.ask('Tarsnap Password: ') { |q| q.echo = '*' }
          end
          Chef::Config[:knife][:tarsnap_password]
        end

        def tarsnap_data_bag
          Chef::Config[:knife][:tarsnap_data_bag] || config[:tarsnap_data_bag]
        end

        # Required tools

        def keygen_tool
          @_keygen_path || @_keygen_path = which('tarsnap-keygen')
        end

        def tarsnap_tool
          @_tarsnap_path || @_tarsnap_path = which('tarsnap')
        end

        # Helpers

        def canonicalize(fqdn)
          fqdn.gsub(".","_")
        end

        def tarsnap_keys
          @_tarsnap_keys || @_tarsnap_keys = Chef::DataBag.load(tarsnap_data_bag).map { |k,v| k }
        end

        def tarsnap_nodes
          @_tarsnap_nodes || @_tarsnap_nodes = find_tarsnap_nodes
        end

        def lookup_node(fqdn)
          Shell::Extensions.extend_context_object(self)
          nodes.find("fqdn:#{fqdn}").first
        end

        def lookup_key(fqdn)
          Chef::EncryptedDataBagItem.load(tarsnap_data_bag, canonicalize(fqdn)) || nil
        end

        private

        def which(binary)
          which_cmd = "which #{binary}"
          which_shell = Mixlib::ShellOut.new(which_cmd)
          which_shell.run_command
          unless which_shell.status.exitstatus == 0
            raise StandardError, "Unable to locate the tarsnap tool (#{binary}). Is it installed and in your path?"
          end
          which_shell.stdout.chomp
        end

        def find_tarsnap_nodes
          found_nodes = []
          query_nodes = Chef::Search::Query.new
          query_nodes.search(:node) do |n|
            if n['fqdn'] # skip unregistered nodes
              node_item = {
                "node" => n['fqdn'],
                "key" => tarsnap_keys.include?(canonicalize(n['fqdn']))
              }
              found_nodes << node_item
            end
          end
          found_nodes
        end

      end
    end
  end
end

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
    class TarsnapKeyCreate < Knife

      include Knife::Tarsnap::Core

      banner "knife tarsnap key create NODE (options)"

      def run
        unless name_args.size == 1
          ui.fatal "You must provide a node name"
          exit 1
        end

        n = name_args.last
        cn = canonicalize(n)
        tarsnap_password = ENV['TARSNAP_PASSWORD'] || nil

        match = lookup_node(n)
        unless match.is_a? Chef::Node
          ui.warn "#{n} is not a real node. Skipping..."
        end

        if tarsnap_keys.include?(cn)
          existing_key = lookup_key(n)
          ui.warn "A key for #{n} already exists! Overwrite it with a new key?"
          ui.warn "The old key will be saved to #{ENV['HOME']}/tarsnap.#{n}.key.old"
          ui.confirm "Continue"

          IO.write("#{ENV['HOME']}/tarsnap.#{n}.key.old", existing_key['key'])
        end

        begin
          tarsnap_password = ui.ask('Tarsnap Password: ') { |q| q.echo = '*' } if tarsnap_password.nil?

          ui.info "Generating key"
          keyfile = ::File.join('/tmp', "tarsnap-#{rand(36**8).to_s(36)}")
          keygen_cmd = "echo '#{tarsnap_password}' | #{keygen_tool} --keyfile #{keyfile} --user #{Chef::Config[:knife][:tarsnap_user]} --machine #{n}"
          keygen_shell = Mixlib::ShellOut.new(keygen_cmd)
          keygen_shell.run_command
          unless keygen_shell.stderr.empty?
            raise StandardError, "tarsnap-keygen error: #{keygen_shell.stderr}"
          end

          ui.info "Creating data bag tarsnap_keys/#{cn}"
          data = { "id" => cn, "node" => n, "key" => IO.read(keyfile) }
          item = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data, Chef::EncryptedDataBagItem.load_secret(config[:secret_file]))
          data_bag = Chef::DataBagItem.new
          data_bag.data_bag("tarsnap_keys")
          data_bag.raw_data = item
          data_bag.save
          ui.info "Data bag saved!"
        rescue Exception => e
          ui.warn "Tarsnap create key failed"
        ensure
          File.unlink(keyfile) if File.exists?(keyfile)
        end
      end

    end
  end
end



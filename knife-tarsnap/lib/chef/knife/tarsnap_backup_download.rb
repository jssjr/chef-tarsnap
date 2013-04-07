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
    class TarsnapBackupDownload < Knife

      include Knife::Tarsnap::Core

      banner "knife tarsnap backup download NODE ARCHIVE (options)"

      option :save_to,
        :short => "-S TARBALL",
        :long => "--save-to TARBALL",
        :description => "Retrieves the archive tarball into the specific file"

      def run

        if name_args.size == 2
          node_name = name_args[0]
          archive_name = name_args[1]
        else
          ui.fatal "Must provide only NODE and ARCHIVE."
          exit 1
        end

        tarball = config[:save_to] || File.join(Dir.pwd, "#{archive_name}.tar")

        bag = lookup_key(node_name)
        key = bag['key']

        if File.exists?(tarball)
          ui.warn "A file named #{tarball} already exists. Do you want to overwrite it?"
          ui.confirm "Overwrite"
        end

        Tempfile.open('tarsnap', '/tmp') do |f|
          f.write(key)
          f.close

          list_cmd = "#{tarsnap_tool} --keyfile #{f.path} -r -f #{archive_name} > #{tarball}"

          ui.msg "Downloading #{tarball}..."
          list_shell = Mixlib::ShellOut.new(list_cmd, :timeout => 604800)
          list_shell.run_command
          unless list_shell.status.exitstatus == 0
            raise StandardError, "tarsnap error: #{list_shell.stderr}"
          end
          ui.msg "#{tarball} saved."
        end
      end

    end
  end
end

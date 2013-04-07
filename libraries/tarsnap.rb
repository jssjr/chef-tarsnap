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


module TarsnapHelpers
  def unmash(mashed)
    # XXX: This might be the grossest thing I've ever written
    begin
      mashed.to_hash.map { |k,v| { k => v.to_a.map { |kk| kk = kk.to_hash } }}
    rescue NoMethodError => e
      nil
    end
  end

  def lookup_node_entry(entry_type, entry_name)
    begin
      node['tarsnap'][entry_type][entry_name]
    rescue NoMethodError => e
      nil
    end
  end

  def update_config_file
    template "#{node['tarsnap']['conf_dir']}/feather.yaml" do
      variables(
        :backups => unmash(node['tarsnap']['backups']),
        :schedules => unmash(node['tarsnap']['schedules'])
      )
      cookbook "tarsnap"
    end

    ruby_block "update_config_file" do
      block do
        Chef::Log.debug "Triggering feather.yaml update"
      end
      action :nothing
      notifies :create, resources(:template => "#{node['tarsnap']['conf_dir']}/feather.yaml"), :delayed
    end
  end
end

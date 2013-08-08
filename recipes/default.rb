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


class Chef::Resource::Template
  include TarsnapHelpers
end

# Ensure the data bag for keys is created
unless Chef::DataBag.list.key?(node['tarsnap']['data_bag'])
  Chef::Log.warn("You must create the keys data bag (#{node['tarsnap']['data_bag']}) first!")
end

# Install tarsnap
case node['platform']
when "freebsd"
  package "tarsnap" do
    action :install
  end
else
  unless FileTest.exists?(File.join(node['tarsnap']['bin_path'], "tarsnap"))

    require 'digest'

    node['tarsnap']['install_packages'].each do |pkg|
      package pkg do
        action :install
      end
    end

    remote_file "tarsnap" do
      path "#{Chef::Config[:file_cache_path]}/tarsnap.tgz"
      checksum node['tarsnap']['sha256']
      source "https://www.tarsnap.com/download/tarsnap-autoconf-#{node['tarsnap']['version']}.tgz"
    end

    execute "extract-tarsnap" do
      command "cd #{Chef::Config[:file_cache_path]} && tar zxvf tarsnap.tgz"
      creates "#{Chef::Config[:file_cache_path]}/tarsnap-autoconf-#{node['tarsnap']['version']}"
    end

    execute "install-tarsnap" do
      command "cd #{Chef::Config[:file_cache_path]}/tarsnap-autoconf-#{node['tarsnap']['version']} && ./configure && make install clean"
      only_if { Digest::SHA256.file(File.join(Chef::Config[:file_cache_path],'tarsnap.tgz')).hexdigest == node['tarsnap']['sha256'] }
    end

  end
end

# Create the local cache directory
directory node['tarsnap']['cachedir'] do
  owner "root"
  mode 0700
  recursive true
  action :create
end

# Setup the local copy of the key
tarsnap_key node['fqdn'] do
  data_bag node['tarsnap']['data_bag']
  key_path node['tarsnap']['key_path']
  key_file node['tarsnap']['key_file']
  action :create_if_missing
end

# Install feather
remote_file File.join(node['tarsnap']['bin_path'], 'feather') do
  source "https://github.com/danrue/feather/raw/master/feather"
  owner 'root'
  mode '0755'
end

node['tarsnap']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

template "#{node['tarsnap']['conf_dir']}/feather.yaml" do
  source "feather.yaml.erb"
  owner "root"
  mode "0644"
  action :create
  variables(
    :backups => unmash(node['tarsnap']['backups']),
    :schedules => unmash(node['tarsnap']['schedules'])
  )
end

template "#{node['tarsnap']['conf_dir']}/tarsnap.conf" do
  source "tarsnap.conf.erb"
  owner "root"
  mode "0644"
  action :create
end

cron "feather" do
  minute node['tarsnap']['cron']['minute']
  hour node['tarsnap']['cron']['hour']
  path "#{node['tarsnap']['bin_path']}:/usr/bin:/bin"
  command "#{node['tarsnap']['bin_path']}/feather #{node['tarsnap']['conf_dir']}/feather.yaml"
end

if node['tarsnap']['use_default_schedule']
  include_recipe "tarsnap::default_schedule"
end

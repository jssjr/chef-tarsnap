# Author:: Greg Fitzgerald (greg@gregf.org)
# Copyright:: Copyright (c) 2013 Scott Sanders
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

tarsnap_tar = filename_from_url node['tarsnap']['url']

case node['platform']
when 'freebsd'
  package 'tarsnap' do
    action :install
  end
else
  require 'digest'

  node['tarsnap']['install_packages'].each do |pkg|
    package pkg do
      action :install
    end
  end

  remote_file 'download tarsnap' do
    path "#{Chef::Config[:file_cache_path]}/#{tarsnap_tar}"
    checksum node['tarsnap']['sha256']
    source node['tarsnap']['url']
    mode "0644"
    notifies :run, "bash[extract_tarsnap]"
    only_if { ! ::File.exist?("#{Chef::Config[:file_cache_path]}/#{tarsnap_tar}") }
  end

  bash 'extract_tarsnap' do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    mkdir tarsnap-source
    tar -xf #{tarsnap_tar} -C tarsnap-source --strip-components=1
    EOH
    notifies :run, "bash[install_tarsnap]"
    action :nothing
  end

  bash 'install_tarsnap' do
    cwd "#{Chef::Config[:file_cache_path]}/tarsnap-source"
    code <<-EOH
      ./configure --prefix=/usr/local --sysconfdir=#{node['tarsnap']['conf_dir']} --localstatedir=/var
      make
      make install
    EOH
    only_if { Digest::SHA256.file(File.join(Chef::Config[:file_cache_path], tarsnap_tar)).hexdigest == node['tarsnap']['sha256'] }
    action :nothing
  end
end

# Create the local cache directory
directory node['tarsnap']['cachedir'] do
  owner 'root'
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

template "#{node['tarsnap']['conf_dir']}/tarsnap.conf" do
  source 'tarsnap.conf.erb'
  owner 'root'
  mode '0644'
  action :create
end

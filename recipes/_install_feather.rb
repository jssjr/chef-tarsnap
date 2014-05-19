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

feather_tar = filename_from_url node['tarsnap']['feather']['url']

node['tarsnap']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

remote_file 'download feather' do
  path "#{Chef::Config[:file_cache_path]}/#{feather_tar}"
  checksum node['tarsnap']['feather']['sha256']
  source node['tarsnap']['feather']['url']
  mode "0644"
  notifies :run, "bash[extract_feather]"
  only_if { ! ::File.exist?("#{Chef::Config[:file_cache_path]}/#{feather_tar}") }
end

bash 'extract_feather' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  mkdir feather-source
  tar -xf #{feather_tar} -C feather-source --strip-components=1
  EOH
  notifies :run, "bash[install_feather]"
  action :nothing
end

bash 'install_feather' do
  cwd "#{Chef::Config[:file_cache_path]}/feather-source"
  code <<-EOH
  install -o root -g staff -m 0755 feather /usr/local/bin
  EOH
  only_if { Digest::SHA256.file(File.join(Chef::Config[:file_cache_path], feather_tar)).hexdigest == node['tarsnap']['feather']['sha256'] }
  action :nothing
end

template "#{node['tarsnap']['conf_dir']}/feather.yaml" do
  source 'feather.yaml.erb'
  owner 'root'
  mode '0644'
  action :create
  variables(
    :backups => unmash(node['tarsnap']['backups']),
    :schedules => unmash(node['tarsnap']['schedules'])
  )
end

cron 'feather' do
  minute node['tarsnap']['cron']['minute']
  hour node['tarsnap']['cron']['hour']
  path "/bin:/usr/bin:/usr/local/bin"
  command "/usr/local/bin/feather #{node['tarsnap']['conf_dir']}/feather.yaml"
end

if node['tarsnap']['use_default_schedule']
  include_recipe 'tarsnap::_feather_schedule'
end

#
# Cookbook Name:: tarsnap
# Recipe:: tarsnapper
#
# Copyright 2011,2012, ZephirWorks
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
#

include_recipe 'python::package'
include_recipe 'python::pip'

node['tarsnapper']['packages'].each do |pkg|
  package pkg
end

python_pip 'tarsnapper' do
  package_name 'tarsnapper'
  action :install
  not_if { ::File.exist?('/usr/local/bin/tarsnapper') }
end

template 'tarsnapper.conf' do
  path "#{node['tarsnap']['conf_dir']}/tarsnapper.conf"
  source 'tarsnapper.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

cron 'tarsnapper' do
  path '$PATH:/usr/local/bin'
  %w(minute hour day month weekday).each do|time|
    send(time, node['tarsnapper']['cron'][time]) unless node['tarsnapper']['cron'][time].nil?
  end
  command "tarsnapper -c #{node['tarsnap']['conf_dir']}/tarsnapper.conf make"
  only_if { node['tarsnapper']['cron']['setup'] }
end

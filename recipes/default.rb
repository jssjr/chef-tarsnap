#
# Cookbook Name:: tarsnap
# Recipe:: default
#
# Copyright 2012, RideCharge, Inc.
#
# All rights reserved - Do Not Redistribute
#

class Chef::Resource::Template
  include TarsnapHelpers
end

# Ensure the data bag for keys is created
unless Chef::DataBag.list.key?(node['tarsnap']['data_bag'])
  new_databag = Chef::DataBag.new
  new_databag.name(node['tarsnap']['data_bag'])
  new_databag.save
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

cron "feather" do
  minute "*/5"
  path "#{node['tarsnap']['bin_path']}:/usr/bin:/bin"
  command "#{node['tarsnap']['bin_path']}/feather #{node['tarsnap']['conf_dir']}/feather.yaml"
end

if node['tarsnap']['use_default_schedule']
  include_recipe "tarsnap::default_schedule"
end

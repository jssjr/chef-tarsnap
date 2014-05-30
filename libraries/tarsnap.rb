# Author:: Scott Sanders (scott@jssjr.com)
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

module TarsnapHelpers
  def lookup_node_entry(entry_type, entry_name)
    node['tarsnapper'][entry_type][entry_name]
  rescue NoMethodError
    nil
  end

  def update_config_file
    begin
      tarsnapper_template = resource_collection.find(:template => "#{node['tarsnap']['conf_dir']}/tarsnapper.conf")
    rescue Chef::Exceptions::ResourceNotFound
      tarsnapper_template = template "#{node['tarsnap']['conf_dir']}/tarsnapper.conf" do
        cookbook 'tarsnap'
        action :nothing
      end
    end

    tarsnapper_template.notifies(:create, "template[#{node['tarsnap']['conf_dir']}/tarsnapper.conf]", :delayed)
  end
end

module DeepToHash
  # to_yaml does not work on the attribute because it is an attribute object
  # converting it to a hash does not work because all nested hashes continue
  # to be Mash objects, which breaks the serialization
  def deep_to_hash(mash = self)
    out_hash = {}
    mash.each do |key, val|
      if val.nil? || val.empty?
        next
      elsif val.is_a?(Hash)
        out_hash[key.to_s] = deep_to_hash(val)
      elsif val.is_a?(Array)
        out_hash[key.to_s] = val.to_a
      else
        out_hash[key.to_s] = val
      end
    end
    out_hash
  end

  module_function :deep_to_hash
end

def filename_from_url(uri)
  require 'pathname'
  require 'uri'
  Pathname.new(URI.parse(uri).path).basename.to_s
end

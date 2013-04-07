action :create do

  if new_resource.group.empty?
    key_group = value_for_platform(
      'freebsd' => { 'default' => 'wheel' },
      'default' => 'root'
    )
  else
    key_group = new_resource.group
  end

  id = new_resource.search_id

  begin
    key_item = Chef::EncryptedDataBagItem.load(new_resource.data_bag, canonicalize(id))
    # Write out the key locally
    file "#{new_resource.key_path}/#{new_resource.key_file}" do
      mode "0600"
      owner new_resource.owner
      group key_group
      content key_item['key']
    end
    # ...and destroy any pending data bag placeholder
    client = Chef::REST.new(Chef::Config[:chef_server_url])
    client.delete("data/#{node['tarsnap']['data_bag']}/__#{canonicalize(id)}")
  rescue Net::HTTPServerException => e
    # Register the node as pending
    data = { "id" => "__#{canonicalize(id)}", "node" => id }
    secret = Chef::EncryptedDataBagItem.load_secret(Chef::Config[:encrypted_data_bag_secret])
    item = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data, secret)
    data_bag = Chef::DataBagItem.new
    data_bag.data_bag(node['tarsnap']['data_bag'])
    data_bag.raw_data = item
    data_bag.save
  rescue Chef::Exceptions::ValidationFailed => e
    Chef::Log.warn("Unable to retrieve the tarsnap key from the data bag!!!")
  ensure
    new_resource.updated_by_last_action(true)
  end

end

def canonicalize(fqdn)
  fqdn.gsub('.', '_')
end

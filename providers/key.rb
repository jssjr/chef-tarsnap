action :create do

  if new_resource.group.empty?
    key_group = value_for_platform(
      'freebsd' => { 'default' => 'wheel' },
      'default' => 'root'
    )
  else
    key_group = new_resource.group
  end

  begin
    key_item = Chef::EncryptedDataBagItem.load(new_resource.data_bag, canonicalize_node(new_resource.search_id))

    if key_item.nil?
      # Register the node as pending
      data = { "id" => "__#{canonicalize(n)}", "node" => n) }
      item = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data, Chef::EncryptedDataBagItem.load_secret(config[:secret_file]))
      data_bag = Chef::DataBagItem.new
      data_bag.data_bag(tarsnap_data_bag)
      data_bag.raw_data = item
      data_bag.save
    else
      # Otherwise write out the key locally
      file "#{new_resource.key_path}/#{new_resource.key_file}" do
        cookbook new_resource.cookbook
        mode "0600"
        owner new_resource.owner
        group key_group
        contents key_item['key']
      end
      # ...and destroy any pending data bag placeholder
      Chef::DataBagItem.destroy(tarsnap_data_bag, "__#{canonicalize(n)}")
    end

    new_resource.updated_by_last_action(true)
  rescue Chef::Exceptions::ValidationFailed => e
    Chef::Log.warn("Unable to retrieve the tarsnap key from the data bag!!!")
  end

end

def canonicalize_node(fqdn)
  fqdn.gsub('.', '_')
end

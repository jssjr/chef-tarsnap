action :create do

  begin
    key_item = Chef::EncryptedDataBagItem.load(new_resource.data_bag, canonicalize_node(new_resource.search_id))

    if new_resource.group.empty?
      key_group = value_for_platform(
        'freebsd' => { 'default' => 'wheel' },
        'default' => 'root'
      )
    else
      key_group = new_resource.group
    end

    file "#{new_resource.key_path}/#{new_resource.key_file}" do
      cookbook new_resource.cookbook
      mode "0600"
      owner new_resource.owner
      group key_group
      contents key_item['key']
    end

    new_resource.updated_by_last_action(true)
  rescue Chef::Exceptions::ValidationFailed => e
    Chef::Log.warn("Unable to retrieve the tarsnap key from the data bag!!!")
  end

end

def canonicalize_node(fqdn)
  fqdn.gsub('.', '_')
end

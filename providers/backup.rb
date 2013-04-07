include TarsnapHelpers

action :create do

  needs_config_update = false

  backup_entry = [
    { "schedule" => new_resource.schedule },
    { "path" => [new_resource.path].flatten }
  ]
  backup_entry.push({"exclude" => new_resource.exclude}) if new_resource.exclude

  existing_entry = lookup_node_entry('backups', new_resource.name)

  if existing_entry.nil? || backup_entry != existing_entry
    node.set['tarsnap']['backups'][new_resource.name] = backup_entry
    new_resource.updated_by_last_action(true)
    node.save unless Chef::Config[:solo]
    update_config_file
  end

end

action :delete do
  node['tarsnap']['backups'].delete(new_resource.name)
  node.save unless Chef::Config[:solo]
  update_config_file
end

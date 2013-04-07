module TarsnapHelpers
  def unmash(mashed)
    # XXX: This might be the grossest thing I've ever written
    begin
      mashed.to_hash.map { |k,v| { k => v.to_a.map { |kk| kk = kk.to_hash } }}
    rescue NoMethodError => e
      nil
    end
  end

  def lookup_node_entry(entry_type, entry_name)
    begin
      node['tarsnap'][entry_type][entry_name]
    rescue NoMethodError => e
      nil
    end
  end

  def update_config_file
    template "#{node['tarsnap']['conf_dir']}/feather.yaml" do
      variables(
        :backups => unmash(node['tarsnap']['backups']),
        :schedules => unmash(node['tarsnap']['schedules'])
      )
      cookbook "tarsnap"
    end

    ruby_block "update_config_file" do
      block do
        Chef::Log.debug "Triggering feather.yaml update"
      end
      action :nothing
      notifies :create, resources(:template => "#{node['tarsnap']['conf_dir']}/feather.yaml"), :delayed
    end
  end
end

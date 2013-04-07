# source install options
default['tarsnap']['version'] = "1.0.33"
default['tarsnap']['sha256'] = "0c0d825a8c9695fc8d44c5d8c3cd17299c248377c9c7b91fdb49d73e54ae0b7d"

# tarsnap options
default['tarsnap']['bin_path'] = '/usr/local/bin'
default['tarsnap']['cachedir'] = '/var/tarsnap/cache'
default['tarsnap']['data_bag'] = 'tarsnap_keys'
default['tarsnap']['key_path'] = '/root'
default['tarsnap']['key_file'] = 'tarsnap.key'

# change this to false if you want to omit the default rotation schedule
default['tarsnap']['use_default_schedule'] = true

# feather scheduler
default['tarsnap']['feather']['backup_args'] = "--one-file-system --checkpoint-bytes 104857600"
default['tarsnap']['feather']['max_runtime'] = "3600"

# feather install options
default['tarsnap']['feather']['repo_url'] = "git://github.com/danrue/feather.git"
default['tarsnap']['feather']['repo_rev'] = "master"
default['tarsnap']['feather']['key_path'] = "/root"

case node['platform']
when "freebsd"
  default['tarsnap']['conf_dir'] = '/usr/local/etc'
  default['tarsnap']['packages'] = [ 'py-yaml' ]
  default['tarsnap']['install_packages'] = [ ]
else
  default['tarsnap']['conf_dir'] = '/etc'
  default['tarsnap']['packages'] = [ 'python-yaml', 'gcc', 'make', 'libssl-dev', 'zlib1g-dev', 'e2fslibs-dev' ]
  default['tarsnap']['install_packages'] = [ 'gcc', 'make', 'libssl-dev', 'zlib1g-dev', 'e2fslibs-dev' ]
end

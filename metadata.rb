name 'tarsnap'
maintainer 'Scott Sanders'
maintainer_email 'scott@jssjr.com'
license 'Apache 2.0'
description 'Knife plugin and Chef cookbook for managing tarsnap.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'

%w(freebsd ubuntu debian).each do |os|
  supports os
end

%w(python).each do |dep|
  depends dep
end

recipe 'default', 'Installs and configures tarsnap'
recipe 'default_schedule', 'Installs a default feather schedule'

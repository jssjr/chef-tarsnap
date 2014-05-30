include_recipe 'tarsnap'

tarsnap_backup 'etc' do
  sources '/etc'
end

tarsnap_backup 'var' do
  sources ['/var/spool', '/var/log']
  target '/custom-target-$date.zip'
  excludes '/var/log/dmesg'
  deltas '1h 6h 1d 7d 24d 180d'
end

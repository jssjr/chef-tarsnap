require 'spec_helper'

describe file('/usr/local/bin/tarsnap') do
  it { should be_file }
  it { should be_mode '755' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into'staff' }
end

describe file('/usr/local/bin/tarsnapper') do
  it { should be_file }
  it { should be_mode '755' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into'staff' }
end

describe file('/var/tarsnap/cache') do
  it { should be_directory }
  it { should be_mode '700' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into'root' }
end

describe file('/etc/tarsnap.conf') do
  it { should be_file }
  it { should be_mode '644' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should contain '####
#### Managed by Chef
####

### Recommended options

# Tarsnap cache directory
cachedir /var/tarsnap/cache

# Tarsnap key file
keyfile /root/tarsnap.key'}
end

describe file('/etc/tarsnapper.conf') do
  it { should be_file }
  it { should be_mode '644' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should contain 'deltas: 1d 7d 30d 365d
target: $name-$date

jobs:
  etc:
    sources: /etc
  var:
    sources:
    - /var/spool
    - /var/log
    deltas: 1h 6h 1d 7d 24d 180d
    target: /custom-target-$date.zip'}
end

describe cron do
  it { should have_entry '30 3 * * * tarsnapper -c /etc/tarsnapper.conf make' }
end

describe command('tarsnap --version') do
  it { should return_stdout /tarsnap \d+.\d+.\d+/ }
end

describe command('tarsnapper -h') do
  it { should return_stdout /usage: tarsnapper/ }
end

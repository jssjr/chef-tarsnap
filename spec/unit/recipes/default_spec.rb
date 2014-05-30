require 'spec_helper'

describe 'tarsnap::default' do
  cached(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs tarsnap' do
    expect(chef_run).to include_recipe('tarsnap::_install_tarsnap')
  end

  it 'installs tarsnapper' do
    expect(chef_run).to include_recipe('tarsnap::_install_tarsnapper')
  end
end

describe 'tarsnap::_install_tarsnap' do
  cached(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  cached(:tarsnap) { chef_run.node['tarsnap'] }
  cached(:tarsnap_tar) { 'tarsnap-autoconf-1.0.35.tgz' }
  cached(:remote_file) { chef_run.remote_file("#{Chef::Config[:file_cache_path]}/#{tarsnap_tar}") }

  it 'should install build pre req packages' do
    tarsnap['install_packages'].each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end

  it 'fetches the tarsnap archive' do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/#{tarsnap_tar}").with(owner: 'root', mode: 0644)
    expect(remote_file).to notify('bash[extract_tarsnap]')
  end

  it 'extracts the tarsnap tar file' do
    pending('chefspec only supports action run for bash')
  end

  # No way to do run_bash with action nothing
  it 'installs tarsnap from source' do
    pending('chefspec only supports action run for bash')
  end

  it 'creates the tarsnap key' do
    pending('chefspec only supports action run for bash')
  end

  it 'creates the tarsnap cache directory' do
    expect(chef_run).to create_directory(tarsnap['cachedir']).with(
      user: 'root',
      group: 'root',
      mode: 0700
    )
  end

  it 'should create a tarsnap key' do
    expect(chef_run).to create_if_missing_tarsnap_key('chefspec.local')
  end

  it 'renders the tarsnap template' do
    expect(chef_run).to create_template('/etc/tarsnap.conf').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
  end

end

describe 'tarsnap::_install_tarsnapper' do
  cached(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  cached(:tarsnapper) { chef_run.node['tarsnapper'] }

  it 'should install tarsnapper pre req packages' do
    tarsnapper['packages'].each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end

  it 'renders the tarsnapper template' do
    expect(chef_run).to create_template('/etc/tarsnapper.conf').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
  end

  it 'creates a cron with attributes' do
    expect(chef_run).to create_cron('tarsnapper').with(minute: '30', hour: '3')
  end
end



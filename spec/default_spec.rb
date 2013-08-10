require 'chefspec'

describe 'tarsnap::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'tarsnap::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end

# Chef Tarsnap

Provides a chef cookbook with LWRP's to directory snapshots and maintain retention schedules. Includes a knife plugin for managing tarsnap keys, listing backups, and restoring files.

## Installation

### Cookbook Installation

Install the cookbook using knife:

    $ knife cookbook install tarsnap

Or install the cookbook from github:

    $ git clone git://github.com/jssjr/chef-tarsnap.git cookbooks/tarsnap
    $ rm -rf cookbooks/tarsnap/.git

Or use the [knife-github-cookbooks](https://github.com/websterclay/knife-github-cookbooks) plugin:

    $ knife cookbook github install jssjr/chef-tarsnap

### Knife Plugin Installation

Add this line to your application's Gemfile:

    gem 'knife-tarsnap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knife-tarsnap

Alternatively, and add this line to your application's Gemfile:

    gem 'chef-tarsnap', :path => 'cookbooks/tarsnap/knife-plugin'

And then execute:

    $ bundle

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Author:: Scott Sanders (ssanders@taximagic.com)

Copyright:: Copyright (c) 2013 RideCharge, Inc.

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

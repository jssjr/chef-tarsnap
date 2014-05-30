## v0.2.0 (Unreleased)

* *Breaking* Feather was swapped out for [tarsnapper](https://github.com/miracle2k/tarsnapper.git) See migration instructions.
* *Breaking* Some attributes changes please refer to [default/attributes](https://github.com/jssjr/chef-tarsnap/blob/master/attributes/default.rb)
* Recipes are now split up
* Installing tarsnapper can be disabled by setting node['tarsnap']['use_tarsnapper'] to false.
* Refactored how we install tarsnap
* Lots of chefspecs & custom matchers
* More options for tarsnap.conf

## v0.1.7

* [PR #10] - Upgrade path [Greg Fitzgerald]

## v0.1.6

* [PR #9] - Travis integration. Chefspec tests. Bug fixes. [Scott Sanders]
* [PR #7] - Add test-kitchen support [Greg Fitzgerald]

## v0.1.5

* [PR #8] - Refactor how pending keys are handled [Scott Sanders]

## v0.1.4

* [PR #6] - Update to tarsnap v1.0.34 [Greg Fitzgerald]

## v0.1.3

* [PR #5] - Manage tarsnap.conf [Greg Fitzgerald]

## v0.1.2

* [PR #4] - Make feather cron schedule configuratble through attributes. Credit to Greg Fitzgerald. Thanks!

## v0.1.1

* [Issue #1] - Add the `knife tarsnap key export` command for taking local backups of key data.


## v0.1.0

* Initial release

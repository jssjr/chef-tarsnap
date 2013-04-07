def initialize(*args)
  super
  @action = :create
end

actions :create, :delete

attribute :backup, :kind_of => String, :name_attribute => true

attribute :schedule, :kind_of => String
attribute :path, :kind_of => [Array,String]
attribute :exclude, :kind_of => [Array,String]

attribute :cookbook, :kind_of => String, :default => "tarsnap"

def initialize(*args)
  super
  @action = :create
end

actions :create, :delete

attribute :schedule, :kind_of => String, :name_attribute => true

attribute :period, :kind_of => Integer
attribute :always_keep, :kind_of => Integer
attribute :after, :kind_of => String
attribute :before, :kind_of => String
attribute :implies, :kind_of => String

attribute :cookbook, :kind_of => String, :default => "tarsnap"

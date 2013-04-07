def initialize(*args)
  super
  @action = :create
end

actions :create, :create_if_missing

attribute :data_bag, :kind_of => String, :default => "tarsnap_keys"
attribute :search_id, :kind_of => String, :name_attribute => true

attribute :key_path, :kind_of => String, :default => "/root"
attribute :key_file, :kind_of => String, :default => "tarsnap.key"

attribute :owner, :kind_of => String, :default => "root"
attribute :group, :kind_of => String, :default => ""  # will be selected in the provider

attribute :cookbook, :kind_of => String, :default => "tarsnap"

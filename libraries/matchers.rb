if defined?(ChefSpec)
  def create_tarsnap_schedule(options)
    ChefSpec::Matchers::ResourceMatcher.new(:tarsnap_schedule, :create, options)
  end

  def delete_tarsnap_schedule(options)
    ChefSpec::Matchers::ResourceMatcher.new(:tarsnap_schedule, :delete, options)
  end

  def create_tarsnap_key(options)
    ChefSpec::Matchers::ResourceMatcher.new(:tarsnap_key, :create, options)
  end

  def create_if_missing_tarsnap_key(options)
    ChefSpec::Matchers::ResourceMatcher.new(:tarsnap_key, :create_if_missing, options)
  end
end

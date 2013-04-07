include_recipe "tarsnap"

tarsnap_schedule "monthly" do
  period 2592000 # 30 days
  always_keep 12
  before "0600"
end

tarsnap_schedule "weekly" do
  period 604800 # 7 days
  always_keep 6
  after "0200"
  before "0600"
  implies "monthly"
end

tarsnap_schedule "daily" do
  period 86400 # 1 day
  always_keep 14
  after "0200"
  before "0600"
  implies "weekly"
end

tarsnap_schedule "hourly" do
  period 3600 # 1 hour
  always_keep 24
  implies "daily"
end

tarsnap_schedule "realtime" do
  period 900 # 15 minutes
  always_keep 10
  implies "hourly"
end

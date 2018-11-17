schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

require 'sidekiq'

url = ''
url = if ENV['REDISCLOUD_URL']
        ENV['REDISCLOUD_URL']
      elsif ENV['REDISTOGO_URL']
        ENV['REDISTOGO_URL']
      elsif ENV['REDIS_URL']
        ENV['REDIS_URL']
      else
        "redis://#{ENV.fetch('REDIS_1_PORT_6379_TCP_ADDR', '127.0.0.1')}:6379"
      end
puts url.to_s
Sidekiq.configure_server do |config|
  config.redis = { size: 12, url: url }
end

Sidekiq.configure_client do |config|
  config.redis = { size: 1, url: url }
end

Sidekiq.default_worker_options = { 'backtrace' => true }

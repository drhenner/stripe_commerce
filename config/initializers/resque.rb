Hadean::Application.config.after_initialize do
  Resque.redis = $redis
  Resque.redis.namespace = 'resque:rore'
end

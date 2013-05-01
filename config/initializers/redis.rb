$redis = Redis.connect(url: (YAML.load(ERB.new(Rails.root.join("config", "redis.yml").read).result) rescue {})[Rails.env])

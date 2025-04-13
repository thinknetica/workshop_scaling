$redis = ConnectionPool.new(size: 5, timeout: 3) do
  Redis.new(host: $current_ip)
end

Rails.application.config.after_initialize do
  registry = Prometheus::Client.registry

  listener_messages_count = registry.counter(:listener_messages_count, docstring: 'Redis Listener processed messages',
                                                                       labels: %i[job])
  ActiveSupport::Notifications.subscribe('redis_listener.message') do |event|
    labels = { job: event.payload[:job_class].to_s }
    listener_messages_count.increment(by: 1, labels: labels)
  end
end

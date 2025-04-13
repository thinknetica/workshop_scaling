Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{$current_ip}:6379/0" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{$current_ip}:6379/0" }
end

Rails.application.config.after_initialize do
  registry = Prometheus::Client.registry

  active_job_total_counter = registry.counter(:active_job_total_counter, docstring: 'Total ActiveJob jobs',
                                                                         labels: %i[adapter class])
  ActiveSupport::Notifications.subscribe('perform.active_job') do |event|
    labels = {
      adapter: event.payload[:adapter].class.to_s,
      class: event.payload[:job].class
    }
    active_job_total_counter.increment(by: 1, labels: labels)
  end
end

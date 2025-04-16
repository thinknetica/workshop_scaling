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

  # My metrics
  raw_data_count = registry.counter(:raw_data_count, docstring: 'Total number of raw data_files')
  ActiveSupport::Notifications.subscribe('metrics.raw_data_counter') do |event|
    raw_data_count.increment(by: 1)
  end

  processed_data_count = registry.counter(:processed_data_count, docstring: 'Total number of processed data_files')
  ActiveSupport::Notifications.subscribe('metrics.processed_data_counter') do |event|
    processed_data_count.increment(by: 1)
  end

  deleted_data_count = registry.counter(:deleted_data_count, docstring: 'Total number of deleted data_files', labels: %i[source])
  ActiveSupport::Notifications.subscribe('metrics.deleted_data_counter') do |event|
    count = event.payload[:count] || 1
    deleted_data_count.increment(by: count, labels: { source: 'data_deleted' })
  end
end

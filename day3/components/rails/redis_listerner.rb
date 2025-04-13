#!/usr/bin/env ruby

Rails.logger.info 'Run Redis listener'

$redis = Redis.new(host: $current_ip)

@pidfile = ENV.fetch('PIDFILE', '/tmp/jobs.pid')
File.write(@pidfile, Process.pid)

$redis.subscribe('think_tasks') do |on|
  ActiveSupport::Notifications.instrument('local.start_metrics')

  on.message do |channel, message|
    ActiveSupport::Notifications.instrument('redis_listener.message') do |payload|
      klass, *args = message.split(':')
      payload[:job_class] = klass
      job_klass = klass.constantize
      job_klass.perform_later(*args)
    end
  rescue StandardError => e
    Rails.logger.error "Unable to process message[#{e.inspect}]: channel=#{channel} message=#{message.inspect}"
  end

end

ActiveSupport::Notifications.instrument('local.stop_metrics')
FileUtils.rm(@pidfile, force: true)

# class DelayedJobStartedPlugin
#   def initialize(*_args, **_kwargs)
#     @pidfile = ENV.fetch('PIDFILE', '/tmp/jobs.pid')
#   end

#   def new(lifecycle = Delayed::Worker.lifecycle, *_args)
#     configure_lifecycle(lifecycle)
#   end

#   def configure_lifecycle(lifecycle)
#     lifecycle.around(:execute) do |_worker, *_args, &block|
#       ActiveSupport::Notifications.instrument('local.start_metrics')

#       File.write(@pidfile, Process.pid)

#       block.call
#     ensure
#       ActiveSupport::Notifications.instrument('local.stop_metrics')

#       FileUtils.rm(@pidfile, force: true)
#     end
#   end
# end

# Delayed::Worker.plugins << DelayedJobStartedPlugin.new

# Delayed::Worker.new(queues: [ENV.fetch('QUEUE', 'default')], logger: Rails.logger).start

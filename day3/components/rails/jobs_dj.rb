#!/usr/bin/env ruby

Rails.logger.info 'Run jobs(Delayed Jobs)'

class DelayedJobStartedPlugin
  def initialize(*_args, **_kwargs)
    @pidfile = ENV.fetch('PIDFILE', '/tmp/jobs.pid')
  end

  def new(lifecycle = Delayed::Worker.lifecycle, *_args)
    configure_lifecycle(lifecycle)
  end

  def configure_lifecycle(lifecycle)
    lifecycle.around(:execute) do |_worker, *_args, &block|
      ActiveSupport::Notifications.instrument('local.start_metrics')

      File.write(@pidfile, Process.pid)

      block.call
    ensure
      ActiveSupport::Notifications.instrument('local.stop_metrics')

      FileUtils.rm(@pidfile, force: true)
    end
  end
end

Delayed::Worker.plugins << DelayedJobStartedPlugin.new

Delayed::Worker.new(queues: [ENV.fetch('QUEUE', 'default')], logger: Rails.logger).start

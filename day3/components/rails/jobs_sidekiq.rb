#!/usr/bin/env ruby

require 'sidekiq/cli'

Rails.logger.info 'Run jobs(sidekiq)'

Sidekiq.configure_server do |config|
  config[:lifecycle_events][:startup] << proc do |*_args|
    @pidfile = ENV.fetch('PIDFILE', '/tmp/sidekiq.pid')
    ActiveSupport::Notifications.instrument('local.start_metrics')
    File.write(@pidfile, Process.pid)
  end

  config[:lifecycle_events][:shutdown] << proc do |*_args|
    ActiveSupport::Notifications.instrument('local.stop_metrics')
    FileUtils.rm(@pidfile, force: true)
  end
end

cli = Sidekiq::CLI.instance
cli.parse
cli.run

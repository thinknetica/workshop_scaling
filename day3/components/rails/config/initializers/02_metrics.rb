require 'webrick'
require 'rack'
require 'prometheus/middleware/exporter'

class WebServer
  attr_reader :thread

  # 404 error web server handler
  NOT_FOUND_HANDLER = proc { |_env| [404, {}, ['Not found']] }

  def initialize
    @started = false
    @thread = nil
  end

  # Stop web server
  def stop
    if @started
      Rack::Handler::WEBrick.shutdown
      @thread.join(0.1)
      @thread.kill
      @thread = nil
    end
    @started = false
  end

  def start(host: '0.0.0.0', port: '42424', path: DEFAULT_PATH, log_requests: true, logger: nil)
    raise 'Web Server Already Started' if @started

    logger&.info('Start web server for prometheus scrape')
    @thread = ::Thread.new(Thread.current.name) do |parent_name|
      Thread.current.name = "#{parent_name}-metrics-http" if parent_name

      Rack::Handler::WEBrick.run(
        rack_app(log_requests: log_requests),
        Host: host,
        Port: port,
        AccessLog: [],
        Logger: logger
      )
    end
    @started = true
  end

  protected

  def rack_app(log_requests: true)
    Rack::Builder.new do
      use Rack::Deflater
      use Rack::CommonLogger if log_requests
      use Rack::ShowExceptions
      use ::Prometheus::Middleware::Exporter, path: '/metrics', registry: Prometheus::Client.registry
      run NOT_FOUND_HANDLER
    end
  end
end

ActiveSupport::Notifications.subscribe('local.start_metrics') do |_event|
  server = ::WebServer.new
  server.start(port: ENV.fetch('PROMETHEUS_PORT', 3001), path: 'metrics', log_requests: false)

  ActiveSupport::Notifications.subscribe('local.stop_metrics') do |_event|
    server.stop
  end
end

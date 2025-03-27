require 'json'
require 'logger'
require 'thread'

require 'active_support/all'
require 'awesome_print'

require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

# LogHelper
class LogHelper < ::Logger
  def initialize(*args, **kwargs)
    $stdout.sync
    $stderr.sync
    super($stdout, *args, **kwargs)
  end

  def exception(message, e)
    error "#{message}: #{e.inspect}"
    error "Backtrace: #{e.backtrace}"
  end
end

$logger = ActiveSupport::TaggedLogging.new(LogHelper.new($stdout)).tagged("PID:#{Process.pid}")

SUCCESS_RESPONSE = [
  'HTTP/1.1 200 OK',
  'Connection: Keep-Alive',
  'Content-Type: application/json',
  '',
  ''
].join("\r\n").freeze

# puma -t 1:1 -p 3000
# passenger start --max-pool-size 1
# thin start --threaded --threadpool-size 2
class Application
  def initialize(*args)
    puts args.inspect
  end

  def call(env)
    request = Rack::Request.new(env)
    url = URI.parse(request.url)

    action, *args = url.path.gsub('//', '/').split('/').select(&:present?)
    if action.nil? || action.empty? || action == 'favicon.ico'
      # logger.info 'Empty action. Skip'
      [200, {}, ['{}']]
    else
      logger.info "Processing #{action.inspect} with #{args.inspect}..."
      send(action, request, *args)
    end
  rescue StandardError => e
    logger.exception('Server error:', e)
    [500, {}, [render_string("Error: #{e.inspect}")]]
  end

  def sync_sleep(_request, seconds, *_args)
    sleep(seconds.to_f)
    [200, {}, [render_string("sleeping for #{seconds.to_f}")]]
  end

  private

  def render_string(msg)
    "#{ENV['HOSTNAME']}[#{Process.pid}] #{Time.now}:#{msg}"
  end

  def logger
    $logger
  end

  def server(request)
    if request.env['SERVER_SOFTWARE']&.downcase&.[]('thin')
      :thin
    elsif request.env['SERVER_SOFTWARE']['puma']
      :puma
    elsif request.env['SERVER_SOFTWARE']['Passenger']
      :passenger
    else
      :other
    end
  end
end

use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

run Application.new
puts 123



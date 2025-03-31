require 'json'
require 'logger'
require 'thread'
require 'ostruct'
require 'net/http'

require 'active_support/all'
require 'awesome_print'

require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

require 'diplomat'
require 'redis'

CURRENT_IP = ENV.fetch('CURRENT_IP', '172.22.1.11')

Diplomat.configure do |config|
  config.url = "http://#{CURRENT_IP}:8500"
end

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

  def info *_args
    [200, {}, [render_string("Here i'am!.#{leader? ? ' **LEADER**' : ''}")]]
  end

  def cluster *_args
    all = Diplomat::Health.service('think/rails-web', passing: true).map do |meta|
      id = meta.dig(:Service, 'ID')
      ip = meta.dig(:Service, 'Address')
      port = meta.dig(:Service, 'Port')
      [id, ip, port]
    end

    cluster_info = ''
    all.each do |(id, ip, port)|
      info = Net::HTTP.get(URI("http://#{ip}:#{port}/info"))
      cluster_info += "  * #{id}[#{ip}:#{port}] -> #{info}\n"
    end

    [200, {}, [render_string("Cluster info:\n#{cluster_info}")]]
  end

  def sync_sleep(_request, seconds, *_args)
    sleep(seconds.to_f)
    [200, {}, [render_string("sleeping for #{seconds.to_f}")]]
  end

  private

  def leader?
    if (leader_identifier = cache.read('think:rails:leader'))
      return leader_identifier == identifier
    end

    cache.write('think:rails:leader', identifier, expires_in: 10.seconds)
    cache.read('think:rails:leader') == identifier
  end

  def identifier
    @identifier ||= "#{ENV['HOSTNAME']}_#{Time.now.to_i}"
  end

  def redis
    @redis ||= Redis.new(host: CURRENT_IP)
  end

  def cache
    @cache ||= ActiveSupport::Cache::RedisCacheStore.new(redis: redis)
  end

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

# rails r ./publisher.rb

Rails.logger.info 'Run Redis listener'

$redis = Redis.new(host: $current_ip)

i = 0
loop do
  i += 1
  Rails.logger.info "Publish message..."

  $redis.publish('think_tasks', "DataHandlerJob:#{i}")
  sleep 3
end

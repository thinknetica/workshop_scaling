

$current_ip = ENV.fetch('CURRENT_IP', '172.22.1.11')

Diplomat.configure do |config|
  config.url = "http://#{$current_ip}:8500"
end

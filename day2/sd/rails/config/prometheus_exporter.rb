# config/prometheus_exporter.rb
require 'prometheus_exporter/server'

server = PrometheusExporter::Server::WebServer.new
server.start

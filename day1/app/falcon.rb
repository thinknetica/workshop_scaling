load :rack

rack 'prober' do
  scheme 'http'
  protocol { Async::HTTP::Protocol::HTTP1 }

  count ENV.fetch('PROBER_WORKERS', 1).to_i

  endpoint do
    Async::HTTP::Endpoint.for(scheme, '0.0.0.0', port: ENV.fetch('PORT', ENV.fetch('PROBER_PORT', 3000)),
                                                protocol: protocol)
  end

  Console.logger.level = ENV.fetch('LOG_LEVEL', 'info').to_sym

  # append preload "preload.rb"

  
end


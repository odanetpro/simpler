# frozen_string_literal: true

require 'logger'

class SimplerLogger
  def initialize(simpler, **options)
    @logger = Logger.new(options[:logdev] || $stdout)
    @simpler = simpler
  end

  def call(env)
    status, headers, body = @simpler.call(env)

    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
    @logger.info("Handler: #{env['simpler.controller'].class}##{env['simpler.action']}")
    @logger.info("Parameters: #{env['simpler.controller'].instance_variable_get(:@params)}")
    @logger.info("Response: #{status} #{status_message(status)} [#{headers['Content-Type']}] #{env['simpler.view']}\n")

    [status, headers, body]
  end

  private

  def status_message(code)
    Rack::Utils::HTTP_STATUS_CODES[code]
  end
end

require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = body || File.read(template_path)

      ERB.new(template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def body
      @env['simpler.body']
    end

    def template_path
      path = "#{template || [controller.name, action].join('/')}.html.erb"
      @env['simpler.view'] = path

      Simpler.root.join(VIEW_BASE_PATH, path)
    end
  end
end

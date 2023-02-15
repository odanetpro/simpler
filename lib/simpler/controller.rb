require_relative 'view'

module Simpler
  class Controller
    NOT_FOUND = 404

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new

      set_params
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    attr_reader :params

    def set_params
      path = @request.env['PATH_INFO']
      query = @request.env['QUERY_STRING']
      route = @request.env['simpler.route']

      route_params = route.params(path)
      query_params = Rack::Utils.parse_query(query).transform_keys(&:to_sym)

      @params = route_params.merge(query_params) { |_key, old_value, _new_value| old_value }
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(options = {})
      if options[:template]
        render_template(options[:template])
      elsif options[:plain]
        render_plain(options[:plain])
      end
    end

    def render_template(template)
      @request.env['simpler.template'] = template
    end

    def render_plain(text)
      @response.headers['Content-Type'] = 'text/plain'
      @request.env['simpler.body'] = text
    end

    def status(code)
      @response.status = code
    end

    def headers
      @response.headers
    end

    def headers=(key, value)
      @response.headers[key] = value
    end

    def not_found
      @response.status = NOT_FOUND
      @request.env['simpler.body'] = 'Page not found'
    end
  end
end

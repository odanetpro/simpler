class TestsController < Simpler::Controller
  def index
    @time = Time.now

    # render template: 'tests/list'
    # render plain: 'Plain text response'
    
    # status 201
    headers['Content-Type'] = 'text/plain'
  end

  def create; end
end

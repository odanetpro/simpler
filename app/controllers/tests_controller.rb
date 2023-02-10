class TestsController < Simpler::Controller
  def index
    @time = Time.now

    # render template: 'tests/list'
    # render plain: 'Plain text response'

    # status 201
    # headers['Content-Type'] = 'text/plain'
  end

  def show
    render plain: params.inspect
  end

  def create; end
end

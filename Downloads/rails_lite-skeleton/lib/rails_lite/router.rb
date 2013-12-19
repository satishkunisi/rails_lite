class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    req.request_method.downcase.to_sym == @http_method &&
    req.path.match(@pattern)
  end

  def run(req, res)

    route_params = {}
    names = @pattern.match(req.path).names
    captures = @pattern.match(req.path).captures

    p captures
    names.count.times do |idx|
      route_params[names[idx].to_sym] = captures[idx]
    end
    @controller_class.new(req, res, route_params).invoke_action(@action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.find { |route| route.matches?(req)}
  end

  def run(req, res)
    if self.match(req)
      self.match(req).run(req, res)
    else
      res.status = 404
    end
  end
end

#get '/users' to: users#index
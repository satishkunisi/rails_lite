require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req, @res, @route_params = req, res, route_params
    @params = Params.new(@req, @route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    return @res if @already_built_response

    @already_built_response = true

    session.store_session(@res)
    @res.status = 302
    @res.header["location"] = url

  end

  def render_content(content, type)
    return @res if @already_built_response

    @already_built_response = true
    session.store_session(@res)
    @res.content_type = type
    @res.body = content
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    template_path = "views/#{controller_name}/#{template_name}.html.erb"
    contents = File.read(template_path)
    embedded_content = ERB.new(contents).result(binding)
    render_content(embedded_content, 'text/text')
  end

  def invoke_action(name)
  end
end

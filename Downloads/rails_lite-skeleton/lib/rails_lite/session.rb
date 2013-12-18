require 'json'
require 'webrick'

class Session
  def initialize(req)
     app_cookie = req.cookies.select do |cookie|
       cookie.name == '_rails_lite_app'
     end.first

    if app_cookie
      @cookie = JSON.parse(app_cookie.value)
    else
      @cookie = {}
    end

  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    stored_cookie = WEBrick::Cookie.new('_rails_lite_app', @cookie.to_json)
    res.cookies << stored_cookie
  end
end

require 'uri'
require 'json'

class Params
  def initialize(req, route_params)
    @params = {}
    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end

    if req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end

    @params.merge!(route_params)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private


  def parse_www_encoded_form(www_encoded_form)
    params = {}

    key_values = URI.decode_www_form(www_encoded_form)

    key_values.each do |full_key, value|
      the_scope = params

      key_seq = parse_key(full_key)

      key_seq.each_with_index do |key, idx|
        if (idx + 1) == key_seq.count
          the_scope[key] = value
        else
          the_scope[key] ||= {}
          the_scope = the_scope[key]
        end
      end
    end

    params
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end

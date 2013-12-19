params = "{"cat[name]"=>"joe", "cat[toy][type]"=>"yarn",
          "cat[toy][type]"=>"string", "cat[toy][name]"=>"yarny"}"


def nested_params(params)
  return {} if params.nil?

  parsed_keys = parse_keys(params.keys)

  if parsed_keys.length == 2
    hash = Hash.new
    return hash[parsed_keys[0]] = parsed_keys[1]
  end

end

def parse_keys(key)
  key.split(/\]\[|\[|\]/)
end

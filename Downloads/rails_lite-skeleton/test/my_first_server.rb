require 'webrick'

root = File.expand_path '~/'
server = WEBrick::HTTPServer.new :Port => 8080, :DocumentRoot => root

server.mount_proc '/' do |req, res|
  WEBrick::HTTPResponse.content_type = 'text/text'
end

trap('INT') { server.shutdown }
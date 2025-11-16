require 'webrick'
include WEBrick
require 'rubygems'

Process.daemon(true, true)
byteLimit = 20 

def isNumber?(str)
  true if Float(str) rescue false # We define a function to check if the given input is a number returns a bool value.
end

isNumberBool = nil

server_port = 9999 # Define server port :)



server = HTTPServer.new(:Port => server_port) # the server Itself

server.mount_proc '/' do |request, response|
  request.each { |header, value| puts "  #{header}: #{value}" }

  isNumberBool = isNumber?("#{request.body}")

  if isNumberBool == false 
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = "Numbers only shithat. No words, you fucking asshole"
  elsif isNumberBool == true and request.body.bytesize < byteLimit
    n = request.body.to_i
    calculateFib = ((1 + Math.sqrt(5))**n - (1 - Math.sqrt(5))**n) / (2**n * Math.sqrt(5))
    calculateFib_mut = calculateFib.round(2)
    calculateFib_str = calculateFib_mut.to_s

    strResponse = "The sequence for the number is: " + calculateFib_str + "\n"
    
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = "#{strResponse}"
  elsif request.body.bytesize > byteLimit
    response.status = 400
    response['Content-Type'] = 'text/plain'
    response.body = "Request too big \n"

  end
  
end

trap('INT') { server.shutdown }
server.start


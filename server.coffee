##
#	Sermepa Faker
#	A SERMEPA Server faker to test your apps for sightly changes
#	Read the README before using it!! (yeah, it's mandatory)
#
#	Felipe "Pyron" Martín
#	me@fmartingr.com
#	@fmartingr
#
##########################

http = require 'http'
querystring = require 'querystring'

# [][][] CONFIGURATION
# Return to referer (POST TESTS)
DEVELOPING = false
# Verbose in console
DEBUG = true
# Port to listen on
PORT = 8080

# [][][] LET'S DO THIS

# Parses the response data
parse_response = (items) ->
	true

# Validates the form data
check_request = (request) ->
	true

# Server codez
http.createServer (request, response) ->
	body = ''
	post_params = ''
	request.setEncoding 'UTF-8'

	console.log "[ <= ] Received request!" if DEBUG

	# Listener
	request.addListener 'data', (chunk) ->
		body += chunk
		console.log "BODY CHUNK: #{chunk}" if DEBUG

	# End (parse POST data)
	request.addListener 'end', ->
		post_params = querystring.parse body
		if DEBUG
			console.log "POST PARAMS: "
			console.log post_params

	# Go back to the form if we're doing tests	
	if DEVELOPING
		response.writeHead 
			'Location': response.headers.referer
.listen PORT

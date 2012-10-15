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

# Do TPV data validation
VALIDATE = 
	do: false
	# Merchant Code
	merchant_code: ''
	# Secret Key
	secret_key: ''

# [][][] LET'S DO THIS

# TODO for Validation ^^
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

	# End (parse POST data)
	request.addListener 'end', ->
		post_params = querystring.parse body
		if DEBUG
			console.log "[ -- ] POST received: "
			console.log post_params

		if post_params is {}
			console.log "[ -- ] Empty POST, doing nothing!"
		else
			# Go back to the form if we're doing tests	
			if DEVELOPING and request.headers.referer?
				console.log "[ => ] Redirecting to '#{request.headers.referer}'"
				response.writeHead 302,
					'Location': request.headers.referer
				response.end()
			true

.listen PORT

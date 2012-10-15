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

# Redirect function
redirect = (response, url) ->
	console.log "[ => ] Redirecting to '#{url}'"
	response.writeHead 302,
		'Location': url
	response.end()

# Check if an object is empty
empty = (object) ->
	return (k for own k of object).length is 0

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

		console.log "[ == ] POST received"
		console.log post_params if DEBUG and not empty post_params

		if empty post_params
			console.log "[ -- ] Empty POST, doing nothing!"
			if request.headers.referer?
				redirect response, request.headers.referer
		else
			# Go back to the form if we're doing tests	
			if DEVELOPING and request.headers.referer?
				console.log "[ => ] Redirecting to '#{request.headers.referer}'"
				response.writeHead 302,
					'Location': request.headers.referer
				response.end()
			true

.listen PORT

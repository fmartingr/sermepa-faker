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

_ = require 'underscore'
fs = require 'fs'
http = require 'http'
url = require 'url'
querystring = require 'querystring'

# [][][] CONFIGURATION
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

# using {{}} for underscore
_.templateSettings =
	interpolate : /\{\{(.+?)\}\}/g

# [][][] LET'S DO THIS

REQUESTS = []

# TODO for Validation ^^
# Parses the response data
parse_response = (items) ->
	querystring.stringify items

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
	(k for own k of object).length is 0

# [][] HANDLERS

# Main page that allows to send a (non-)valid response to our app
home_handler = (request, response) ->
	console.log "[ <= ] Request: /" if DEBUG

	body = ''
	post_params = ''

	request.addListener 'data', (chunk) ->
		body += chunk

	# End (parse POST data)
	request.addListener 'end', ->
		post_params = querystring.parse body

		# If POST is empty, redirect to referer
		if empty post_params
			if request.headers.referer?
				redirect response, request.headers.referer
		else
			# Main response
			request_number = (REQUESTS.push post_params) - 1 
			template = fs.readFileSync('tpv.html').toString()
			html = _.template template, { request: request_number }
			response.write html

		response.end()

# Send a valid response to you app
valid_handler = (request, response) ->
	body = ''
	post_params = ''

	request.addListener 'data', (chunk) ->
		body += chunk

	request.addListener 'end', ->
		true

# Send an invalid response to your app
invalid_handler = (request, response) ->
	body = ''
	post_params = ''

	request.addListener 'data', (chunk) ->
		body += chunk

	request.addListener 'end', ->
		true

# [][] Server codez
http.createServer (request, response) ->
	request.setEncoding 'UTF-8'

	url_parts = url.parse request.url

	switch url_parts.pathname
		when '/valid' then valid_handler request, response
		when '/invalid' then invalid_handler request, response
		when '/' then home_handler request, response

.listen PORT

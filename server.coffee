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
crypto = require 'crypto'

# [][][] CONFIGURATION
# Verbose in console
DEBUG = true
# Port to listen on
PORT = 8080
# Http Auth for Post request
HTTP_AUTH = ''
#HTTP_AUTH = 'Basic ' + new Buffer('USERNAME:PASSWORD').toString('base64');

# Do TPV data validation
VALIDATE = 
	do: true
	# Secret Key
	secret_key: 'qwertyasdf0123456789'
	terminal: '001'

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
			if VALIDATE.do
				validation_string = post_params.Ds_Merchant_Amount + post_params.Ds_Merchant_Order + post_params.Ds_Merchant_MerchantCode + post_params.Ds_Merchant_Currency + post_params.Ds_Merchant_TransactionType + post_params.Ds_Merchant_MerchantURL + VALIDATE.secret_key
				console.log validation_string
				shasum = crypto.createHash('sha1')
					.update(validation_string.toString())
					.digest 'hex'
				post_params['_validation_sha1'] = shasum.toUpperCase()

			# Making html table
			table = ''
			for key of post_params
				table += """
					<tr>
						<td>#{key}</td>
						<td>#{post_params[key]}</td>
					</tr>
				"""

			# Normal
			request_number = (REQUESTS.push post_params) - 1 
			template = fs.readFileSync('tpv.html').toString()
			html = _.template template, { request: request_number, data_table: table }
			response.write html

		response.end()

# Send a valid response to you app
valid_handler = (request, response) ->
	body = ''
	post_params = ''

	request.addListener 'data', (chunk) ->
		body += chunk

	request.addListener 'end', ->
		post_params = querystring.parse body

		transaction = REQUESTS[post_params.request]
		response_url = transaction.Ds_Merchant_MerchantURL
		_response_url = url.parse response_url, true
		
		if VALIDATE.do
			# Response: Digest=SHA-1(Ds_ Amount + Ds_ Order + Ds_MerchantCode + Ds_ Currency + Ds _Response + CLAVE SECRETA)	
			if transaction.Ds_Merchant_MerchantSignature is transaction._validation_sha1
				signature_string = transaction.Ds_Merchant_Amount + transaction.Ds_Merchant_Order + transaction.Ds_Merchant_MerchantCode + transaction.Ds_Merchant_Currency + '0000' + VALIDATE.secret_key
				signature = crypto.createHash('sha1').update(signature_string).digest('hex').toUpperCase()
				post_data = 
					#'Ds_Date': '27/12/2011'
					#'Ds_Hour': '11:46'
					'Ds_SecurePayment': '1'
					'Ds_Card_Country': '724'
					'Ds_Amount': transaction.Ds_Merchant_Amount
					'Ds_Currency': transaction.Ds_Merchant_Currency
					'Ds_Order': transaction.Ds_Merchant_Order
					'Ds_MerchantCode': transaction.Ds_Merchant_MerchantCode
					'Ds_Terminal': VALIDATE.terminal
					'Ds_Signature': signature
					'Ds_Response': '0000'
					'Ds_MerchantData': transaction.Ds_Merchant_MerchantData
					'Ds_TransactionType': transaction.Ds_Merchant_TransactionType
					'Ds_ConsumerLanguage': '1'
					'Ds_AuthorisationCode': '000000'
			else
				post_data =
					'Ds_Response': '9999'	
		else
			post_data =
				'Ds_Response': '0000'

		_post_data = parse_response post_data

		post_options = 
			host: _response_url.hostname
			port: 80
			path: _response_url.pathname
			method: "POST"
			headers:
				'Content-Type': 'application/x-www-form-urlencoded'
				'Content-Length': _post_data.length

		if not empty HTTP_AUTH
			post_options.headers['Authorization'] = HTTP_AUTH

		post_request = http.request post_options, (response) ->
			response.setEncoding 'UTF-8'
			response.on 'data', (chunk) ->
				console.log "[ <= ] After POST response: #{chunk}"

		post_request.write _post_data
		post_request.end()

		redirect response, transaction.Ds_Merchant_UrlOK

# Send an invalid response to your app
# TODO
invalid_handler = (request, response) ->
	body = ''
	post_params = ''

	request.addListener 'data', (chunk) ->
		body += chunk

	request.addListener 'end', ->
		post_params = querystring.parse body

# [][] Server codez
http.createServer (request, response) ->
	request.setEncoding 'UTF-8'

	url_parts = url.parse request.url

	switch url_parts.pathname
		when '/valid' then valid_handler request, response
		when '/invalid' then invalid_handler request, response
		when '/' then home_handler request, response

.listen PORT

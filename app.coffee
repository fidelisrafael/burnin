strata    = require('ace').strata

Message   = require(__dirname + '/models/message')

app.use strata.methodOverride

# test users
app.set credentials: {user: 'm4k3u557r0n63r'}

app.before ->
	if @request.pathInfo != '/login' && !@session.user
		@redirect '/login'

app.get '/login', ->
  success = @basicAuth (user, pass) ->
    @settings.credentials[user] is pass and user

  if success
    @session.user = success
    @redirect '/'

app.get '/messages/:id', ->
  @message = Message.find(+@route.id).wait()
  @eco 'messages/show'

app.post '/messages', ->
	@message = Message.build(
		title:  @params.message_title,
		body: 	@params.message_body ,
		user: 	@session.user
	)
	success = @message.save().wait()

	if @request.xhr
		if @params.html
			@json {success: 1 , html: @message.toHTML() , message: @message.toJSON() }
		else 
			@json @message
	else
	  @redirect @message

app.get '/logout', ->
  @session = {}
  @redirect '/'

app.get '/', ->
	@messages = Message.all().wait();
	@eco "messages/index"

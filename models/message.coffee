Data		= require(__dirname + '/sequelize');
Sequelize 	= Data.sequelize
Model 	  	= Data.model 

Message = Model.define(
	'Message', {
		title: 		Sequelize.STRING,
		body: 		Sequelize.TEXT,
		user: 		Sequelize.STRING,
		fileURL: 	Sequelize.TEXT	
	},
	instanceMethods:
		url:	-> '/messages/' + @id
		toJSON: -> @values 
		formatedBody: -> @body.replace(/\n/i , '<br />'),
		time: 	-> 
			strftime = require('strftime')
			strftime('%d/%m/%Y %T' , new Date(@createdAt))
		bodyEscaped: ->
			@body.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
		toHTML: -> 
			("<h2 class='text bold'>" + @title + "</h2><p class='text book italic'>" + @bodyEscaped() + "</p><p><span class='icon user username'>&nbsp;" + @user + "&nbsp;</span></p><p><span class='icon time'>&nbsp;" + @createdAt + "&nbsp;</span></p>")
)
Message.sync() # create table :)

module.exports = Message
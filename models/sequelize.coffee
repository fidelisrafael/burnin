Sequelize = require('sequelize-sqlite').sequelize
SQLite 	  = require('sequelize-sqlite').sqlite

sequelize = new Sequelize('burnin', '' , null , {
	dialect: 'sqlite',
	storage: 'db/burnin.sqlite'
})

module.exports = {
	model: sequelize,
	sequelize: Sequelize,
	sqlite: SQLite
}
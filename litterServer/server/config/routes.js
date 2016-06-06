var users = require('./../controllers/users.js')

module.exports = function(app) {
	app.post('/create', function(req, res){
		console.log("create reached")
		users.create(req,res)
	});
	app.get('/', function(req, res){
		console.log("gotya")
	})
	app.post('/login', function(req,res){
		console.log("login reached")
		users.find(req, res)
	})
	app.post('/updatePaymentMethod',function(req,res){
		console.log("update route reached")
		users.updatePaymentMethod(req,res)
	})
};
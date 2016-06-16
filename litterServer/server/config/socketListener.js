var clientManager = require('./../managers/client_manager.js')

module.exports = function(server){

	var io = require("socket.io").listen(server)

	io.sockets.on('connection', function(socket){
		console.log("we are connected to a socket")
		console.log("printing socket id")
		console.log(socket.id)

		
	})

	return io
}
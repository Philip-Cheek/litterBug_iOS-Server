var posts = require('./../controllers/posts.js')


clientManager = function(){

	var manager = {};
  
	manager.socket_locator = {};
	manager.seeds = [];

  manager.findAudienceForPost = function(postID,socket,callback){
    posts.findOne({"_id":postID},function(err,result){
      if (err){
        console.log("we have error on socket post find")
      }else{
        console.log("client manager succesfully found post")
        console.log(result);
        result["donation"] = String(result["donation"]);

        var room = result["_id"];
        var userSeeds = this.socket_locator[socket.id];

        console.log("About to print user seeds")
        console.log(userSeeds);

        for (var seed = 0; seed < userSeeds.length; seed++){
          console.log("we are iterating through userSeeds")
          console.log(userSeeds[seed]);

          var locationBalloon = socket_Locator[userSeeds[seed]].sIndex.users;
          var useredPrev = [];
          console.log("determined users in location balloon");
          console.log(locationBalloon);

          for (var idx = 0; idx < locationBalloon; idx++){
            var current = locationBalloon[idx];

            console.log("printing current user in locationBalloon");
            console.log(current);

            if (this.inRadius({"lng":result["loc"][0],"lat":result["loc"][1]},{"lng":current.origin.lng,"lat":current.origin.lat},64373) &&
             useredPrev.includes(current.socketID)==false){
                console.log("WOW WE haveSuccessfulladded a thing");
                current.socket.join(room);
                useredPrev.push(current.socketId);
            }
          }
        }

        return room;nod
      }
    });
  }
  

  //distance to be expressed in meters. radius must be in meters
	manager.inRadius = function(origin, location, radius){
    
    	if (typeof (Number.prototype.toRad) === "undefined") {
        	Number.prototype.toRad = function () {
            	return this * (Math.PI / 180);
        	};
    	}
    
    	var R = 6371;
    
    	var dLat = (location.lat - origin.lat).toRad();
      	var dLon = (location.lng - origin.lng).toRad();
      
      	var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(origin.lat.toRad()) * Math.cos(origin.lat.toRad()) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
    
      	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      	var d = (R * c)*1000;
      	console.log(d);
      
      	if (d < radius){
        	return true;
      	}

    	return false;
  	};
  
  	manager.addUser = function(username, socket, location, radius){
    	var unique = true;  
    	var socket_id = id;

    	this.socket_locator[socket_id] = [];

    	var user = {
      		"nickname": username,
      		"origin": {
        		"lng": location.lng,
        		"lat": location.lat,
      		},
      		"socketId": socket.id,
          "socket": socket,
      		"radius": radius,
    	};

  
    	for (var idx = 0; idx < this.seeds.length; idx++){
      		if (this.inRadius(this.seeds[idx].origin, location, 48280)){
        		this.seeds[idx].users.push(user);

        		this.socket_locator[socket_id].push({
          			"sIndex": idx,
          			"uIndex": this.seeds[idx].users.length - 1
        		});
          
        		unique = false;
      		}
    	}
      
    	if (unique){
      		this.seeds.push({
        		"origin": {
          			"lng": location.lng,
          			"lat": location.lat },
        		"users": []
      		});
      
      		var seed_idx = this.seeds.length - 1;
      		this.seeds[seed_idx].users.push(user);

      		this.socket_locator[socket_id].push({
        		"sIndex": seed_idx,
        		"uIndex": this.seeds[idx].users.length - 1
      		});
    	}
  	};

  	manager.scrubUser= function(id){
    	var u_linger;
    	var seed;
    
    	var user_seeds = this.socket_locator[id];

    	for (var i = 0; i < user_seeds.length; i++){
      		u_linger = user_seeds[i].uIndex;
      		seed = this.seeds[user_seeds[i].sIndex];

      		seed.users.splice(u_linger, 1);
    	}
  	};
  
  	manager.getSeeds = function(){
    	return this.seeds;
  	};
  

  	manager.spawnMessageRoom = function(id, message_loc){
   
    	var user_seeds = this.socket_locator[id];
    	var room = id;
      var roomIDs = []
    
    	var seed_hit;
    	var u_linger;
    
    	for (var seed = 0; seed < user_seeds.length; seed++){
      		seed_hit = this.seeds[user_seeds[seed].sIndex];
      		u_linger = user_seeds[seed].uIndex;
      
      		for (var user = 0; user < seed_hit.users.length; user++){
        		if (user != u_linger && this.inRadius(seed_hit.users[user].origin, message_loc, seed_hit.users[user].radius)){
          			room += "#" + seed_hit.users[user].socketId;
                roomIDs.push(seed_hit.users[user].socketId)
        		}
      		}
    	}
    
    	return room;
    
  	};
  
  return manager;
};

module.exports = new clientManager()
var mongoose = require('mongoose');
var User = mongoose.model('User');

module.exports = (function() {
	return{
		create: function(req, res){
			if (!req.body.fb){
				res.json({"status": "notLogged"})
			}else{
				var new_user = new User({
					fb: req.body.fb,
					name: req.body.name,
					pic: req.body.pic, 
					gender: req.body.gender,
					email: req.body.email,
					ageRange: Number(req.body.ageRange),
					customerID: req.body.customerID,
					paymentID: req.body.paymentID
				});

				console.log("about to save")
				new_user.save(function(err, result){
					if (err){
						console.log(err)
						res.json({"status": "notLogged"})
					}else{
						console.log(result)
        				res.json({"status": "logged", "id": result._id});
					}
				});
			}
		},
		find: function(req,res){
			if (!req.body.fb){
				console.log(req.body)
				res.json({"status": "fail"})
			}else{
				fb = req.body.fb
				console.log(fb)
				User.findOne({"fb":fb},function(err,result){
					if (err){
						console.log(err)
					}else{
						console.log(result)
						if (result != null){
							res.json({"status": "logged", "user": result})
						}else{
							res.json({"status": "notLogged"})
						}
					}

				});
			}
		}
	}
})();
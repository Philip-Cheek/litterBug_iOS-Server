var mongoose = require('mongoose');
var User = mongoose.model('User');
var stripe = require('stripe')("sk_test_REDACTED")

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

							var paymentItems = ["customerID", "paymentID"]

							for (var idx = 0; idx < 2; idx++){
								console.log(paymentItems[idx])
								if (result[paymentItems[idx]] != "none"){
									result[paymentItems[idx]] = "registered"
								}
							}
							
							res.json({"status": "logged", "user": result})
						}else{
							res.json({"status": "notLogged"})
						}
					}

				});
			}
		},

		updatePaymentMethod: function(req,res){
			console.log(req.body)
			if (!req.body.fb){
				console.log("no facebook token")
				res.json({"status": "fail"})
			}else{
				console.log("here is updatePaymentMethod req")
				console.log(req.body)
				User.findOne({"fb":req.body.fb}, function(err,result){
					if (err){
						console.log(err);
					}else{
						console.log("we got user");
						console.log(result);

						var user_info = {
							"customerID": result.customerID,
							"recipientID": result.paymentID
						};

						function create_customer(callback){
							console.log("create customer called")
							stripe.customers.create({
								source: req.body.credit,
								email: result.email
							}, function(err, customer){
								if (err){
									console.log("fucked up on customer creation");
									console.log(err);
								}else{
									console.log("customer successfully created");
									console.log(customer);
									user_info["customerID"] = customer.id;

									console.log("keeping tabs on user_info");
									console.log(user_info);

									callback()
								}
							});
						};

						function create_recipient(callback){
							stripe.recipients.create({
								name: result.name,
								type: "individual",
								card: req.body.recipient 
							},function(err, recipient){
								if (err){
									console.log("fucked up on recipient creation")
									console.log(err)
								}else{
									console.log("recipient successfully created!")
									console.log("recipient")

									user_info["recipientID"] = recipient.id

									console.log("keeping tabs on user_info");
									console.log(user_info);

									callback();
								}
							})
						};

						function save_newPayment(callback){
							User.update({'fb': req.body.fb},{
								customerID: user_info["customerID"],
								paymentID: user_info["recipientID"]
							}, 
							function(err, response){
								if(err){
									console.log("error on User.update")
								}else if(!response){
									console.log("no response on User.update")
								}else{
									console.log("successfully updated");
									console.log(response)

									res.json({status:"success"})
								}
							})
						};

						if (req.body.credit){
							create_customer(function(){
								if (req.body.recipient){
									create_recipient(save_newPayment)
								}else{
									save_newPayment()
								}
							})
						}else if (req.body.recipient){
							create_recipient(function(){
								if (req.body.credit){
									create_customer(save_newPayment)
								}else{
									save_newPayment()
								}
							});
						};
					}
				})


				
			}
		}
	}
})();
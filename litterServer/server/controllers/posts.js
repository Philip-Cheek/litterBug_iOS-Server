var mongoose = require('mongoose');
var Post = mongoose.model('Post');
var stripe = require('stripe')("sk_test_REDACTED")

module.exports = (function() {
	return {

		create: function(){
			if (!req.body.authorID){
				print("not authorized")
				res.json({"status":"not_authorized"})
			}else{
				print("going to print req body")
				print(req.body)
				var newPost = new Post({
					_author: req.body.authorID,
					title: req.body.title,
					ranking: req.body.ranking,
					description: req.body.description,
					donation: req.body.donation
				})

				newPost.loc.push(Number(req.body.long))
				newPost.loc.push(Number(req.body.lat))
				newPost._donors.push(Numreq.body.authorID)

				newPost.save(function(err, result){
					if (err){
						console.log(err)
						res.json({"status":"failed"})
					}else{
						console.log("success on newPost save")
						res.json({"status":"success", "postID": result._id})
					}

				})


			}
		},

		findSingle: function(req, res){
			if (!res){
				res = null 
			}

			Post.findOne({"_id":req.body.postID}, function(err, result){
				if (err){
					console.log(err)
					if (!res){
						return false
					}
				}else{
					console.log("finding post reached")
					if (!res){
						return result 
					}
				}
			})

		}

	}
})()
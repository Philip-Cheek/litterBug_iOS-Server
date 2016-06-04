var mongoose = require('mongoose');
console.log("whyyyy")

var UserSchema = new mongoose.Schema({
	fb: String,
	name: String,
	pic: String,
	gender: String,
	email: String,
	ageRange: Number,
	paymentID: String,
	customerID: String
})

module.exports = mongoose.model('User', UserSchema)
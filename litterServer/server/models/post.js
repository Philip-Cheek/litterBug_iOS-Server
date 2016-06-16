var mongoose = require('mongoose');

var PostSchema = new mongoose.Schema({
	_author: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
	_donor: [{type: mongoose.Schema.Types.ObjectId, ref: 'User'}],
	loc: {type: [Number], index: '2d'},
	title: String, 
	ranking: String,
    description: String,
    donation:String,
});

module.exports = mongoose.model('Post', PostSchema)
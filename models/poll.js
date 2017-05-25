var mongoose = require('mongoose');

module.exports = mongoose.model('Poll',{
	id: String,
	pollname: String,
	opt_number: Number,
	opts: [{name:String, votes:Number}]
});
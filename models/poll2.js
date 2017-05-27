var mongoose = require('mongoose');

module.exports = mongoose.model('Poll2',{
	id: String,
	pollname: String,
	author:String,
	opt_number: Number,
	total_votes: Number,
	opts: [mongoose.Schema.Types.Mixed]//new mongoose.Schema ({name:String, votes:Number}, {_id: false})]
});
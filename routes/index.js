var express = require('express');
var router = express.Router();
var https = require('https');
var Poll2= require('../models/poll2');
var request = require('request');


var isAuthenticated = function (req, res, next) {
	// if user is authenticated in the session, call the next() to call the next request handler 
	// Passport adds this method to request object. A middleware is allowed to add properties to
	// request and response objects
	if (req.isAuthenticated())
		return next();
	// if the user is not authenticated then redirect him to the login page
	res.redirect('/');
}
/*
io.on('connection', function(socket){
  console.log('a user connected');
});
*/
module.exports = function(passport){

	/* GET login page. */
	router.get('/', function(req, res) {
    	// Display the Login page with any flash message, if any
		res.render('home.jade', { message: req.flash('message') });
	});
	
	

	/* Handle Login POST */
	router.post('/login', passport.authenticate('login', {
		successRedirect: '/home',
		failureRedirect: '/',
		failureFlash : true  
	}));

	/* GET Registration Page */
	router.get('/signup', function(req, res){
		res.render('register.jade',{message: req.flash('message')});
	});

	/* Handle Registration POST */
	router.post('/signup', passport.authenticate('signup', {
		successRedirect: '/home',
		failureRedirect: '/signup',
		failureFlash : true  
	}));

	/* GET Home Page */
	router.get('/home', isAuthenticated, function(req, res){
		/*Poll2.find({"author":req.user.username},function (err, kittens) {
			if (err) return console.error(err);
				console.log(JSON.stringify(kittens.opts));
				//console.log(kittens[2].pollname);
				
				var names=[];
				
				for (var i=0;i<kittens.length;i++){
					names.push(kittens[i].pollname);
				}
		var names_all=[];		
		Poll2.find({},function (err, kittens) {
			if (err) return console.error(err);
				console.log(JSON.stringify(kittens.opts));
				//console.log(kittens[2].pollname);
			
				
				
				var i=0;
				while (kittens[i]!=undefined){
					names_all.push(kittens[i].pollname);
					i++;
					if (i>5) break;
				}
			
		console.log(names_all)
			*/	
		console.log('idiots')
		console.log('idiots gonna');
		
		var options = {
			url: 'https://www.quandl.com/api/v3/datasets/WIKI/goog.json?column_index=1&start_date=2010-01-01&end_date=2017-01-01&collapse=annual&api_key=c3kCyhGGfJFsLUECjwwV'
			};
				//, {arr: JSON.stringify([{'idiot':'idiot'}, {'fool':'fool'}])})//{arr:JSON.stringify([{idiot:"idiot"}])});
		//https://www.quandl.com/api/v3/datasets/OPEC/ORB.csv?api_key=c3kCyhGGfJFsLUECjwwV
		
		request.get(options, function(err,httpResponse,body)
			{ if (err) {console.log('idiot')} 
			var obj=JSON.parse(body);
			
			console.log(obj);
			if (obj.dataset.data.length>2)
			{
			var data =obj.dataset.data;
			//data.unshift(['dates','prices'])
			var dates=[];
			var prices=[];
			for (var i=0;i<data.length;i++)
			{
				dates[i]=data[i][0];
				prices[i]=data[i][1];
			}
			console.log(dates);
			console.log(JSON.stringify(data));
			res.render('home11.jade', { user: req.user, data: JSON.stringify(data)  });
			}
			})
			//https://jsfiddle.net/api/post/library/pure/
		
		/*https.get('https://www.quandl.com/api/v3/datasets/OPEC/ORB.json?api_key=c3kCyhGGfJFsLUECjwwV');
			var data = '';
			res.on('data', function (chunk) {
			data += chunk;
			console.log('idiots gonna');
			console.log(data);
			});*/
			
			
											
		//res.render('home.jade', { user: req.user, arr: JSON.stringify(names) });
		//res.render('home.jade', { user: req.user, arr: names, arr_all:names_all  });
	});
	

	/* Handle Logout */
	router.get('/signout', function(req, res) {
		req.logout();
		res.redirect('/');
	});
	
	router.get('/displaypoll', function(req, res) {
		var pollname=req.query.name;
		/*Poll2.find({"pollname": ''}).remove(function(err,kittes){
			if (err) return console.error(err)	;
			console.log('deleted')})*/
		Poll2.findOne({"pollname":pollname},function (err, kittens) {
			if (err) return console.error(err);
				console.log(JSON.stringify(kittens.author))
				if (req.user) {
					if (req.user.username==kittens.author){
    				res.render('display_poll_logged_in.jade', {arr: JSON.stringify(kittens), name:req.query.name})// logged in
					} else
					{res.render('display_poll_logged_in_no_delete.jade', {arr: JSON.stringify(kittens), name:req.query.name})}
						} else {
					res.render('display_poll.jade', {arr: JSON.stringify(kittens), name:req.query.name})
    					// not logged in
						}
				
		//res.render('display_poll.jade', { name: pollname });
	})});
	
	
	router.get('/deletepoll', function(req, res) {
		var pollname=req.query.name;
		Poll2.find({"pollname": pollname}).remove(function(err,kittes){
			if (err) return console.error(err)	;
			console.log('deleted')
			console.log(req.user.username)
			res.redirect('/home')}
		//res.render('display_poll.jade', { name: pollname });
	)});
	
	
	router.post('/newpoll', function(req, res) {
		console.log(req.body.opt_number);
		res.render('newpoll.jade', { num: req.body.opt_number, name: req.body.pollname , author: req.body.author });
	});
	
	router.post('/update_poll', function(req, res) {
		console.log(req.body.opts);
		console.log(req.body);
		var pollname=req.query.name;
		Poll2.findOne({"pollname":req.body.pollname},function (err, kittens) {
			if (err) return console.error(err);
			/*for (var i=0;i<kittens.length;i++){
				if (kittens[i].name==req.body.opts){
					kittens[i].votes==kittens[i].votes+1
				}
			}*/
				//kittens.opts[1].votes=2;
				var u =kittens.opts;
				for (var i=0;i<u.length;i++){
					if (u[i].name==req.body.opts){
						u[i].votes=u[i].votes+1
				}}
				kittens.total_votes=kittens.total_votes+1;
				//kittens.opts=['idiots','idiots','idiots'];
				//kittens.pollname='@@@';
				console.log(u);
				//console.log(req.body.opts);
				//console.log(req.body.opts==u[1].name);
				kittens.opts=[];
				kittens.opts=u;
				console.log("opts")
				console.log("opts")
				console.log('/displaypoll?name='+req.body.pollname)
				kittens.save(function (err) {
        if(err) {
            console.error('ERROR!');
        }
		
		//res.render('newpoll.jade', { num: req.body.opt_number, name: req.pollname });
	})
	
	res.redirect('/displaypoll?name='+req.body.pollname)})
	})
	
	router.get('/logout', function(req, res){
	req.logout();
	res.redirect('/home');
	});
	
	//https://www.quandl.com/api/v3/datasets/OPEC/ORB.csv?api_key=YOUR_API_KEY_HERE
	//c3kCyhGGfJFsLUECjwwV

	
	
	router.post('/poll_submit', function(req, res) {
		//ideal place to handle the request ?
		
		
		
		
		/*Poll2.remove({"pollname":"idiots"},function (err, kittens) {
			if (err) return console.error(err);
				
				//console.log(kittens);
											})*/
		var testpoll = new Poll2
		var u=req.body.pollname;
		var u2=req.user.username;
		testpoll.pollname=u;
		testpoll.author=u2;
		testpoll.total_votes=0;
		console.log(u.toString());
		console.log(u2.toString());
		
		var a=[];
		//for (var i=0;i<2;i++){
		var i=0;
		while (req.body["opt_number"+i]!=undefined)
		{
			a.push(req.body["opt_number"+i]);
			testpoll.opts.push({name:req.body["opt_number"+i], votes:0});
			i++;
			console.log(a);
		}
		
		testpoll.save(function (err) {
			if (err) {
    			console.log(err);
					} else {
    			console.log('submitted');
						}
					});
			    
				Poll2.find({},function (err, kittens) {
			if (err) return console.error(err);
				console.log(JSON.stringify(kittens.opts));
				res.redirect('home')//, {arr: JSON.stringify([{'idiot':'idiot'}, {'fool':'fool'}])})//{arr:JSON.stringify([{idiot:"idiot"}])});
				
											})
			
		
	});

	return router;
}






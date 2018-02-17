[33mcommit 3ad64680b3160013d17554af1ed8e894f242c7e1[m
Author: AlRum <shiroc5@gmail.com>
Date:   Sat May 27 19:38:07 2017 +0000

    working_version

[1mdiff --git a/models/poll2.js b/models/poll2.js[m
[1mindex 860cfbd..dd547ab 100644[m
[1m--- a/models/poll2.js[m
[1m+++ b/models/poll2.js[m
[36m@@ -5,5 +5,6 @@[m [mmodule.exports = mongoose.model('Poll2',{[m
 	pollname: String,[m
 	author:String,[m
 	opt_number: Number,[m
[32m+[m	[32mtotal_votes: Number,[m
 	opts: [mongoose.Schema.Types.Mixed]//new mongoose.Schema ({name:String, votes:Number}, {_id: false})][m
 });[m
\ No newline at end of file[m
[1mdiff --git a/routes/index.js b/routes/index.js[m
[1mindex 4c82205..6ee5216 100644[m
[1m--- a/routes/index.js[m
[1m+++ b/routes/index.js[m
[36m@@ -54,13 +54,28 @@[m [mmodule.exports = function(passport){[m
 				for (var i=0;i<kittens.length;i++){[m
 					names.push(kittens[i].pollname);[m
 				}[m
[32m+[m		[32mvar names_all=[];[m[41m		[m
[32m+[m		[32mPoll2.find({},function (err, kittens) {[m
[32m+[m			[32mif (err) return console.error(err);[m
[32m+[m				[32mconsole.log(JSON.stringify(kittens.opts));[m
[32m+[m				[32m//console.log(kittens[2].pollname);[m
[32m+[m[41m				[m
 				[m
[32m+[m[41m				[m
[32m+[m				[32mvar i=0;[m
[32m+[m				[32mwhile (kittens[i]!=undefined){[m
[32m+[m					[32mnames_all.push(kittens[i].pollname);[m
[32m+[m					[32mi++;[m
[32m+[m					[32mif (i>5) break;[m
[32m+[m				[32m}[m
[32m+[m		[32mconsole.log(names_all)[m
[32m+[m		[32mconsole.log('idiots')[m
 				//, {arr: JSON.stringify([{'idiot':'idiot'}, {'fool':'fool'}])})//{arr:JSON.stringify([{idiot:"idiot"}])});[m
 				[m
 											[m
 		//res.render('home.jade', { user: req.user, arr: JSON.stringify(names) });[m
[31m-		res.render('home.jade', { user: req.user, arr: names });[m
[31m-	});[m
[32m+[m		[32mres.render('home.jade', { user: req.user, arr: names, arr_all:names_all  });[m
[32m+[m	[32m})});[m
 	})[m
 [m
 	/* Handle Logout */[m
[36m@@ -78,7 +93,10 @@[m [mmodule.exports = function(passport){[m
 			if (err) return console.error(err);[m
 				console.log(JSON.stringify(kittens.author))[m
 				if (req.user) {[m
[32m+[m					[32mif (req.user.username==kittens.author){[m
     				res.render('display_poll_logged_in.jade', {arr: JSON.stringify(kittens), name:req.query.name})// logged in[m
[32m+[m					[32m} else[m
[32m+[m					[32m{res.render('display_poll_logged_in_no_delete.jade', {arr: JSON.stringify(kittens), name:req.query.name})}[m
 						} else {[m
 					res.render('display_poll.jade', {arr: JSON.stringify(kittens), name:req.query.name})[m
     					// not logged in[m
[36m@@ -121,6 +139,7 @@[m [mmodule.exports = function(passport){[m
 					if (u[i].name==req.body.opts){[m
 						u[i].votes=u[i].votes+1[m
 				}}[m
[32m+[m				[32mkittens.total_votes=kittens.total_votes+1;[m
 				//kittens.opts=['idiots','idiots','idiots'];[m
 				//kittens.pollname='@@@';[m
 				console.log(u);[m
[36m@@ -163,6 +182,7 @@[m [mmodule.exports = function(passport){[m
 		var u2=req.user.username;[m
 		testpoll.pollname=u;[m
 		testpoll.author=u2;[m
[32m+[m		[32mtestpoll.total_votes=0;[m
 		console.log(u.toString());[m
 		console.log(u2.toString());[m
 		[m
[1mdiff --git a/views/display_poll.jade b/views/display_poll.jade[m
[1mindex 1bb2a8c..eeeff0a 100644[m
[1m--- a/views/display_poll.jade[m
[1m+++ b/views/display_poll.jade[m
[36m@@ -23,6 +23,7 @@[m [mblock content[m
             gg.push([g.opts[i].name,g.opts[i].votes])[m
           }[m
           console.log(JSON.stringify(gg));[m
[32m+[m[32m          document.write('<h4>'+'Total votes: '+g.total_votes+'</h4>');[m
           console.log(JSON.stringify(g.opts.length));[m
         </script>[m
       [m
[1mdiff --git a/views/display_poll_logged_in.jade b/views/display_poll_logged_in.jade[m
[1mindex e721518..cac640b 100644[m
[1m--- a/views/display_poll_logged_in.jade[m
[1m+++ b/views/display_poll_logged_in.jade[m
[36m@@ -21,8 +21,9 @@[m [mblock content[m
             t+=g.opts[i].votes;[m
           }[m
           if (t==0){[m
[31m-          document.write('<h2>'+'Be first to vote!'+'</h2>');[m
[32m+[m[32m          document.write('<h4>'+'Be first to vote!'+'</h4>');[m
           }[m
[32m+[m[32m          document.write('<h4>'+'Total votes: '+g.total_votes+'</h4>');[m
           console.log(JSON.stringify(gg));[m
           console.log(JSON.stringify(g.opts.length));[m
         </script>[m
[36m@@ -55,7 +56,7 @@[m [mblock content[m
       [m
               // Set chart options[m
               var options = {'title':'Poll results',[m
[31m-                             'width':400,[m
[32m+[m[32m                             'width':600,[m
                              is3D: true,[m
                              'height':300,[m
                               legend:{textStyle:{fontSize:'16', fontName:'Arial'}},[m
[36m@@ -73,15 +74,16 @@[m [mblock content[m
         <body>[m
           <!--Div that will hold the pie chart-->[m
           <div id="chart_div"></div>[m
[32m+[m[32m          </div>[m
         </body>[m
[31m-      [m
[32m+[m[41m        [m
         <script>[m
           document.write ('<p>Vote!</p>');[m
           document.write ("<form class='form-vote',id='idiots', action='/update_poll', method='POST'>");[m
[31m-          document.write ('<div class="btn-group" data-toggle="buttons">')[m
[32m+[m[32m          document.write ('<div>')[m
           for (i=0; i<g.opts.length; i++) {[m
[31m-            document.writeln('<label class="btn btn-primary" >');[m
[31m-            document.writeln(g.opts[i].name+'<input type="radio" autocomplete="off" name="opts" value="'+g.opts[i].name+'">');[m
[32m+[m[32m            document.writeln('<label class="radio-inline" >');[m
[32m+[m[32m            document.writeln('<input type="radio" autocomplete="off" name="opts" value="'+g.opts[i].name+'">'+g.opts[i].name);[m
             document.writeln('</label>');[m
           }[m
           document.writeln('<input type="radio", checked="true",  style="display:none" , name="pollname" value="'+g.pollname+'">');[m
[36m@@ -91,8 +93,12 @@[m [mblock content[m
           var formData = new FormData(document.forms.person);[m
           formData.append("patronym", "Робертович");[m
         </script>[m
[31m-        [m
[31m-        [m
[32m+[m[32m        <script>[m
[32m+[m[32m        $(".btn" ).click(function() {[m
[32m+[m[32m            //$(this).css( "border", "3px solid red" );[m
[32m+[m[32m            $(this).css('background-color', '#ff0000');[m
[32m+[m[32m          })[m
[32m+[m[32m        </script>[m[41m        [m
       a(href='/../home') home[m
       p[m
         a(href='/deletepoll'+'?name='+'#{name}') delete #{name}[m
[1mdiff --git a/views/display_poll_logged_in_no_delete.jade b/views/display_poll_logged_in_no_delete.jade[m
[1mnew file mode 100644[m
[1mindex 0000000..d9cd725[m
[1m--- /dev/null[m
[1m+++ b/views/display_poll_logged_in_no_delete.jade[m
[36m@@ -0,0 +1,99 @@[m
[32m+[m[32mextends layout[m
[32m+[m[32mblock content[m
[32m+[m[32m  div.container-fluid[m
[32m+[m[32m    div.row[m
[32m+[m[32m      h1.text-left #{name}[m
[32m+[m[41m      [m
[32m+[m[32m      script(type='text/javascript').[m
[32m+[m[32m          var g=JSON.parse('!{arr}')[m
[32m+[m[41m          [m
[32m+[m[41m           [m
[32m+[m[41m          [m
[32m+[m[32m      html.[m
[32m+[m[41m        [m
[32m+[m[32m        <script>[m
[32m+[m[32m        var gg=[];[m
[32m+[m[41m          [m
[32m+[m[32m          var t=0;[m
[32m+[m[41m          [m
[32m+[m[32m          for (var i=0;i<g.opts.length;i++){[m
[32m+[m[32m            gg.push([g.opts[i].name,g.opts[i].votes])[m
[32m+[m[32m            t+=g.opts[i].votes;[m
[32m+[m[32m          }[m
[32m+[m[32m          if (t==0){[m
[32m+[m[32m          document.write('<h4>'+'Be first to vote!'+'</h4>');[m
[32m+[m[32m          }[m
[32m+[m[32m          document.write('<h4>'+'Total votes: '+g.total_votes+'</h4>');[m
[32m+[m[32m          console.log(JSON.stringify(gg));[m
[32m+[m[32m          console.log(JSON.stringify(g.opts.length));[m
[32m+[m[32m        </script>[m
[32m+[m[41m      [m
[32m+[m[41m      [m
[32m+[m[32m      html.[m
[32m+[m[32m        <head>[m
[32m+[m[32m          <!--Load the AJAX API-->[m
[32m+[m[32m          <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>[m
[32m+[m[32m          <script type="text/javascript">[m
[32m+[m[32m            if (t>0){[m
[32m+[m[32m            // Load the Visualization API and the corechart package.[m
[32m+[m[32m            google.charts.load('current', {'packages':['corechart']});[m
[32m+[m[41m      [m
[32m+[m[32m            // Set a callback to run when the Google Visualization API is loaded.[m
[32m+[m[32m            google.charts.setOnLoadCallback(drawChart);[m
[32m+[m[41m      [m
[32m+[m[32m            // Callback that creates and populates a data table,[m
[32m+[m[32m            // instantiates the pie chart, passes in the data and[m
[32m+[m[32m            // draws it.[m
[32m+[m[32m            function drawChart() {[m
[32m+[m[41m      [m
[32m+[m[32m              // Create the data table.[m
[32m+[m[32m              var data = new google.visualization.DataTable();[m
[32m+[m[32m              data.addColumn('string', 'Topping');[m
[32m+[m[32m              data.addColumn('number', 'Slices');[m
[32m+[m[32m              data.addRows(gg);[m
[32m+[m[41m                [m
[32m+[m[41m              [m
[32m+[m[41m      [m
[32m+[m[32m              // Set chart options[m
[32m+[m[32m              var options = {'title':'Poll results',[m
[32m+[m[32m                             'width':400,[m
[32m+[m[32m                             is3D: true,[m
[32m+[m[32m                             'height':300,[m
[32m+[m[32m                              legend:{textStyle:{fontSize:'16', fontName:'Arial'}},[m
[32m+[m[32m                              tooltip:{textStyle:{fontSize:'16', fontName:'Arial'}}[m
[32m+[m[32m              };[m
[32m+[m[41m      [m
[32m+[m[32m              // Instantiate and draw our chart, passing in some options.[m
[32m+[m[32m              var chart = new google.visualization.PieChart(document.getElementById('chart_div'));[m
[32m+[m[32m              chart.draw(data, options);[m
[32m+[m[32m            }[m
[32m+[m[32m            }[m
[32m+[m[32m          </script>[m
[32m+[m[32m        </head>[m
[32m+[m[41m      [m
[32m+[m[32m        <body>[m
[32m+[m[32m          <!--Div that will hold the pie chart-->[m
[32m+[m[32m          <div id="chart_div"></div>[m
[32m+[m[32m        </body>[m
[32m+[m[41m      [m
[32m+[m[32m        <script>[m
[32m+[m[32m          document.write ('<p>Vote!</p>');[m
[32m+[m[32m          document.write ("<form class='form-vote',id='idiots', action='/update_poll', method='POST'>");[m
[32m+[m[32m          document.write ('<div>')[m
[32m+[m[32m          for (i=0; i<g.opts.length; i++) {[m
[32m+[m[32m            document.writeln('<label class="radio-inline" >');[m
[32m+[m[32m            document.writeln('<input type="radio" autocomplete="off" name="opts" value="'+g.opts[i].name+'">'+g.opts[i].name);[m
[32m+[m[32m            document.writeln('</label>');[m
[32m+[m[32m          }[m
[32m+[m[32m          document.writeln('<input type="radio", checked="true",  style="display:none" , name="pollname" value="'+g.pollname+'">');[m
[32m+[m[32m          document.write ('<input type="submit" class="btn btn-success" value="Vote!" />');[m
[32m+[m[32m          document.write ('</div>')[m
[32m+[m[32m          document.write ('</form>');[m
[32m+[m[32m          var formData = new FormData(document.forms.person);[m
[32m+[m[32m          formData.append("patronym", "Робертович");[m
[32m+[m[32m        </script>[m
[32m+[m[41m        [m
[32m+[m[41m        [m
[32m+[m[32m      a(href='/../home') home[m
[32m+[m[32m      p[m
[32m+[m[32m        a(href='/logout') logout[m
[1mdiff --git a/views/home.jade b/views/home.jade[m
[1mindex 2638bd8..82dc6a8 100644[m
[1m--- a/views/home.jade[m
[1m+++ b/views/home.jade[m
[36m@@ -1,12 +1,3 @@[m
[31m-html.[m
[31m-	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">[m
[31m-[m
[31m-	<!-- Optional theme -->[m
[31m-	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">[m
[31m-[m
[31m-	<!-- Latest compiled and minified JavaScript -->[m
[31m-	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>[m
[31m-[m
 extends layout[m
 [m
 block content[m
[36m@@ -23,7 +14,14 @@[m [mblock content[m
 								each item in arr[m
 									li [m
 										a(href='/displaypoll'+'?name='+item) #{item}[m
[32m+[m[41m										[m
[32m+[m								[32mp[m
 								[m
[32m+[m								[32mh4 Recent Polls[m
[32m+[m[41m								[m
[32m+[m								[32meach item in arr_all[m
[32m+[m									[32mli[m[41m [m
[32m+[m										[32ma(href='/displaypoll'+'?name='+item) #{item}[m
 								[m
 			div.col-xs-6[m
 				[m
[1mdiff --git a/views/layout.jade b/views/layout.jade[m
[1mindex 5ebcfcc..fc657fd 100644[m
[1m--- a/views/layout.jade[m
[1m+++ b/views/layout.jade[m
[36m@@ -2,6 +2,8 @@[m [mdoctype html[m
 html[m
   head[m
     title= title[m
[32m+[m[32m    html[m
[32m+[m[32m      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>[m
     link(rel='stylesheet', href='/stylesheets/style.css')[m
     link(rel='stylesheet', href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css')[m
   body[m

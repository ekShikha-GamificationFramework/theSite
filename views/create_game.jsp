<%@ page import ="java.sql.*" %>	

<link rel="stylesheet" href="../public/css/alchemy.min.css"/>
<link rel="stylesheet" href="../public/css/vendor.css"/>
<script src="../public/js/d3.v3.min.js"></script>
<script src="../public/js/alchemy.js"></script>
<script src="../public/js/vendor.js"></script>
<script type="text/javascript" src="../public/js/loader.js"></script>
<script type="text/javascript">
	google.charts.load('current', {'packages':['corechart']});
	//hide obs1
	function switchDisplay(obs1, obs2){
		for(a of obs1){
			document.getElementById(a).style.display="none";
		}
		for(a of obs2){
			document.getElementById(a).style.display="block";
		}
	}
</script>

<div class="alchemy" id="alchemy" style="height:85vh; width:75vw; margin-left: -4vw"></div>

<%
	// ---------------->>>>>>>>>>>>> USE AJAX HERE !!!!!!!!  <<<<<<<<<<<<<<<-----------------
	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamification","archit","archit123");
	PreparedStatement st;
	ResultSet rs;	
%>

<script type="text/javascript">
	var activities=[];
	var existingActivities=[];
	var scenes=[];
	var path = [];
	var catMarks = {};
	var gameMapData = {
		"nodes": [],
		"edges": []
	};

	document.getElementById("middle").style.marginLeft = "250px";
	var config = {
		dataSource: gameMapData,
		forceLocked: false, 
		directedEdges : true,  
		initialScale : 0.6,
		zoomControls : true,  
		linkDistancefn: function(e, k){ return 10; },
		edgeStyle: {
		    "all": {
		      "color": "#EEE",
		      "opacity": 1
			}
		},
		nodeStyle : {
			"all" : {
				"radius" :15
			}
		},
		nodeCaption: function(node){ 
			return node.name;
		}
	};

	//the graph
	var alchemy = new Alchemy(config);

</script>

<div class="sidenav">


<div id="msform">
	<!-- progressbar -->
	<ul id="progressbar">
		<li class="active">Categories</li>
		<li>Activities</li>
		<li>Contribution</li>
		<li>Paths</li>
		<li>Gamify!</li>
	</ul>
	<!-- fieldsets -->
	<fieldset>
		<h5><b>Choose categories for the game</b></h5>
		<select class="form-control" id="theCat">
			<%
			st = con.prepareStatement("select id, name from category");
			rs=st.executeQuery();
			String s="";
			while(rs.next()){
				s+="<option value="+ rs.getString(1)+">"+ rs.getString(2) +"</option>";
			}
			out.print(s);
			%>
		</select>
		<input type="text" id="catScore" placeholder="Max Category Score"/>
		<button type="button" class="btn btn-default" onclick="addCategory()">Add Category</button>
		<br>
		<input type="button" name="next" class="next action-button" value="Next" />
	</fieldset>
	<fieldset>
		<div id="actChoose">
			<h2 class="fs-title">Choose</h2>
			<button type="button" class="btn btn-default" onclick="switchDisplay(['actChoose'], ['newActivityDiv', 'back1'])">New Activity</button>
			<h3 class="fs-subtitle">or</h3>
			<button type="button" class="btn btn-default" onclick='switchDisplay(["actChoose"], ["existingActivityDiv", "back1"])'>Existing Activity</button>
		</div>
		<div id="newActivityDiv" style="display:none">
			<input type="text" id="theName" placeholder="Activity Name"/>
			<!-- <input type="text" id="theClass" placeholder="Class"/> -->
			
			<!-- <select class="form-control" id="taxonomyLevel" name="level" id="theLevel" style="margin-bottom: 10px; width:100%">

				<option>Recall</option>
				<option>Apply</option>
				<option>Analyze</option>
			</select> -->
			<input type="text" id="theIcon" placeholder="Icon Link" id="iconFile"/>
			<input type="text" id="theLink" placeholder="Activity Link" id="activityFile"/>
			<select class="form-control" id="catSelectN"></select>
			<br>
			<input id="theTopics" list="topics" placeholder="Topic" onkeypress="searchTopic('')"/>
			<!-- <input type="text" id="theScore" placeholder="Maximum Score"/> -->
			<button type="button" class="btn btn-default" onclick="activityAdder('new')">
        	Add activity
    		</button>
		</div>
		<%
		st = con.prepareStatement("select id, name from activity");
		rs=st.executeQuery();
		s="";
		while(rs.next()){
			s+="<option value="+ rs.getString(1)+">"+ rs.getString(2) +"</option>";
		}
		%>
		<div id="existingActivityDiv" style="display:none">
			<select class="form-control" id="actSelect"><%out.print(s);%></select>
			<br>
			<select class="form-control" id="catSelectE"></select>
			<input id="theTopics1" list="topics" placeholder="Topic" onkeypress="searchTopic('1')"/>
			<!-- <input type="text" id="theScoreE" placeholder="Maximum Score"/> -->
			<br>
			<button type="button" class="btn btn-default" onclick="activityAdder('exis')" style="margin-top:10px; margin-bottom:10px">
        	Add activity
    		</button>
		</div>
		<h3 id="back1" class="fs-subtitle" style="display: none" onclick="switchDisplay(['existingActivityDiv', 'newActivityDiv', 'back1'], ['actChoose'])"><a href="#">Back</a></h3>
		<input type="button" name="previous" class="previous action-button" value="Previous" />
		<input type="button" name="next" class="next action-button" value="Next" />
	</fieldset>
	<fieldset>
		<!-- <div id="sceneDiv">	    
		    <input type="text" id="sceneName" placeholder="Scene Name"/>
		    <input type="text" placeholder="Scene Link" id="sceneMedia"/>
			<button type="button" class="btn btn-default" onclick="sceneAdder()" style="margin-top:10px; margin-bottom:10px">
		        Add scene
		    </button>
	    </div> -->

	    <div class="panel-group" id="contriDiv">
	    	
	    </div>

	    <input type="button" name="previous" class="previous action-button" value="Previous" />
	    <input type="button" name="next" class="next action-button" value="Next" />
	</fieldset>
	<fieldset>
		<div id="pathDiv" style="text-align: center; width: 100%">
			Activity #1 : <select class="form-control" id="sel1"></select>
		    <br>
		    Activity #2 : 
		    <select class="form-control" id="sel2"></select>
		    <br>		    
		    <input type="text" id="sceneName" placeholder="Scene Name"/>
		    <input type="text" placeholder="Scene Link" id="sceneMedia"/>
	    	<!-- <input type="text" id="sugScore" placeholder="Suggested Score" /> -->
		    <button type="button" class="btn btn-default" onclick="activityConnector()" style="margin-top:10px; margin-bottom:10px">
		        Connect
		    </button>
		</div>
		<input type="button" name="previous" class="previous action-button" value="Previous" />
	    <input type="button" name="next" class="next action-button" value="Next" />
	</fieldset>
	<fieldset>
		<div id="gameDiv">
		    <input type="text" id="gameName" placeholder="Name your Game!"/>
		    <input type="text" id="gameLink" placeholder="Provide Icon Link"/>
		    <button type="button" class="btn btn-default" onclick="gameUploader();" style="margin-top:10px; margin-bottom:10px">
		        Create Game
		    </button>
		</div>
		<input type="button" name="previous" class="previous action-button" value="Previous" />
	</fieldset>
</div>

<!-- jQuery easing plugin -->
<script src="../public/js/jquery.easing.1.3.js" type="text/javascript"></script>

<script type="text/javascript">
	
//jQuery time
var current_fs, next_fs, previous_fs; //fieldsets
var left, opacity, scale; //fieldset properties which we will animate
var animating; //flag to prevent quick multi-click glitches

$(".next").click(function(){
	if(animating) return false;
	animating = true;
	
	current_fs = $(this).parent();
	next_fs = $(this).parent().next();
	
	//activate next step on progressbar using the index of next_fs
	$("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");
	
	//show the next fieldset
	next_fs.show(); 
	//hide the current fieldset with style
	current_fs.animate({opacity: 0}, {
		step: function(now, mx) {
			//as the opacity of current_fs reduces to 0 - stored in "now"
			//1. scale current_fs down to 80%
			scale = 1 - (1 - now) * 0.2;
			//2. bring next_fs from the right(50%)
			left = (now * 50)+"%";
			//3. increase opacity of next_fs to 1 as it moves in
			opacity = 1 - now;
			current_fs.css({
        'transform': 'scale('+scale+')',
        'position': 'absolute'
      });
			next_fs.css({'left': left, 'opacity': opacity});
		}, 
		duration: 800, 
		complete: function(){
			current_fs.hide();
			animating = false;
		}, 
		//this comes from the custom easing plugin
		easing: 'easeInOutBack'
	});
});

$(".previous").click(function(){
	if(animating) return false;
	animating = true;
	
	current_fs = $(this).parent();
	previous_fs = $(this).parent().prev();
	
	//de-activate current step on progressbar
	$("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");
	
	//show the previous fieldset
	previous_fs.show(); 
	//hide the current fieldset with style
	current_fs.animate({opacity: 0}, {
		step: function(now, mx) {
			//as the opacity of current_fs reduces to 0 - stored in "now"
			//1. scale previous_fs from 80% to 100%
			scale = 0.8 + (1 - now) * 0.2;
			//2. take current_fs to the right(50%) - from 0%
			left = ((1-now) * 50)+"%";
			//3. increase opacity of previous_fs to 1 as it moves in
			opacity = 1 - now;
			current_fs.css({'left': left});
			previous_fs.css({'transform': 'scale('+scale+')', 'opacity': opacity});
		}, 
		duration: 800, 
		complete: function(){
			current_fs.hide();
			animating = false;
		}, 
		//this comes from the custom easing plugin
		easing: 'easeInOutBack'
	});
});

</script>
</div>
<datalist id="topics"></datalist>

<%

st=con.prepareStatement("SELECT AUTO_INCREMENT FROM information_schema.tables WHERE table_name = 'topic' AND table_schema = DATABASE()");
rs=st.executeQuery();
rs.next();

%>

<script type="text/javascript">
	var theTopicID = parseInt("<%out.print(rs.getInt(1));%>")-1;
</script>

<%

st=con.prepareStatement("SELECT AUTO_INCREMENT FROM information_schema.tables WHERE table_name = 'activity' AND table_schema = DATABASE()");
rs=st.executeQuery();
rs.next();

%>

<script type="text/javascript">
	var newActivityID = <%= rs.getInt(1) %>;
	newActivityID = parseInt(newActivityID);
</script>

<%

st=con.prepareStatement("SELECT AUTO_INCREMENT FROM information_schema.tables WHERE table_name = 'story_scene' AND table_schema = DATABASE()");
rs=st.executeQuery();
rs.next();

%>

<script type="text/javascript">
	var newSceneID = <%= rs.getInt(1) %>;
	newSceneID = parseInt(newSceneID);
</script>

<%

st=con.prepareStatement("SELECT AUTO_INCREMENT FROM information_schema.tables WHERE table_name = 'game' AND table_schema = DATABASE()");
rs=st.executeQuery();
rs.next();

%>

<datalist id="category"></datalist>

<script type="text/javascript">
	//add this to script.js
	//or maybe not

	var curGameID = <%= rs.getInt(1) %>;

    function activityAdder(act){
    	
    	if(act=="exis"){
	    	sendInfo("topic", "s", getTopicID, {
	    		"selections" : ["id"],
	    		"lhs" : ["name"],
	    		"operator" : ["="],
	    		"rhs" : [document.getElementById("theTopics1").value] 
	    	});
	    }
	    else{
	    	sendInfo("topic", "s", getTopicID, {
	    		"selections" : ["id"],
	    		"lhs" : ["name"],
	    		"operator" : ["="],
	    		"rhs" : [document.getElementById("theTopics").value] 
	    	});
	    }
    }

    // function sceneAdder(){
    // 	var b = document.getElementById("sceneMedia").value;
    // 	var c = document.getElementById("sceneName").value;
    // 	if(b=="" || c==""){
    // 		alert("Don't leave it empty!");
    // 		return;
    // 	}

    // 	scenes.push({"name" : c, "link": b, "id" : newSceneID});
   
    // 	newSceneID++;

    // 	document.getElementById("sceneMedia").value="";
    // 	document.getElementById("sceneName").value="";
    // }

    function activityConnector(){

    	var act1 = document.getElementById('sel1').value;
    	var act2 = document.getElementById('sel2').value;

    	if(act1 != act2){

	    	var b = document.getElementById("sceneMedia").value;
	    	var c = document.getElementById("sceneName").value;
	    	if(!(b=="" || c=="")){
	    		scenes.push({"name" : c, "link": b, "id" : newSceneID});
	    		newSceneID++;
	    	}

	    	document.getElementById("sceneMedia").value="";
	    	document.getElementById("sceneName").value="";

	    	gameMapData.edges.push({
	    		"source" : act1,
	    		"target" : (act2),
	    		"caption" : c
	    	});
	    	
	    	//couldn't figure out how to add new nodes dynamically
	    	//so deleting the previous graph
	    	var myNode = document.getElementById("alchemy");
			while (myNode.firstChild) {
			    myNode.removeChild(myNode.firstChild);
			}

			alchemy = new Alchemy(config);
			var alchemyDiv = document.getElementById('alchemy');
			alchemyDiv.style.width = "75vw";
			alchemyDiv.style.height = "85vh";
			alchemyDiv.style.marginLeft = "-4vw";
			document.getElementsByTagName('g')[0].transform.baseVal.getItem(0).setTranslate(100,100);

			path.push({
				"act1" :act1,
				"act2" : act2,
				"scene" : !(b=="" || c=="") ? newSceneID-1 : -1
				//"score" : parseInt(document.getElementById('sugScore').value)
			});
    	}  
    	else{
    		alert("They cant't be same!");
    	}  	
    }

    function activityUploader(){
    	for(obj of activities){
    		sendInfo("activity", "i", null, {
				"name" : obj.name,
				"icon_link" : obj.icon_link,
				"program_link" : obj.program_link, 
				//"class" : obj.class,
				//"max_score" : obj.max_score,
				// "topic_id" : obj.topic_id,
				"creation_date" : obj.creation_date
				//"level" : obj.level
			});

			sendInfo("gameactivity", "i", null, {
				"game_id" : curGameID,
				"activity_id" : parseInt(obj.id.substr(0, obj.id.indexOf("-"))),
				"topic_id" : obj.topic_id,
				//"max_score" : catMarks[obj.category_id],
				"category_id" : obj.category_id,
				"contri" : contriMarks[obj.id]
			});
    	}
    	activities=[];

    	for(obj of existingActivities){
    		sendInfo("gameactivity", "i", null, {
    			"game_id" : curGameID,
    			"activity_id" : parseInt(obj.id.substr(0, obj.id.indexOf("-"))),
    			"topic_id" : obj.topic_id,
    			"category_id" : obj.category_id,
				"contri" : contriMarks[obj.id]
    			//"max_score" : catMarks[obj.category_id]
    		});
    	}
    }

    function sceneUploader(){
    	for(obj of scenes){
    		sendInfo("story_scene", "i", null,{
    			"name" : obj.name,
    			"link": obj.link
    		});
    	}
    	scenes=[];
    }

    function pathUploader(){
    	for(obj of path){
    		sendInfo("path", "i", null, {
    			"activity_id_1" : obj.act1,
    			"activity_id_2" : obj.act2,
    			"story_scene_id" : obj.scene,
    			"game_id" : curGameID
    			//"score" : obj.score
    		});
    	}
    	path=[];
    }

    function gameUploader(){
    	if(document.getElementById("gameName").value=="" || document.getElementById("gameName").value==""){
    		alert("Don't leave anything empty!");
    		return;
    	}
    	
    	if(gameMapData.nodes.length==0){
    		alert("Please select some activities!")
    		return;
    	}

    	activityUploader();
    	sceneUploader();
    	pathUploader();

    	for(i in catMarks){
    		sendInfo("gamecategory", "i", null,{
    			"game_id" : curGameID,
    			"category_id" : i,
    			"max_score" : catMarks[i]
    		});
    	}

    	sendInfo("game", "i", null, {
    		"name" : document.getElementById("gameName").value,
    		"icon_link": document.getElementById("gameLink").value,
    		"teacher_id" : "<%out.print(session.getAttribute("id"));%>",
    		"creation_date" : new Date().toJSON().slice(0,10)  
    	});
    
    	if(!alert("Game published!")){
    		window.location.reload();
    	}
    }

</script>

<script type="text/javascript">
    function searchTopic(x){
    	var text = document.getElementById('theTopics'+x).value;
    	sendInfo("topic", "s", putTopic, {
    		"selections" : ["name", "id"],
    		"lhs" : ["name"],
    		"operator" : ["like"],
    		"rhs" : ["%25"+text+"%25"]
    	});
    }
    function putTopic(){
    	if(request.readyState==4 && request.status == 200){ 
			var obj = JSON.parse(request.responseText); 
			var s = ""; 
			for(a of obj){
				s+="<option value= \""+ a.name +"\">" + a.id+"</option>";
			}
			document.getElementById("topics").innerHTML=s;
		} 
    }
    function getTopicID(){
    	if(request.readyState==4 && request.status == 200){
    		var obj = JSON.parse(request.responseText);
    		if(obj.length==0){
    			if(document.getElementById("newActivityDiv").style.display=="none"){
    				setTopicID("s");
    			}
    			else{
    				setTopicID("");
    			}
    		} 
			else{
				theTopicID = parseInt(obj[0].id);
				if(document.getElementById("newActivityDiv").style.display=="none"){
					var a = document.createElement("option");
			    	var b = document.createElement("option");

			    	a.text=b.text=document.getElementById("actSelect").selectedOptions[0].text+"-"+document.getElementById("catSelectE").selectedOptions[0].value+"-"+theTopicID;
			    	a.value=b.value=document.getElementById("actSelect").value+"-"+document.getElementById("catSelectE").selectedOptions[0].value+"-"+theTopicID;

			    	existingActivities.push({
			    		"id" : a.value,
			    		"topic_id" : theTopicID,
			    		"category_id" : document.getElementById("catSelectE").selectedOptions[0].value
			    		//"max_score" : parseInt(document.getElementById("theScoreE").value)
			    	});

			    	document.getElementById("sel1").appendChild(a);
			    	document.getElementById("sel2").appendChild(b);

			    	var accPanel = document.getElementById('class'+document.getElementById("catSelectE").selectedOptions[0].value);
			    	var panelData = accPanel.innerHTML;

			    	panelData = "<label>"+a.text+"</label> : <input name='"+a.text+"' style='padding: 0px; width:3vw' type='text' id='"+a.value+"'> pts" + panelData; 
			    	accPanel.innerHTML = panelData;

			    	gameMapData.nodes.push({
			    		"id" : a.value,
			    		"name" : a.text
			    	});

			    	var myNode = document.getElementById("alchemy");
					while (myNode.firstChild) {
					    myNode.removeChild(myNode.firstChild);
					}

					alchemy = new Alchemy(config);
					var alchemyDiv = document.getElementById('alchemy');
					alchemyDiv.style.width = "75vw";
					alchemyDiv.style.height = "85vh";
					alchemyDiv.style.marginLeft = "-4vw";
					document.getElementsByTagName('g')[0].transform.baseVal.getItem(0).setTranslate(100,100);
				}
				else{
					var c = document.getElementById("theName").value;
			    	// var d = document.getElementById("theClass").value;
			    	//var e = document.getElementById("theScore").value;
			    	var f = document.getElementById("theIcon").value;
			    	var g = document.getElementById("theLink").value;

			    	if(c=="" || f=="" || g==""){
			    		alert("Don't leave it empty!");
			    		return;
			    	}
			    	document.getElementById('actSelect').innerHTML+="<option value='"+newActivityID+"'>"+c+"</option>";
			    	var a = document.createElement("option");
			    	var b = document.createElement("option");

			    	a.text=b.text=c+"-"+document.getElementById("catSelectN").selectedOptions[0].value+"-"+theTopicID;
			    	a.value=b.value=newActivityID+"-"+document.getElementById("catSelectN").selectedOptions[0].value+"-"+theTopicID;

			    	document.getElementById("sel1").appendChild(a);
			    	document.getElementById("sel2").appendChild(b);

			    	var accPanel = document.getElementById('class'+document.getElementById("catSelectE").selectedOptions[0].value);
			    	var panelData = accPanel.innerHTML;

			    	panelData = "<label>"+a.text+"</label> : <input style='padding: 0px; width:3vw' type='text' id='"+a.value+"''>" + panelData; 
			    	accPanel.innerHTML = panelData;
			    	
			    	gameMapData.nodes.push({
			    		"id" : newActivityID+"-"+document.getElementById("catSelectN").selectedOptions[0].value+"-"+theTopicID,
			    		"name" : c+"-"+document.getElementById("catSelectN").selectedOptions[0].value+"-"+theTopicID
			    	});

			    	activities.push({
			    		"id" : a.value,
						"name" : c,
						"icon_link" : f,
						"program_link" : g, 
						//"class" : d,
						//"max_score" : e,
						"creation_date" : new Date().toJSON().slice(0,10),
						"id" : newActivityID,
						"category_id" : document.getElementById("catSelectN").selectedOptions[0].value,
						"topic_id" : theTopicID
						//"level" : document.getElementById('taxonomyLevel').value
					});

					newActivityID++;
					var myNode = document.getElementById("alchemy");
					while (myNode.firstChild) {
					    myNode.removeChild(myNode.firstChild);
					}

					alchemy = new Alchemy(config);
					var alchemyDiv = document.getElementById('alchemy');
					alchemyDiv.style.width = "75vw";
					alchemyDiv.style.height = "85vh";
					alchemyDiv.style.marginLeft = "-4vw";
					document.getElementsByTagName('g')[0].transform.baseVal.getItem(0).setTranslate(100,100);

					document.getElementById("theName").value="";
					//document.getElementById("theClass").value="";
					//document.getElementById("theScore").value="";
					document.getElementById("theIcon").value="";
					document.getElementById("theLink").value="";
				}
			}
    	}
    }
    function setTopicID(s){
    	sendInfo("topic", "i", null, {
    		"name" : document.getElementById("theTopics"+s).value
    	});
    	theTopicID++;
    }

    // function searchCategory(){
    // 	sendInfo("category", "s", putCategory, {
    // 		"selections" : ['id', 'name'],
    // 		"lhs" : ['name'],
    // 		"operator" : ['like'],
    // 		"rhs" : ['%25'+document.getElementById('theCat').value+'%25']	
    // 	});
    // }

	//  function putCategory(){
	//  	if(request.readyState==4 && request.status == 200){
	//  		var obj = JSON.parse(request.responseText);
	//  		var s = "";
	//  		for(a of obj){
	//  			s+="<option value= \""+ a.name +"\">" + a.id+"</option>";
			// }
			// document.getElementById("category").innerHTML=s;
	//  	}
	//  }

	var contriData = {};
	var contriMarks={};
	function setContriData(catID) {
		contriData[catID] = [["Activity", "Contribution"]];
		var accPanel = document.getElementById('class'+catID);
		var accInputs = accPanel.getElementsByTagName('input');
		var total = 0;
		for(var i=0; i<accInputs.length; i++){
			contriData[catID].push([accInputs[i].name, parseInt(accInputs[i].value)]);
			contriMarks[accInputs[i].id] = parseInt(accInputs[i].value);
			total += parseInt(accInputs[i].value);
		}
		if(total!=catMarks[catID]){
			alert('Please calculate the marks properly.\nThe total needs to be '+catMarks[catID]);
			return false;
		}
		return true;
	}

	function drawChart(catID){
		if(!setContriData(catID))
			return;
		var options = {
			legend : 'none',
			chartArea : {
				width:'90%',
				height:'90%'
			},
			is3D : true
		};
		var data = google.visualization.arrayToDataTable(contriData[catID]);
		var chart = new google.visualization.PieChart(document.getElementById(catID+'chart'));
        chart.draw(data, options);
	}

    function addCategory(){
    	var a = document.createElement("option");
    	var b = document.createElement("option");
    	var cat = document.getElementById('theCat').selectedOptions[0];
    	catMarks[cat.value] = parseInt(document.getElementById('catScore').value);
    	a.value=b.value=cat.value;
    	a.text=b.text=cat.text;
    	document.getElementById("catSelectE").appendChild(a);
    	document.getElementById("catSelectN").appendChild(b);
    	contriData[cat.value] = [];
    	var accordion = document.getElementById("contriDiv");
    	var s = "", x = "";
    	s+='<div class="panel panel-default"><div class="panel-heading"><h5 class="panel-title">';
    	s+='<a data-toggle="collapse" data-parent="#contriDiv" href="#'+cat.value+'">';
    	s+=cat.text +" - "+ catMarks[cat.value]+" pts";
    	s+='</a></h4></div>';
    	if(accordion.innerHTML=="")
    		x="in";
    	
    	s+='<div id="'+cat.value+'" class="panel-collapse collapse '+x+'"><div class="panel-body" id="class'+cat.value+'">';
    	s+='<div id="'+cat.value+'chart"></div>';
    	s+='<button type="button" class="btn btn-default" onclick="drawChart('+cat.value+')">Set Contribution</button>';
    	s+='</div></div></div>';
    	accordion.innerHTML+=s;
    }
</script>
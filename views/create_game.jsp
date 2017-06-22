<%@ page import ="java.sql.*" %>	

<link rel="stylesheet" href="../public/css/alchemy.min.css"/>
<link rel="stylesheet" href="../public/css/vendor.css"/>
<script src="../public/js/d3.v3.min.js"></script>
<script src="../public/js/alchemy.js"></script>
<script src="../public/js/vendor.js"></script>
<script src="../public/js/scripts.js"></script>
<script type="text/javascript">
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

<div class="alchemy" id="alchemy" style="height:70vh; width:80vw"></div>

<%
	// ---------------->>>>>>>>>>>>> USE AJAX HERE !!!!!!!!  <<<<<<<<<<<<<<<-----------------
	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamification","archit","archit123");
	PreparedStatement st = con.prepareStatement("select id, name from activity");
	ResultSet rs=st.executeQuery();
	String s="";
	while(rs.next()){
		s+="<option value="+ rs.getString(1)+">"+ rs.getString(2) +"</option>";
	}
	
%>

<script type="text/javascript">
	var activities=[];
	var existingActivities=[];
	var scenes=[];
	var path = [];
	var gameMapData = {
		"nodes": [],
		"edges": []
	};

	document.getElementById("middle").style.marginLeft = "250px";
	var config = {
		dataSource: gameMapData,
		forceLocked: false,     
		linkDistance: function(){ return 25; },
		nodeStyle : {
			"all" : {
				"radius" :20
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
	<!-- <ul id="progressbar">
	    <li class="active">Choose Activity</li>
	    <li>Choose Scene</li>
	    <li>Connect</li>
	    <li>Gamify!</li>
	</ul>
	<div class="form-group">
		<div id="act">
			<div id = "actChoose" class="gamifyDiv">
				<button class="btn btn-default" >Create new activity</button><br><span>or<br><a href="#">Choose from existing ones</a></span>
			</div>
			<div id="newActivityDiv" class="gamifyDiv">
				<span>Is this the starting activity?</span><input type="checkbox" name="root" style="color: white" /><br>
				<input class="form-control" type="text" id="theName" placeholder="Activity Name"/>
				<input class="form-control" type="text" id="theClass" placeholder="Class"/>
				<input class="form-control" type="text" id="theScore" placeholder="Maximum Score"/>
				<select id="taxonomyLevel" name="level" class="form-control" style="width: 80%">
					<option>Recall</option>
					<option>Apply</option>
					<option>Analyze</option>
				</select>
				<input class="form-control" type="text" id="theIcon" placeholder="Icon Link" id="iconFile"/>
				<input class="form-control" type="text" id="theLink" placeholder="Activity Link" id="activityFile"/>
				<input class="form-control" id="theTopics" list="topics" placeholder="Topic" onkeypress="searchTopic()"	/>
				<button class="btn btn-default" onclick="activityAdder()" style="margin-top:10px; margin-bottom:10px">
	        	Add activity
	    	</button>
				
			</div>

			<div id="existingActivityDiv" class="gamifyDiv">
				<select class="form-control" id="actSelect"><%out.print(s);%></select>
			</div>
    	</div>
			
		<div id="sceneDiv" class="gamifyDiv">	    
		    <input class="form-control" type="text" id="sceneName" placeholder="Scene Name"/>
		    <input class="form-control" type="text" placeholder="Scene Link" id="sceneMedia"/>
			<button class="btn btn-default" onclick="sceneAdder()" style="margin-top:10px; margin-bottom:10px">
		        Add scene
		    </button>
	    </div>

	    <div id="pathDiv" class="gamifyDiv">	
			<span style="color:white">Activity #1</span>
		    <select class="form-control" id="sel1">
		    	<% out.println(s); %>
		    </select>

		    <br>
		    
		    <span style="color:white">Activity #2</span>
		    <select class="form-control" id="sel2">
		    	<% out.println(s); %>
		    </select>
		    
		    <br>
		    
		    <span style="color:white">Connecting Scene</span>
		    <select id="sel3" class="form-control">
		    	<%
		    	st=con.prepareStatement("select id, name from story_scene");
		    	rs=st.executeQuery();
		    	while(rs.next()){
		    		out.println("<option value="+rs.getInt(1)+">"+rs.getString(2)+"</option>");
		    	}
		    	%>
		    </select>
	    
		    <button class="btn btn-default" onclick="activityConnector()" style="margin-top:10px; margin-bottom:10px">
		        Connect
		    </button>
	    </div>
	    <div id="gameDiv" class="gamifyDiv">
		    <input class="form-control" type="text" id="gameName" placeholder="Name your Game!"/>
		    <input class="form-control" type="text" id="gameLink" placeholder="Provide Icon Link"/>
		    <button class="btn btn-default" onclick="gameUploader();" style="margin-top:10px; margin-bottom:10px">
		        Create Game
		    </button>
		</div>
    </div> -->
    <!-- multistep form -->


<form id="msform">
	<!-- progressbar -->
	<ul id="progressbar">
		<li class="active">Activities</li>
		<li>Scenes</li>
		<li>Paths</li>
		<li>Gamify!</li>
	</ul>
	<!-- fieldsets -->
	<fieldset>
		<div id="actChoose">
			<h2 class="fs-title">Choose</h2>
			<button type="button" class="btn btn-default" onclick="switchDisplay(['actChoose'], ['newActivityDiv', 'back1'])">New Activity</button>
			<h3 class="fs-subtitle">or</h3>
			<button type="button" class="btn btn-default" onclick='switchDisplay(["actChoose"], ["existingActivityDiv", "back1"])'>Existing Activity</button>
		</div>
		<div id="newActivityDiv" style="display:none">
			<input type="text" id="theName" placeholder="Activity Name"/>
			<input type="text" id="theClass" placeholder="Class"/>
			<input type="text" id="theScore" placeholder="Maximum Score"/>
			<select class="form-control" id="taxonomyLevel" name="level" id="theLevel" style="margin-bottom: 10px; width:100%">
				<option>Recall</option>
				<option>Apply</option>
				<option>Analyze</option>
			</select>
			<input type="text" id="theIcon" placeholder="Icon Link" id="iconFile"/>
			<input type="text" id="theLink" placeholder="Activity Link" id="activityFile"/>
			<input id="theTopics" list="topics" placeholder="Topic" onkeypress="searchTopic()"	/>
			<button type="button" class="btn btn-default" onclick="activityAdder('new')">
        	Add activity
    		</button>
		</div>
		<div id="existingActivityDiv" style="display:none">
			<select class="form-control" id="actSelect"><%out.print(s);%></select>
			<br>
			<button type="button" class="btn btn-default" onclick="activityAdder('exis')" style="margin-top:10px; margin-bottom:10px">
        	Add activity
    		</button>
		</div>
		<h3 id="back1" class="fs-subtitle" style="display: none" onclick="switchDisplay(['existingActivityDiv', 'newActivityDiv', 'back1'], ['actChoose'])"><a href="#">Back</a></h3>
		<input type="button" name="next" class="next action-button" value="Next" />
	</fieldset>
	<fieldset>
		<div id="sceneDiv">	    
		    <input type="text" id="sceneName" placeholder="Scene Name"/>
		    <input type="text" placeholder="Scene Link" id="sceneMedia"/>
			<button type="button" class="btn btn-default" onclick="sceneAdder()" style="margin-top:10px; margin-bottom:10px">
		        Add scene
		    </button>
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
		    Connecting Scene : 
		    <select id="sel3" class="form-control"></select>
	    	<input type="text" id="sugScore" placeholder="Suggested Score" />
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
</form>

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

<script type="text/javascript">
	//add this to script.js
	//or maybe not

	var curGameID = <%= rs.getInt(1) %>;

    function activityAdder(act){
    	
    	if(act=="exis"){

	    	var a = document.createElement("option");
	    	var b = document.createElement("option");

	    	a.text=b.text=document.getElementById("actSelect").textContent;
	    	a.value=b.value=document.getElementById("actSelect").value;

	    	existingActivities.push(a.value);

	    	document.getElementById("sel1").appendChild(a);
	    	document.getElementById("sel2").appendChild(b);

	    	gameMapData.nodes.push({
	    		"id" : a.value,
	    		"name" : a.text
	    	});

	    	var myNode = document.getElementById("alchemy");
			while (myNode.firstChild) {
			    myNode.removeChild(myNode.firstChild);
			}

			alchemy = new Alchemy(config);
    		return;
    	}

    	var c = document.getElementById("theName").value;
    	var d = document.getElementById("theClass").value;
    	var e = document.getElementById("theScore").value;
    	var f = document.getElementById("theIcon").value;
    	var g = document.getElementById("theLink").value;

    	if(c=="" || d=="" || e=="" || g==""){
    		alert("Don't leave it empty!");
    		return;
    	}

    	var a = document.createElement("option");
    	var b = document.createElement("option");

    	a.text=b.text=c;
    	a.value=b.value=newActivityID;

    	document.getElementById("sel1").appendChild(a);
    	document.getElementById("sel2").appendChild(b);
    	
    	gameMapData.nodes.push({
    		"id" : newActivityID,
    		"name" : c
    	});

    	sendInfo("topic", "s", getTopicID, {
    		"selections" : ["id"],
    		"lhs" : ["name"],
    		"operator" : ["="],
    		"rhs" : [document.getElementById("theTopics").value] 
    	});

    	activities.push({
			"name" : c,
			"icon_link" : f,
			"program_link" : g, 
			"class" : d,
			"max_score" : e,
			"topic_id" : theTopicID,
			"creation_date" : new Date().toJSON().slice(0,10),
			"id" : newActivityID,
			"level" : document.getElementById('taxonomyLevel').value
		});

    	newActivityID++;
    	var myNode = document.getElementById("alchemy");
		while (myNode.firstChild) {
		    myNode.removeChild(myNode.firstChild);
		}

		alchemy = new Alchemy(config);

		document.getElementById("theName").value="";
    	document.getElementById("theClass").value="";
    	document.getElementById("theScore").value="";
    	document.getElementById("theIcon").value="";
    	document.getElementById("theLink").value="";
    }

    function sceneAdder(){
    	var b = document.getElementById("sceneMedia").value;
    	var c = document.getElementById("sceneName").value;
    	if(b=="" || c==""){
    		alert("Don't leave it empty!");
    		return;
    	}
    	var a = document.createElement("option");
    	a.value=newSceneID;
    	a.text=c;
    	document.getElementById("sel3").appendChild(a);

    	scenes.push({"name" : c, "link": b, "id" : newSceneID});
   
    	newSceneID++;

    	document.getElementById("sceneMedia").value="";
    	document.getElementById("sceneName").value="";
    }

    function activityConnector(){

    	var act1 = document.getElementById('sel1').value;
    	var act2 = document.getElementById('sel2').value;

    	if(act1 != act2){
	    	gameMapData.edges.push({
	    		"source" : parseInt(act1),
	    		"target" : parseInt(act2),
	    		"caption" : document.getElementById('sel3').selectedOptions[0].innerText
	    	});
	    	
	    	//couldn't figure out how to add new nodes dynamically
	    	//so deleting the previous graph
	    	var myNode = document.getElementById("alchemy");
			while (myNode.firstChild) {
			    myNode.removeChild(myNode.firstChild);
			}

			alchemy = new Alchemy(config);

			path.push({
				"act1" : parseInt(act1),
				"act2" : parseInt(act2),
				"scene" : parseInt(document.getElementById('sel3').selectedOptions[0].value),
				"score" : parseInt(document.getElementById('sugScore').value)
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
				"class" : obj.class,
				"max_score" : obj.max_score,
				"topic_id" : obj.topic_id,
				"creation_date" : obj.creation_date,
				"level" : obj.level
			});

			sendInfo("gameactivity", "i", null, {
				"game_id" : curGameID,
				"activity_id" : obj.id
			});
    	}
    	activities=[];

    	for(obj of existingActivities){
    		sendInfo("gameactivity", "i", null, {
    			"game_id" : curGameID,
    			"activity_id":obj
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
    			"game_id" : curGameID,
    			"score" : obj.score
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

    	sendInfo("game", "i", null, {
    		"name" : document.getElementById("gameName").value,
    		"icon_link": document.getElementById("gameLink").value,
    		"teacher_id" : "<%out.print(session.getAttribute("id"));%>",
    		"creation_date" : new Date().toJSON().slice(0,10)  
    	});

    	window.location.reload();
    }

</script>

<script type="text/javascript">
    function searchTopic(){
    	var text = document.getElementById('theTopics').value;
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
    			setTopicID();
    		} 
			else{
				theTopicID = parseInt(obj[0].id);
			}
    	}
    }
    function setTopicID(){
    	sendInfo("topic", "i", null, {
    		"name" : document.getElementById("theTopics").value
    	});
    	theTopicID++;
    }
</script>
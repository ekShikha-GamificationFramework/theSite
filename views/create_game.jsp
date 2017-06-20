<%@ page import ="java.sql.*" %>	

<link rel="stylesheet" href="../public/css/alchemy.min.css"/>
<link rel="stylesheet" href="../public/css/vendor.css"/>
<script src="../public/js/d3.v3.min.js"></script>
<script src="../public/js/alchemy.js"></script>
<script src="../public/js/vendor.js"></script>
<script src="../public/js/scripts.js"></script>

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
	<div class="form-group">
		<div id = "actChoose" class="gamifyDiv">
			<button class="btn btn-default" >Create new activity</button><br>or<br><a href="#">Choose from existing ones</a>
		</div>
		<div id="newActivityDiv" class="gamifyDiv">
			<input class="form-control" type="text" id="theName" placeholder="Activity Name"/>
			<input class="form-control" type="text" id="theClass" placeholder="Class"/>
			<input class="form-control" type="text" id="theScore" placeholder="Maximum Score"/>
			<input class="form-control" type="text" id="theIcon" placeholder="Icon Link" id="iconFile"/>
			<input class="form-control" type="text" id="theLink" placeholder="Activity Link" id="activityFile"/>
			<input class="form-control" id="theTopics" list="topics" placeholder="Topic" onkeypress="searchTopic()"/>
			<button class="btn btn-default" onclick="activityAdder()" style="margin-top:10px; margin-bottom:10px">
	        	Add activity
	    	</button>
		</div>

		<div id="existingActivityDiv" class="gamifyDiv">
			<select class="form-control" id="actSelect"><%out.print(s);%></select>
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
    </div>
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

    function activityAdder(){
    	
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
			"id" : newActivityID
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
				"scene" : parseInt(document.getElementById('sel3').selectedOptions[0].value)
			});
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
				"creation_date" : obj.creation_date
			});

			sendInfo("gameactivity", "i", null, {
				"game_id" : curGameID,
				"activity_id" : obj.id
			});
    	}
    	activities=[];
    }

    function sceneUploader(){
    	for(obj of scenes){
    		sendInfo("story_scene", "i", {"name" : obj.name, "link": obj.link});
    	}
    	scenes=[];
    }

    function pathUploader(){
    	for(obj of path){
    		sendInfo("path", "i", {
    			"activity_id_1" : obj.act1,
    			"activity_id_2" : obj.act2,
    			"story_scene_id" : obj.scene,
    			"game_id" : curGameID
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

    	curGameID++;
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
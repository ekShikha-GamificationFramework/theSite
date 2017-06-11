<%@ page import ="java.sql.*" %>

<link rel="stylesheet" href="../public/css/alchemy.min.css"/>
<link rel="stylesheet" href="../public/css/vendor.css"/>
<script src="../public/js/d3.v3.min.js"></script>
<script src="../public/js/alchemy.js"></script>
<script src="../public/js/vendor.js"></script>

<div class="alchemy" id="alchemy" style="height:70vh; width:80vw"></div>

<%
	// ---------------->>>>>>>>>>>>> USE AJAX HERE !!!!!!!!  <<<<<<<<<<<<<<<-----------------
	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root");
	PreparedStatement st = con.prepareStatement("select id, name from activity");
	ResultSet rs=st.executeQuery();
	String s="";
	while(rs.next()){
		s+="<option value="+ rs.getString(1)+">"+ rs.getString(2) +"</option>";
	}
	
%>

<script type="text/javascript">
	var gameMapData = {
		"nodes": [],
		"edges": []
	};

	document.getElementById("middle").style.marginLeft = "250px";
	var config = {
		dataSource: gameMapData,
		forceLocked: false,     
		linkDistance: function(){ return 20; },
		nodeCaption: function(node){ 
			return node.name;
		}
	};

	//the graph
	var alchemy = new Alchemy(config);

</script>

<div class="sidenav">
	<div class="form-group">
		<input class="form-control" type="text" id="theName" placeholder="Activity Name"/>
		<input class="form-control" type="text" id="theClass" placeholder="Class"/>
		<input class="form-control" type="text" id="theScore" placeholder="Maximum Score"/>
		<input class="form-control" type="file" placeholder="Icon File" id="iconFile"/>
		<input class="form-control" type="file" placeholder="Activity File" id="activityFile"/>
		<select class="form-control">
		<%
			st=con.prepareStatement("select * from topic");
			rs=st.executeQuery();
			while(rs.next()){
				out.println("<option value="+ rs.getInt(1)+">"+ rs.getString(2) +"</option>");
			}	
		%>
		</select>
		<br>
		<button class="btn btn-default" onclick="activityUploader()" style="margin-top:10px; margin-bottom:10px">
	        Add activity
	    </button>
	    
	    <input class="form-control" type="text" id="sceneName" placeholder="Scene Name"/>
	    <input class="form-control" type="file" placeholder="Activity File" id="sceneMedia"/>
		<button class="btn btn-default" onclick="sceneUploader()" style="margin-top:10px; margin-bottom:10px">
	        Add scene
	    </button>
	    <br/>
	   

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

	    <br>
	    
	    <button class="btn btn-default" onclick="activityConnector()" style="margin-top:10px; margin-bottom:10px">
	        Connect
	    </button>
    </div>
</div>

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

<script type="text/javascript">
	//add this to script.js
	//or maybe not
    function activityUploader(){
    	var a = document.createElement("option");
    	var b = document.createElement("option");

    	a.text=b.text=document.getElementById("theName").value;
    	a.value=b.value=newActivityID;

    	document.getElementById("sel1").appendChild(a);
    	document.getElementById("sel2").appendChild(b);
    	
    	gameMapData.nodes.push({
    		"id" : newActivityID,
    		"name" : document.getElementById("theName").value
    	});

    	newActivityID++;
    	var myNode = document.getElementById("alchemy");
		while (myNode.firstChild) {
		    myNode.removeChild(myNode.firstChild);
		}

		alchemy = new Alchemy(config);
    }

    function sceneUploader(){
    	var a = document.createElement("option");
    	a.value=newSceneID;
    	a.text=document.getElementById("sceneName").value;
    	document.getElementById("sel3").appendChild(a);
   
    	newSceneID++;

    	// sendInfo("story_scene", {"name" : })
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
    	}    	
    }

	var request;  

	//dict has all the table row values
	function sendInfo(table, dict){  
		var url="index.jsp?val="+v;  

		if(window.XMLHttpRequest){  
			request=new XMLHttpRequest();  
		}  
		else if(window.ActiveXObject){  
			request=new ActiveXObject("Microsoft.XMLHTTP");  
		}  

		try{  
			// request.onreadystatechange=getInfo;  
			request.open("GET", url, true);  
			request.send();  
		}
		catch(e){
			alert("Unable to connect to server");
		}  
	}  

</script>
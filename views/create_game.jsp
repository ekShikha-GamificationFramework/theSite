<%@ page import ="java.sql.*" %>

<link rel="stylesheet" href="../public/css/alchemy.min.css"/>
<link rel="stylesheet" href="../public/css/vendor.css"/>
<script src="../public/js/d3.v3.min.js"></script>
<script src="../public/js/alchemy.min.js"></script>

<script src="../public/js/vendor.js"></script>

<div class="alchemy" id="alchemy" style="height:70vh; width:80vw"></div>


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

	var alchemy = new Alchemy(config);
</script>

<div class="sidenav">
	<input type="text" name="activityName" id="thename" placeholder="Activity Name"/>
	<input type="file" placeholder="Activity File" id="activityFile"/>
	<button class="btn btn-default" onclick="activityUploader()">
        Add activity
    </button>
    
    <input type="file" placeholder="Activity File" id="sceneMedia"/>
	<input type="text" id="sceneText" placeholder="Scene Text"/>
	<button class="btn btn-default" onclick="sceneUploader()">
        Add scene
    </button>
    <br/>
    
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
	<span style="color:white">Activity #1</span>
    <select id="sel1">
    	<% out.println(s); %>
    </select>
    <br>
    <span style="color:white">Activity #2</span>
    <select id="sel2">
    	<% out.println(s); %>
    </select>
    <br>
    <span style="color:white">Connecting Scene</span>
    <select id="sel3">
    	<%
    	st=con.prepareStatement("select id, name from story_scene");
    	rs=st.executeQuery();
    	while(rs.next()){
    		out.println("<option value="+rs.getInt(1)+">"+rs.getString(2)+"</option>");
    	}
    	%>
    </select>
    <br>
    <button class="btn btn-default" onclick="activityConnector()">
        Connect
    </button>
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

<script type="text/javascript">
	//add this to script.js
	//or maybe not
    function activityUploader(){
    	var a = document.createElement("option");
    	var b = document.createElement("option");
    	a.innerHTML=b.innerHTML=document.getElementById("thename").value;
    	document.getElementById("sel1").appendChild(a);
    	document.getElementById("sel2").appendChild(b);
    	
    	gameMapData.nodes.push({
    		"id" : newActivityID,
    		"name" : document.getElementById("thename").value
    	});
    	newActivityID++;
    	alchemy = new Alchemy(config);
    }
</script>
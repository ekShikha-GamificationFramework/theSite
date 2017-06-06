<%@ page import ="java.sql.*" %>

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
	PreparedStatement st = con.prepareStatement("select id, name from teacher");
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
    <button class="btn btn-default" onclick="activityConnector()">
        Connect
    </button>
</div>

<script type="text/javascript">
	//add this to script.js
    function activityUploader(){
    	var a = document.createElement("option");
    	a.innerHTML=document.getElementById;
    	document.getElementById("sel1").appendChild();
    }
</script>

<%
	out.println("<h1>hello, my dudeshello, my dudeshello, my dudeshello, my dudeshello, my dudeshello, my dudeshello, my dudes</h1>");
%>
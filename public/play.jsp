<%@ page import="java.sql.*" %>
<link rel="stylesheet" href="../public/css/styles.css"/>

<script type="text/javascript">
	var fetchedGameMapData = {
		"nodes": [],
		"edges": []
	};

	var config = {
		dataSource: fetchedGameMapData,
		forceLocked: false,     
		linkDistance: function(){ return 20; },
		nodeCaption: function(node){ 
			return node.name;
		}
	};
	
</script>

<link rel="stylesheet" href="../public/css/alchemy.min.css"/>
<link rel="stylesheet" href="../public/css/vendor.css"/>
<script src="../public/js/d3.v3.min.js"></script>
<script src="../public/js/alchemy.js"></script>
<script src="../public/js/vendor.js"></script>

<%
	if(request.getParameter("id")==null){
		response.sendRedirect("index.jsp");
	}

	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root");
	PreparedStatement st = con.prepareStatement("select activity_id, activity.name from gameactivity, activity where gameactivity.game_id=? and activity.id=gameactivity.activity_id");	//nodes
	st.setInt(1, Integer.parseInt(request.getParameter("id")));
	ResultSet rs=st.executeQuery();
	if(rs.next()==false){
	%>
		<jsp:include page = "../views/header.jsp" flush = "true">
			<jsp:param name="title" value="Play!" />
		</jsp:include>
		<jsp:include page = "../views/apology.jsp" flush = "true" >
			<jsp:param name="message" value="We don't have that game yet!" />
		</jsp:include>	
		<jsp:include page = "../views/footer.jsp" flush = "true" />
	<%
	}
	else{%>
	<div class="alchemy" id="alchemy" style="height:70vh; width:80vw"></div>
	<script type="text/javascript"><%
		Boolean f = true;
		while(f){%>
			fetchedGameMapData.nodes.push({
				"id" : "<%out.print(rs.getInt(1));%>",
				"name" : "<%out.print(rs.getString(2));%>"
			});
			<%
			f=rs.next();
		}
		st = con.prepareStatement("select activity_id_1, activity_id_2, story_scene.name from path, game, story_scene where game.id=? and story_scene.id=story_scene_id");	//nodes
		st.setInt(1, Integer.parseInt(request.getParameter("id")));
		rs=st.executeQuery();
		while(rs.next()){%>
			fetchedGameMapData.edges.push({
				"source" : "<%out.print(rs.getInt(1));%>",
				"target" : "<%out.print(rs.getInt(2));%>",
				"caption" : "<%out.print(rs.getString(3));%>"
			});
			var alchemy = new Alchemy(config);
		<%}
	}
	%>
	</script>
%>

<div class="sidenav">

</div>
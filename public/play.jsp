<%@ page import="java.sql.*" %>
<link rel="stylesheet" href="../public/css/styles.css"/>

<script type="text/javascript">
	var fetchedGameMapData = {
		"nodes": [],
		"edges": []
	};
</script>

<%
	if(request.getParameter("id")==null){
		response.sendRedirect("index.jsp");
	}

	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root");
	PreparedStatement st = con.prepareStatement("select activity_id_1, activity_id_2, story_scene_id from game where id=?");
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

		<div style="height:97vh; width:80vw; background-color: black; margin-top:0 auto; margin-left: 18vw" id="gameSpace">
			<object type="text/html" data<% out.println("="+rs.getString(1)); %> style="height:97vh; width:80vw; margin:0 auto;">
		    </object>
		</div>

	<%}
%>

<div class="sidenav">

</div>
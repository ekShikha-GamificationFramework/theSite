<%@ page import="java.sql.*" %>

<jsp:include page = "../views/header.jsp" flush = "true">
	<jsp:param name="title" value="Play!" />
</jsp:include>

<%
	if(request.getParameter("id")==null){
		response.sendRedirect("index.jsp");
	}

	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root");
	PreparedStatement st = con.prepareStatement("select program_link from activity where id=?");
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

		<div style="height:75vh; width:80vw; background-color: black; margin:0 auto;" id="gameSpace">
			<object type="text/html" data<% out.println("="+rs.getString(1)); %> style="height:75vh; width:80vw; margin:0 auto;">
		    </object>
		</div>

	<%}
%>


<jsp:include page = "../views/footer.jsp" flush = "true" /> 
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>

<%
	try{
		Class.forName("com.mysql.jdbc.Driver"); 
		java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamification","archit","archit123"); 
	
		PreparedStatement st = con.prepareStatement("select * from game");
		ResultSet rs=st.executeQuery();
		while(rs.next()){
			out.println("<div class=\"games\"><a href=play.jsp?id="+rs.getString(1)+"><img width=200px height=200px src="+rs.getString(3)+"></img></a>");
			out.println(rs.getString(2)+" by "+rs.getString(4)+"</div>");
		} 
		con.close();
	}
	catch(Exception e){
		out.println(e);
	}
%>

<div class="sidenav"></div>
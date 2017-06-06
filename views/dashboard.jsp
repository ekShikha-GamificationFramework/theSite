<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>

<%
	try{
		Class.forName("com.mysql.jdbc.Driver"); 
		java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root"); 
	
		PreparedStatement st = con.prepareStatement("select * from game");
		ResultSet rs=st.executeQuery();
		while(rs.next()){
			out.println(rs.getString(1)+" "+rs.getString(2)+" "+rs.getString(3)+" "+rs.getString(4)+"<br>");
		} 
		con.close();
	}
	catch(Exception e){
		out.println(e);
	}
%>
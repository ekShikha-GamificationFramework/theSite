<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>

<%
Class.forName("com.mysql.jdbc.Driver");
%> 

<%!
	public java.sql.Connection getCon(String db, String usr, String pass){
		return DriverManager.getConnection("jdbc:mysql://localhost:3306/"+db, usr, pass);
	}  
%>
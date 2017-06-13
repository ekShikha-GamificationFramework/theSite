<%@ page import="java.sql.*" %>
<%@ page import = "java.util.Map" %>

<%
// insert
if(request.getParameter("type").equals("i")){
	String s1 = "insert into "+request.getParameter("table")+"(";
	String s2 = ") values (";
	Map<String, String[]> parameters = request.getParameterMap();
	for(String parameter : parameters.keySet()) {
		if(parameter.equals("type") || parameter.equals("table")){
			continue;
		}
		s1=s1 + parameter + ",";
		try{  
			int a = Integer.parseInt(parameters.get(parameter)[0]);  
			s2=s2 + a + ",";
		}  
		catch(NumberFormatException nfe){  
			s2=s2 + "\""+parameters.get(parameter)[0]+"\"" + ",";
		}  
	}
	s1=s1.substring(0, s1.length()-1) + s2.substring(0, s2.length()-1) + ")";

	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root");
	out.println(s1);
	PreparedStatement st = con.prepareStatement(s1);
	st.executeUpdate();
	con.close();
}

%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.Map" %>

<%

String s1, s2;
Map<String, String[]> parameters;

Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root");
PreparedStatement st;

// insert
if(request.getParameter("type").equals("i")){
	s1 = "insert into "+request.getParameter("table")+"(";
	s2 = ") values (";
	parameters = request.getParameterMap();
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

	st = con.prepareStatement(s1);
	st.executeUpdate();
	con.close();
}
else if(request.getParameter("type").equals("s")){
	int columns = 0;

	s1 = "select ";
	for(String selection : request.getParameterValues("selections")){
		s1 = s1 + selection+",";
		columns++;
	}
	s2 = " from " + request.getParameter("table") + " where ";
	
	parameters = request.getParameterMap();
	for(String parameter : parameters.keySet()) {
		if(parameter.equals("type") || parameter.equals("table") || parameter.equals("selections")){
			continue;
		}
		s2=s2 + parameter + "=";
		try{  
			int a = Integer.parseInt(parameters.get(parameter)[0]);  
			s2=s2 + a + " and ";
		}  
		catch(NumberFormatException nfe){  
			s2=s2 + "\""+parameters.get(parameter)[0]+"\"" + " and ";
		}  
	}

	st = con.prepareStatement(s1.substring(0, s1.length()-1) + s2.substring(0, s2.length()-4));
	ResultSet rs = st.executeQuery();
	while(rs.next()){
		for(int i = 1; i <= columns; i++){
			out.print(rs.getString(i) +" ");
		}
		out.print("<br>");	
	}
}
%>
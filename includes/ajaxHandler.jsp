<%@ page import="java.sql.*" %>
<%@ page import = "java.util.Map" %>

<%

String s1, s2;
Map<String, String[]> parameters;

Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamification","archit","archit123");
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
	String[] sel = request.getParameterValues("selections");
	int columns = sel.length;
	s1 = "select ";
	for(int i = 0; i < columns; i++){
		s1 = s1 + sel[i]+",";
	}
	s2 = " from " + request.getParameter("table") + " where ";
	
	String[] lhs = request.getParameterValues("lhs");
	String[] operator = request.getParameterValues("operator");
	String[] rhs = request.getParameterValues("rhs");
	int conditions = lhs.length;

	for(int i=0; i<conditions; i++){
		try{  
			s2 = s2 + lhs[i] + " " + operator[i] + " " + Integer.parseInt(rhs[i]) + " and ";
		}  
		catch(NumberFormatException nfe){  
			s2 = s2 + lhs[i] + " " + operator[i] + " \"" + (rhs[i]) + "\" and ";
		}  
	}

	st = con.prepareStatement(s1.substring(0, s1.length()-1) + s2.substring(0, s2.length()-4));
	ResultSet rs = st.executeQuery();

	//send JSON
	s1="[";
	while(rs.next()){
		s1+="{";
		for(int i = 1; i <= columns; i++){
			s1=s1+"\""+sel[i-1]+"\""+":"+"\""+rs.getString(i)+"\"" +",";
		}
		s1=s1.substring(0, s1.length()-1)+"},";
	}
	s1=s1.substring(0, s1.length()-1);
	if(s1.isEmpty()){
		out.print("[]");
	}
	else{
		out.print(s1+"]");
	}
	con.close();
}
else if(request.getParameter("type").equals("u")){
	String[] upd = request.getParameterValues("updates");
	String[] updWith = request.getParameterValues("updateWith");
	int columns = upd.length;
	s1 = "update " + request.getParameter("table") + " set ";
	for(int i = 0; i < columns; i++){
		s1 = s1 + upd[i]+"="+"\""+updWith[i]+"\""+",";
	}
	s2 = " where ";
	
	String[] lhs = request.getParameterValues("lhs");
	String[] operator = request.getParameterValues("operator");
	String[] rhs = request.getParameterValues("rhs");
	int conditions = lhs.length;

	for(int i=0; i<conditions; i++){
		try{  
			s2 = s2 + lhs[i] + " " + operator[i] + " " + Integer.parseInt(rhs[i]) + " and ";
		}  
		catch(NumberFormatException nfe){  
			s2 = s2 + lhs[i] + " " + operator[i] + " \"" + (rhs[i]) + "\" and ";
		}  
	}
	st = con.prepareStatement(s1.substring(0, s1.length()-1) + s2.substring(0, s2.length()-4));
	st.executeUpdate();
}
%>
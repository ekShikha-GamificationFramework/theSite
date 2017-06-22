<%@ page import ="java.sql.*" %>

<%
	if(session.getAttribute("id")!=null){
		response.sendRedirect("index.jsp");
	}
%>

<%
	if("GET".equals(request.getMethod())){%>
		<jsp:include page = "../views/header.jsp" flush = "true">
			<jsp:param name="title" value="Register" />
		</jsp:include>
		<jsp:include page = "../views/register_form.jsp" flush = "true" />
		<jsp:include page = "../views/footer.jsp" flush = "true" /> 
	<%}
	else{
		if(request.getParameter("username").isEmpty() || request.getParameter("password").isEmpty() || request.getParameter("email").isEmpty() || request.getParameter("school").isEmpty() || ( request.getParameter("type").equals("Student") &&  request.getParameter("dob").isEmpty() )){%>
			<jsp:include page = "../views/header.jsp" flush = "true">
				<jsp:param name="title" value="Register" />
			</jsp:include>
			<jsp:include page = "../views/apology.jsp" flush = "true" >
				<jsp:param name="message" value="You are missing something!" />
			</jsp:include>	
			<jsp:include page = "../views/footer.jsp" flush = "true" />
		
		<%}

		else {
			try{
				Class.forName("com.mysql.jdbc.Driver"); 
				java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamification","archit","archit123"); 
				PreparedStatement stmt = con.prepareStatement("select id from school where name = ?");
				stmt.setString(1, request.getParameter("school"));
				ResultSet rs = stmt.executeQuery();
				int schoolID=0;
				if(rs.next()){
					schoolID=rs.getInt(1);
				}
				else{
					stmt=con.prepareStatement("SELECT AUTO_INCREMENT FROM information_schema.tables WHERE table_name = 'school' AND table_schema = DATABASE()");
					rs=stmt.executeQuery();
					rs.next();
					schoolID = rs.getInt(1);
					stmt = con.prepareStatement("insert into school values(?, ?, ?, ?)");
					stmt.setInt(1, schoolID);
					stmt.setString(2, request.getParameter("school"));
					stmt.setString(3, request.getParameter("schoolcity"));
					stmt.setString(4, request.getParameter("schoolstate"));
					stmt.executeUpdate();
				}
				
				PreparedStatement st;
				if(request.getParameter("type").equals("t")){
					st = con.prepareStatement("insert into teacher values(?,?,?,?,?)");
					st.setString(5, request.getParameter("password"));
				}
				else{
					st = con.prepareStatement("insert into student values(?,?,?,?,?,?,?,?)");
					st.setString(5, request.getParameter("class"));
					st.setString(6, request.getParameter("dob"));
					st.setString(7, request.getParameter("password"));
					st.setString(8, "Recaller");
				}
				st.setString(1, request.getParameter("username"));
				st.setString(2, request.getParameter("name"));
				st.setString(3, request.getParameter("email"));
				st.setInt(4, schoolID);
				st.executeUpdate();
				con.close();
				session.setAttribute("id", request.getParameter("username"));
				session.setAttribute("type", request.getParameter("type"));
				response.sendRedirect("index.jsp");
			}
			
			catch(Exception e){
				out.print(e);
			}		
		}
	}
%>
<script type="text/javascript">
	document.getElementById('top').style.marginLeft="0px";
	document.getElementById('middle').style.marginLeft="0px";
	document.getElementById('bottom').style.marginLeft="0px";
</script>
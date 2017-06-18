<%@ page import ="java.sql.*" %>

<%
	if(session.getAttribute("id")!=null){
		response.sendRedirect("index.jsp");
	}
%>

<%
	if("GET".equals(request.getMethod())){%>
		<jsp:include page = "../views/header.jsp" flush = "true">
			<jsp:param name="title" value="Login" />
		</jsp:include>
		<jsp:include page = "../views/register_form.jsp" flush = "true" />
		<jsp:include page = "../views/footer.jsp" flush = "true" /> 
	<%}
	else{
		if(request.getParameter("username").isEmpty() || request.getParameter("password").isEmpty() || request.getParameter("email").isEmpty() || request.getParameter("school").isEmpty() || ( request.getParameter("type").equals("Student") &&  request.getParameter("dob").isEmpty() )){%>
			<jsp:include page = "../views/header.jsp" flush = "true">
				<jsp:param name="title" value="Login" />
			</jsp:include>
			<jsp:include page = "../views/apology.jsp" flush = "true" >
				<jsp:param name="message" value="You are missing something!" />
			</jsp:include>	
			<jsp:include page = "../views/footer.jsp" flush = "true" />
		
		<%}

		else {
			try{
				Class.forName("com.mysql.jdbc.Driver"); 
				java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root"); 
				PreparedStatement stmt = con.prepareStatement("select id from school where name = ?");
				stmt.setString(1, request.getParameter("school"));
				ResultSet rs = stmt.executeQuery();
				int schoolID=0;
				if(rs.next()){
					schoolID=rs.getInt(1);
				}
				else{
					out.println("oops lol");
				}
				PreparedStatement st;
				if(request.getParameter("type").equals("Teacher")){
					st = con.prepareStatement("insert into teacher values(?,?,?,?,?)");
					st.setString(5, request.getParameter("password"));
				}
				else{
					st = con.prepareStatement("insert into student values(?,?,?,?,?,?,?,?)");
					st.setString(5, request.getParameter("class"));
					st.setString(6, request.getParameter("dob"));
					st.setString(7, request.getParameter("password"));
				}
				st.setString(1, request.getParameter("username"));
				st.setString(2, request.getParameter("name"));
				st.setString(3, request.getParameter("email"));
				st.setInt(4, schoolID);
				st.executeUpdate();
				con.close();
				session.setAttribute("id", request.getParameter("username"));

				response.sendRedirect("index.jsp");
			}
			
			catch(Exception e){
			%>
				<jsp:include page = "../views/header.jsp" flush = "true">
					<jsp:param name="title" value="Login" />
				</jsp:include>
				<jsp:include page = "../views/apology.jsp" flush = "true" >
					<jsp:param name="message" value="${e}" />
				</jsp:include>	
				<jsp:include page = "../views/footer.jsp" flush = "true" />
			<%
			}		
		}
	}
%>
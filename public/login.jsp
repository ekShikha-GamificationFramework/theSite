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
		<jsp:include page = "../views/login_form.jsp" flush = "true" />
		<jsp:include page = "../views/footer.jsp" flush = "true" /> 
	<%}
	else{
		if(request.getParameter("username").isEmpty()){%>
			<jsp:include page = "../views/header.jsp" flush = "true">
				<jsp:param name="title" value="Login" />
			</jsp:include>
			<jsp:include page = "../views/apology.jsp" flush = "true" >
				<jsp:param name="message" value="You need to provide the username!" />
			</jsp:include>	
			<jsp:include page = "../views/footer.jsp" flush = "true" />
		
		<%}

		else if(request.getParameter("password").isEmpty()){%>
			<jsp:include page = "../views/header.jsp" flush = "true">
				<jsp:param name="title" value="Login" />
			</jsp:include>
			<jsp:include page = "../views/apology.jsp" flush = "true" >
				<jsp:param name="message" value="You need to provide the password!" />
			</jsp:include>	
			<jsp:include page = "../views/footer.jsp" flush = "true" />
		<%}

		else {
			try{
				Class.forName("com.mysql.jdbc.Driver"); 
				java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/iitb","root","root"); 
				PreparedStatement st = con.prepareStatement("select * from teacher where id = ?");
				st.setString(1, request.getParameter("username"));
				ResultSet rs=st.executeQuery();

				if(rs.next()==true){
					if(((String)request.getParameter("password")).equals(rs.getString(5))){
						session.setAttribute("id", request.getParameter("username"));
						session.setAttribute("type", request.getParameter("type"));
						response.sendRedirect("/gamification-Site/public/index.jsp");
					}
					else{
					%>
					<jsp:include page = "../views/header.jsp" flush = "true">
						<jsp:param name="title" value="Login" />
					</jsp:include>
					<jsp:include page = "../views/apology.jsp" flush = "true" >
						<jsp:param name="message" value="Wrong Password!" />
					</jsp:include>	
					<jsp:include page = "../views/footer.jsp" flush = "true" />
					<%
					}
				} 
				else{
					%>
					<jsp:include page = "../views/header.jsp" flush = "true">
						<jsp:param name="title" value="Login" />
					</jsp:include>
					<jsp:include page = "../views/apology.jsp" flush = "true" >
						<jsp:param name="message" value="Wrong Username!" />
					</jsp:include>	
					<jsp:include page = "../views/footer.jsp" flush = "true" />
					<%
				}
				con.close();
			}
			catch(Exception e){
				out.println(e);
			}		
		}
	}
%>
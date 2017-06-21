<%
	if(session.getAttribute("id")==null){
		response.sendRedirect("index.jsp");
	}
%>

<jsp:include page = "../views/header.jsp" flush = "true">
	<jsp:param name="title" value="Gamify" />
</jsp:include>
<jsp:include page = "../views/create_game.jsp" flush = "true" />

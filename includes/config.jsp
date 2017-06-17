<%@include file="helpers.jsp"%>

<%
	out.print(getCon("iitb", "root", "root"));
	// String uri = request.getRequestURI();
	// String name = uri.substring(uri.lastIndexOf("/")+1);
	
	// if(name=="login.jsp" || name=="index.jsp" || name=="logout.jsp" || name=="register.jsp"){
	// 	if(session.getAttribute("id")==null)
	// 		redirect("login.jsp");
	// }
%>


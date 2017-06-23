<!DOCTYPE html>
<html>
    <head>
    	<link href="../public/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="../public/css/styles.css" rel="stylesheet"/>

        <% 
        if(request.getParameter("title")!=null)
            out.println("<title>" +request.getParameter("title") + "</title>");
        else
        	out.println("<title>ekShiksha Gamification</title>");
        %>
        
        <script src="../public/js/jquery-1.11.3.min.js"></script>
        <script src="../public/js/scripts.js"></script>
        <script src="../public/js/bootstrap.min.js"></script>
        
    </head>
    <body>
        <div class="container">
            <div id="top">
                <div>
                    <a href="../public/index.jsp"><img alt="Gamification" src="../public/img/logo.png"/></a>
                </div>
                <% if (session.getAttribute("id")!=null && session.getAttribute("type")!=null){ %>
	                
                    <ul class="nav nav-pills">
                        <li><a href="index.jsp">Home</a></li><%
                        if(session.getAttribute("type").equals("t")){%>
                        	<li><a href="gamify.jsp">Gamify</a></li>
                        	<li><a href="stats.jsp">Assess</a></li>
                        <%}
                        else{%>
                        	<li><a href="leaderboard.jsp">Leaderboard</a></li>
                    	<%}
                        %>
                        <li><a href="logout.jsp"><strong>Log Out</strong></a></li>
                    </ul>

                <%}
                else{%>
                    <ul class="nav nav-pills">
                        <li><a href="index.jsp">Home</a></li>
                        <li><a href="login.jsp">Log In</a></li>
                        <li><a href="register.jsp">Register</a></li>
                    </ul>
                <%}
                %>
            </div>
            
            <div id="middle">
            

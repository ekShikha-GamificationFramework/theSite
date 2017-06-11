<!DOCTYPE html>
<html>
    <head>
        <link href="/gamification-Site/public/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="/gamification-Site/public/css/styles.css" rel="stylesheet"/>

        <% 
        if(request.getParameter("title")!=null)
            out.println("<title>" +request.getParameter("title") + "</title>");
        else
        	out.println("<title>ekShiksha Gamification</title>");
        %>

        <script src="/gamification-Site/public/js/jquery-1.11.3.min.js"></script>
        <script src="/gamification-Site/public/js/bootstrap.min.js"></script>
        <script src="/gamification-Site/public/js/scripts.js"></script>

    </head>
    <body>
        <div class="container">
            <div id="top">
                <div>
                    <a href="/gamification-Site/public/index.jsp"><img alt="Gamification" src="/gamification-Site/public/img/logo.png"/></a>
                </div>
                <% if (session.getAttribute("id")!=null){ %>
	                
                    <ul class="nav nav-pills">
                        <li><a href="index.jsp">Home</a></li><%
                        if(session.getAttribute("type").equals("Teacher")){%>
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
                    </ul>
                <%}
                %>
            </div>
            
            <div id="middle">
            <script type="text/javascript">
                document.getElementById("middle").style.marginLeft = "0px";
            </script>
            

            </div>

            <div id="bottom" class="navbar-fixed-bottom">
                Brought to you by <a href="https://github.com/achie27">achie27</a>.
                <%
                    if(session.getAttribute("id")!=null)
                        out.println("<br/> <a href = '../public/password.jsp' > Change Password</a>");
                %>
            </div>

        </div>

    </body>

</html>

            </div>

            <div id="bottom">
                Brought to you by <a href="https://github.com/achie27">achie27</a>.
                <%
                    if(request.getParameter("title")!=null)
                        out.println("<br/> <a href = 'password.php' > Change Password</a>");
                %>
            </div>

        </div>

    </body>

</html>

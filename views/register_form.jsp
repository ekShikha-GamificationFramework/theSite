<form action="../public/register.jsp" method="post">
    <fieldset>
        <div class="form-group">
            <label for="usertype">Register as:</label>
            <select class="form-control" name="type" id="usertype" onchange="change()">
                <option value="t">Teacher</option>
                <option value="s">Student</option>
            </select>
        </div>
        <div class="form-group">
            <input autocomplete="off" autofocus class="form-control" name="username" placeholder="Username" type="text"/>
        </div>
        <div class="form-group">
            <input class="form-control" name="name" placeholder="Name" type="text"/>
        </div>
        <div class="form-group">
            <input class="form-control" name="password" placeholder="Password" type="password"/>
        </div>
        <div class="form-group">
            <input class="form-control" name="email" placeholder="E-mail" type="email"/>
        </div>
        <div class="form-group">
            <input class="form-control" name="school" placeholder="School" type="text"/>
        </div>
        <div class="form-group" id="theClassDiv" style="display: none;">
	        <select class="form-control" id="theClassSel">
	        	<%
	        		int i=1;
	        		for(i=1; i<=12; i++){
	        			out.println("<option value="+i+">Class "+i+"</option>");
	        		}
	        	%>
	        </select>
        </div>
        <div class="form-group" id="dob" style="display: none;">
            <input class="form-control" name="dob" placeholder="Date of Birth" type="date"/>
        </div>
        <div class="form-group">
            <button class="btn btn-default" type="submit">
                <span aria-hidden="true"></span>    
                Register
            </button>
        </div>
    </fieldset>
</form>

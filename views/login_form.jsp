<form action="../public/login.jsp" method="POST">
    <fieldset>
   		<div class="form-group">
            <label for="usertype">Log In as:</label>
            <select class="form-control" name="type" id="usertype">
                <option>Teacher</option>
	            <option>Student</option>
            </select>
        </div>
        <div class="form-group">
            <input autocomplete="off" autofocus class="form-control" name="username" placeholder="Username" type="text"/>
        </div>
        <div class="form-group">
            <input class="form-control" name="password" placeholder="Password" type="password"/>
        </div>

        <div class="form-group">
            <button class="btn btn-default" type="submit">
                <span aria-hidden="true" class="glyphicon glyphicon-log-in"></span>
                Log In
            </button>
        </div>

    </fieldset>
</form>
<div>
    or <a href="../public/register.jsp">register</a> for an account
</div>

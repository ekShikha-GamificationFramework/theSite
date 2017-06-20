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
            <span><b>Credentials</b></span>
            <input class="form-control" name="password" placeholder="Password" type="password"/>
        </div>
        <div class="form-group">
            <input class="form-control" name="name" placeholder="Name" type="text"/>
        </div>
        <div class="form-group">
            <input class="form-control" name="email" placeholder="E-mail" type="email"/>
        </div>
        <div class="form-group">
            <input class="form-control" list="schools" name="school" id="school" placeholder="School" type="text" onchange="searchSchool()" /><br>
            <input class="form-control" name="schoolcity" placeholder="School City" type="text"/><br>
            <input class="form-control" name="schoolstate" placeholder="School State" type="text"/>
        </div>
        <div class="form-group" id="theClassDiv" style="display: none;">
	        <select class="form-control" id="theClassSel" name="class">
	        	<%
	        		int i=1;
	        		for(i=1; i<=12; i++){
	        			out.print("<option value="+i+">Class "+i+"</option>");
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

<datalist id="schools">
	
</datalist>

<script type="text/javascript" src="js/scripts.js"></script>
<script type="text/javascript">
    function searchSchool(){
    	var text = document.getElementById('school').value;
    	sendInfo("school", "s", putSchool, {
    		"selections" : ["name", "city"],
    		"lhs" : ["name"],
    		"operator" : ["like"],
    		"rhs" : ["%25"+text+"%25"]
    	});
    }
    function putSchool(){
    	if(request.readyState==4 && request.status == 200){ 
			var obj = JSON.parse(request.responseText); 
			var s = ""; 
			for(a of obj){
				s+="<option value= \""+ a.name +"\">" + a.city+"</options>";
			}
			document.getElementById("schools").innerHTML=s;
		} 
    }
</script>
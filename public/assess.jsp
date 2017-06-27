<%@ page import ="java.sql.*" %>
<%
	if(session.getAttribute("id")==null){
		response.sendRedirect("index.jsp");
	}
%>
<style type="text/css">
	#msform fieldset:not(:first-of-type) {
		display: block;
	}
	#msform fieldset{
		position: relative;
	}
	.gameImage {
		display: block;
	    max-width: 15vh;
	    max-height: 15vh;
	    width: auto;
	    height: auto;
	}

</style>
<jsp:include page = "../views/header.jsp" flush = "true">
	<jsp:param name="title" value="Gamify" />
</jsp:include>
<!-- <div id="gamesList" style="height: 18vh; overflow: auto; overflow-y: hidden; margin: 0 auto; white-space: nowrap">

</div> -->

<div class="tab">
	<button class="tablinks active" onclick="showData(event, 'game')">Game-Wise</button>
	<button class="tablinks" onclick="showData(event, 'act'); getStudentActivityData();">Activity-Wise</button>
	<button class="tablinks" onclick="showData(event, 'topic'); getStudentTopicData();">Topic-Wise</button>
	<button class="tablinks" onclick="showData(event, 'taxo'); getStudentTaxonomyData();">Taxonomy-Wise</button>
</div>

<div id="game" class="tabcontent" style="display: block">

</div>

<div id="act" class="tabcontent">

</div>

<div id="topic" class="tabcontent">

</div>

<div id="taxo" class="tabcontent">

</div>
<div class="sidenav">
	<datalist id="studs"></datalist>
	<div id="msform">
		<fieldset>
			<input id="studName" list="studs" placeholder="Search a student" onkeypress="searchStudent()"/>
			<input type="button" class="action-button" value="Get Data" style="margin-bottom: -1vh; margin-top: -0.5vh" onclick="getStudentGameData();"/>
		</fieldset>
	</div>
</div>

<script type="text/javascript">
	function searchStudent() {
		sendInfo("student", "s", putStudent, {
    		"selections" : ["name", "id"],
    		"lhs" : ["name"],
    		"operator" : ["like"],
    		"rhs" : ["%25"+document.getElementById('studName').value+"%25"]
    	});
	}
	function putStudent(){
		if(request.readyState==4 && request.status == 200){
			var obj = JSON.parse(request.responseText); 
			var s = ""; 
			for(a of obj){
				s+="<option value= \""+ a.id +"\">" + a.name+"</option>";
			}
			document.getElementById("studs").innerHTML=s;
		}
	}

	function getStudentGameData(){
		var studID = document.getElementById('studName').value;
		sendInfo("gameactivity, stats, game", "s", putStudentGameData, {
			"selections" : ["game.name", "icon_link", "sum(score)", "max(last_played)", "game_id"],
			"lhs" : ["gameactivity.pair_id", "stats.student_id", "game_id"],
			"operator" : ["=", "=", "="],
			"rhs" : ["(stats.pair_id)", studID, "(id)"],
			"extra" : "group by id"
		});		
	}

	function getStudentActivityData(){
		var studID = document.getElementById('studName').value;
		sendInfo("gameactivity, stats, activity", "s", putStudentActivityData, {
			"selections" : ["activity.name", "stats.score", "activity.class", "stats.last_played"],
			"lhs" : ["gameactivity.pair_id", "stats.student_id", "activity.id"],
			"operator" : ["=", "=", "="],
			"rhs" : ["(stats.pair_id)", studID, "(gameactivity.activity_id)"],
			"extra" : "group by id"
		});
	}

	function putStudentGameData(){
		if(request.readyState==4 && request.status == 200){
			var obj = JSON.parse(request.responseText);
			var gamesList = document.getElementById('game');
			if(obj.length==0){
				gamesList.innerHTML="<h3><b>No games played yet.</b></h3>";
			}
			else{
				gamesList.innerHTML = "";
				var table = document.createElement('table');
				var thead = table.createTHead();
				var tbody = table.createTBody();
				var head = thead.insertRow(0);
				var headings = [];
				for(var i=0; i<4; i++){
					headings.push(head.insertCell(i));
				}

				headings[0].innerHTML = "Game Link";
				headings[1].innerHTML = "Game Name";
				headings[2].innerHTML = "Max Score";
				headings[3].innerHTML = 'Last Played';
				table.className= "table table-striped";
				var j = 0;
				for(a of obj){
					var row = tbody.insertRow(j++);
					var cells = [];
					for(var i=0; i<4; i++){
						cells.push(row.insertCell(i));
					}

					cells[0].innerHTML = "<a href='play.jsp?id="+a["game_id"]+"'><img class='gameImage' src="+a.icon_link+"></img></a>";
					cells[1].innerHTML = "<b>"+a["game.name"]+"</b>";
					cells[2].innerHTML = a["sum(score)"];
					cells[3].innerHTML = a["max(last_played)"];
				}
				gamesList.appendChild(table);
			}
		}
	}

	function putStudentActivityData(theID){
		if(request.readyState==4 && request.status == 200){
			var obj = JSON.parse(request.responseText);
			var activityList = document.getElementById('act');
			if(obj.length==0){
				activityList.innerHTML="<h3><b>No games played yet.</b></h3>";
			}
			else{
				activityList.innerHTML = "";
				var table = document.createElement('table');
				var thead = table.createTHead();
				var tbody = table.createTBody();
				var head = thead.insertRow(0);
				var headings = [];
				for(var i=0; i<4; i++){
					headings.push(head.insertCell(i));
				}

				headings[0].innerHTML = "Activity Name";
				headings[1].innerHTML = "Intended Class";
				headings[2].innerHTML = "Max Score";
				headings[3].innerHTML = 'Last Played';
				table.className= "table table-striped";
				var j = 0;
				for(a of obj){
					var row = tbody.insertRow(j++);
					var cells = [];
					for(var i=0; i<4; i++){
						cells.push(row.insertCell(i));
					}

					cells[0].innerHTML = "<b>"+a["activity.name"]+"</b>";
					cells[1].innerHTML = a["activity.class"];
					cells[2].innerHTML = a["stats.score"];
					cells[3].innerHTML = a["stats.last_played"];
				}
				activityList.appendChild(table);
			}
		}
	}

	function showData(evt, cityName) {
	    // Declare all variables
	    var i, tabcontent, tablinks;

	    // Get all elements with class="tabcontent" and hide them
	    tabcontent = document.getElementsByClassName("tabcontent");
	    for (i = 0; i < tabcontent.length; i++) {
	        tabcontent[i].style.display = "none";
	    }

	    // Get all elements with class="tablinks" and remove the class "active"
	    tablinks = document.getElementsByClassName("tablinks");
	    for (i = 0; i < tablinks.length; i++) {
	        tablinks[i].className = tablinks[i].className.replace(" active", "");
	    }

	    // Show the current tab, and add an "active" class to the button that opened the tab
	    document.getElementById(cityName).style.display = "block";
	    evt.currentTarget.className += " active";
	}
</script>

<jsp:include page = "../views/footer.jsp" flush = "true"/> 
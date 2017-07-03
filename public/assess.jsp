<%@ page import ="java.sql.*" %>
<%
	if(session.getAttribute("id")==null || session.getAttribute("type").equals("Student")){
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

<script type="text/javascript" src="../public/js/loader.js"></script>

<div id="game" class="tabcontent" style="display: block">
	<table id="gamesTable" class="table table-striped">
		<thead>
			<tr>
				<td>Game</td>
				<td>Category Completion</td>
				<td>Score Breakdown</td>
			</tr>
		</thead>
	</table>
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
		<fieldset>
			<input id="studName" list="studs" placeholder="Search a student" onkeypress="searchStudent()"/>
			<input type="button" class="action-button" value="Get Data" style="margin-bottom: -1vh; margin-top: -0.5vh" onclick="getStudentGameData();"/>
		</fieldset>
	</div>
</div>

<script type="text/javascript">
google.charts.load('current', {'packages':['corechart']});
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
			var s = "", i=0; 
			for(a of obj){
				s+="<option value= \""+ a.id +"\">" + a.name+"</option>";
				i++;
				if(i>=10)
					break;
			}
			document.getElementById("studs").innerHTML=s;
		}
	}

	function getStudentGameData(){
		var studID = document.getElementById('studName').value;
		sendInfo("gameactivity, gamecategory, category, stats, game", "s", putStudentGameData, {
			"selections" : ["category.name", "max_score", "sum(score)", "game.icon_link", "game.id"],
			"lhs" : ["stats.pair_id", "gamecategory.game_id", "gamecategory.category_id", "gamecategory.category_id", "gamecategory.game_id", "student_id"],
			"operator" : ["=", "=", "=", "=", "=", "="],
			"rhs" : ["(gameactivity.pair_id)","(game.id)", "(category.id)", "(gameactivity.category_id)", "(gameactivity.game_id)", document.getElementById('studName').value],
			"extra" : "group by gameactivity.category_id, game.id"
		});	
	}

	function getStudentActivityData(){
		var studID = document.getElementById('studName').value;
		sendInfo("gameactivity, stats, activity", "s", putStudentActivityData, {
			"selections" : ["activity.name", "sum(stats.score)", "activity.class", "max(stats.last_played)"],
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
				alert("No games played yet.");
			}
			else{
				var table = document.getElementById('gamesTable');
				var tbody = table.createTBody();
				var j =0;
				for(i in obj){
					if(i==0 || obj[i]["game.id"]!=obj[i-1]["game.id"]){
						var row = tbody.insertRow(j++);
						row.id = obj[i]["game.id"];
						var cells = [];
						for(x=0; x<3; x++){
							cells.push(row.insertCell(x));
						}
						cells[0].innerHTML = "<a href='play.jsp?id="+obj[i]["game.id"]+"'><img class='gameImage' src="+obj[i]["game.icon_link"]+"></img></a>";
						cells[1].innerHTML = obj[i]["category.name"]+'<div class="progress"> <div class="progress-bar progress-bar-striped active" role="progressbar"  aria-valuenow="'+(obj[i]["sum(score)"]/obj[i]["max_score"])*100+'" aria-valuemin="0" aria-valuemax="100" style="width:'+(obj[i]["sum(score)"]/obj[i]["max_score"])*100+'%">'+(obj[i]["sum(score)"]/obj[i]["max_score"])*100+'%</div></div>';
					}
					else{
						table.rows[j].cells[1].innerHTML += obj[i]["category.name"]+'<div class="progress">  <div class="progress-bar progress-bar-striped active" role="progressbar"  aria-valuenow="'+(obj[i]["sum(score)"]/obj[i]["max_score"])*100+'" aria-valuemin="0" aria-valuemax="100" style="width:'+(obj[i]["sum(score)"]/obj[i]["max_score"])*100+'%">'+(obj[i]["sum(score)"]/obj[i]["max_score"])*100+'%</div></div>';
					}

					sendInfo("gameactivity, activity, topic, stats", "s", putGameActData, {
						"selections" : ["topic.name", "activity.name", "score", "game_id"],
						"lhs" : ["gameactivity.topic_id", "gameactivity.activity_id", "game_id", "stats.pair_id", "student_id"],
						"operator" : ["=", "=", "=", "=", "="],
						"rhs" : ["(topic.id)", "(activity_id)", obj[i]["game.id"], "(gameactivity.pair_id)", document.getElementById('studName').value]
					});
				}
			}
		}
	}

	function putGameActData() {
		if(request.readyState==4 && request.status == 200){

			var obj = JSON.parse(request.responseText);
			var options = {
				legend : 'none',
				chartArea : {
					width:'90%',
					height:'90%'
				},
				is3D : true
			};

			var info = [["Activity-Topic", "Marks"]];
			for(i in obj){
				info.push([obj[i]["activity.name"]+"-"+obj[i]["topic.name"], parseInt(obj[i]["score"])]);
			}
			console.log(info);
			var data = google.visualization.arrayToDataTable(info);

			var chart = new google.visualization.PieChart((document.getElementById(obj[0]["game_id"]).cells[2]));
	        chart.draw(data, options);
		}
	}

	function putStudentActivityData(theID){
		if(request.readyState==4 && request.status == 200){
			var obj = JSON.parse(request.responseText);
			var activityList = document.getElementById('act');
			if(obj.length==0){
				activityList.innerHTML="<h3><b>Nothing yet.</b></h3>";
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
					cells[2].innerHTML = a["sum(stats.score)"];
					cells[3].innerHTML = a["max(stats.last_played)"];
				}
				activityList.appendChild(table);
			}
		}
	}

	function getStudentTopicData(){
		var studID = document.getElementById('studName').value;
		sendInfo("gameactivity, stats, topic", "s", putStudentTopicData, {
			"selections" : ["topic.name", "sum(stats.score)", "max(last_played)"],
			"lhs" : ["gameactivity.pair_id", "stats.student_id", "topic.id"],
			"operator" : ["=", "=", "=", "="],
			"rhs" : ["(stats.pair_id)", studID, "(gameactivity.topic_id)"],
			"extra" : "group by topic.id"
		});
	}

	function putStudentTopicData(){
		if(request.readyState==4 && request.status == 200){
			var obj = JSON.parse(request.responseText);
			var topicList = document.getElementById('topic');
			if(obj.length==0){
				topicList.innerHTML="<h3><b>Nothing yet.</b></h3>";
			}
			else{
				topicList.innerHTML = "";
				var table = document.createElement('table');
				var thead = table.createTHead();
				var tbody = table.createTBody();
				var head = thead.insertRow(0);
				var headings = [];
				for(var i=0; i<3; i++){
					headings.push(head.insertCell(i));
				}

				headings[0].innerHTML = "Topic Name";
				headings[1].innerHTML = "Score";
				headings[2].innerHTML = "Last Played";
				table.className= "table table-striped";
				var j = 0;
				for(a of obj){
					var row = tbody.insertRow(j++);
					var cells = [];
					for(var i=0; i<3; i++){
						cells.push(row.insertCell(i));
					}

					cells[0].innerHTML = "<b>"+a["topic.name"]+"</b>";
					cells[1].innerHTML = a["sum(stats.score)"];
					cells[2].innerHTML = a["max(last_played)"];
				}
				topicList.appendChild(table);
			}
		}
	}

	function getStudentTaxonomyData(){
		var studID = document.getElementById('studName').value;
		sendInfo("gameactivity, stats, activity", "s", putStudentTaxonomyData, {
			"selections" : ["activity.level", "sum(stats.score)", "max(last_played)"],
			"lhs" : ["gameactivity.pair_id", "stats.student_id", "activity.id"],
			"operator" : ["=", "=", "="],
			"rhs" : ["(stats.pair_id)", studID, "(gameactivity.activity_id)"],
			"extra" : "group by activity.level"
		});
	}

	function putStudentTaxonomyData(){
		if(request.readyState==4 && request.status == 200){
			var obj = JSON.parse(request.responseText);
			var taxonomyList = document.getElementById('taxo');
			if(obj.length==0){
				taxonomyList.innerHTML="<h3><b>Nothing yet.</b></h3>";
			}
			else{
				taxonomyList.innerHTML = "";
				var table = document.createElement('table');
				var thead = table.createTHead();
				var tbody = table.createTBody();
				var head = thead.insertRow(0);
				var headings = [];
				for(var i=0; i<3; i++){
					headings.push(head.insertCell(i));
				}

				headings[0].innerHTML = "Taxonomy Level";
				headings[1].innerHTML = "Score";
				headings[2].innerHTML = "Last Played";
				table.className= "table table-striped";
				var j = 0;
				for(a of obj){
					var row = tbody.insertRow(j++);
					var cells = [];
					for(var i=0; i<3; i++){
						cells.push(row.insertCell(i));
					}

					cells[0].innerHTML = "<b>"+a["activity.level"]+"</b>";
					cells[1].innerHTML = a["sum(stats.score)"];
					cells[2].innerHTML = a["max(last_played)"];
				}
				taxonomyList.appendChild(table);
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
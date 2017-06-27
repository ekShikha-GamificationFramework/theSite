<%@ page import="java.sql.*" %>
<link rel="stylesheet" href="../public/css/styles.css"/>
<link rel="stylesheet" href="../public/css/alchemy.min.css"/>
<link rel="stylesheet" href="../public/css/vendor.css"/>
<script src="../public/js/d3.v3.min.js"></script>
<script src="../public/js/alchemy.js"></script>
<script src="../public/js/vendor.js"></script>
<script src="../public/js/scripts.js"></script>
<style type="text/css">
	#msform fieldset:not(:first-of-type) {
		display: block;
	}
	#msform fieldset{
		position: relative;
	}
	.nav li a{
		padding:0.9vh 1.5vw;
	}
</style>

<head><title>Play!</title></head>

<script type="text/javascript">

	var fetchedGameMapData = {
		"nodes": [],
		"edges": []
	};

	var links = {};
	var iconLinks = {};
	var scoreObject={};

	var config = {
		dataSource: fetchedGameMapData,
		forceLocked: true,     
		linkDistance: function(){ return 25; },
		nodeStyle : {
			"all" : {
				"radius" :20
			}
		},
		nodeClick : function(){
			if(window.clickedNode){
				document.getElementById('alchemy').style.display="none";
				var obj = document.getElementById('activitySpace');
				obj.style.display="block";
				obj.src = links[window.clickedNode];
				document.getElementById('curLevel').style.display="block";
				var img = document.getElementById('actImage');
				img.src=iconLinks[window.clickedNode];
				if(img.src==""){
					img.style.height="0px";
				}
				for(a of fetchedGameMapData.nodes){
					if(parseInt(a.id)==window.clickedNode){
						document.getElementById('imgText').textContent=a.name;
						break;
					}
				}
			}
		},
		nodeCaption: function(node){ 
			return node.name;
		}
	};

</script>

<%
	if(request.getParameter("id")==null){
		response.sendRedirect("index.jsp");
	}

	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamification","archit","archit123");
	PreparedStatement st = con.prepareStatement("select activity_id, activity.name, activity.program_link, activity.icon_link from gameactivity, activity where gameactivity.game_id=? and activity.id=gameactivity.activity_id");	//nodes
	st.setInt(1, Integer.parseInt(request.getParameter("id")));
	ResultSet rs=st.executeQuery();
	if(rs.next()==false){
	%>
		<jsp:include page = "../views/header.jsp" flush = "true">
			<jsp:param name="title" value="Play!" />
		</jsp:include>
		<jsp:include page = "../views/apology.jsp" flush = "true" >
			<jsp:param name="message" value="We don't have that game yet!" />
		</jsp:include>	
		<jsp:include page = "../views/footer.jsp" flush = "true" />
	<%
	}
	else{%>
	<iframe id="activitySpace" type="text/html" style="background: #000000;height:95vh; width:80vw; margin-left:20vw;"></iframe>
	<div class="alchemy" id="alchemy"></div>
	
	<script type="text/javascript"><%
		Boolean f = true;
		while(f){%>
			fetchedGameMapData.nodes.push({
				"id" : "<%out.print(rs.getInt(1));%>",
				"name" : "<%out.print(rs.getString(2));%>"
			});
			links[parseInt("<%out.print(rs.getInt(1));%>")] = "<%out.print(rs.getString(3));%>";
			iconLinks[parseInt("<%out.print(rs.getInt(1));%>")] = "<%out.print(rs.getString(4));%>";
			<%
			f=rs.next();
		}
		st = con.prepareStatement("select activity_id_1, activity_id_2, story_scene.name from path, game, story_scene where game.id=? and story_scene.id=story_scene_id");	//nodes
		st.setInt(1, Integer.parseInt(request.getParameter("id")));
		rs=st.executeQuery();
		while(rs.next()){%>
			fetchedGameMapData.edges.push({
				"source" : "<%out.print(rs.getInt(1));%>",
				"target" : "<%out.print(rs.getInt(2));%>",
				"caption" : "<%out.print(rs.getString(3));%>"
			});
		<%}%>
		var alchemy = new Alchemy(config);
		var alchemyDiv = document.getElementById('alchemy');
		alchemyDiv.style.width = "80vw";
		alchemyDiv.style.height = "95vh";
		alchemyDiv.style.marginLeft = "20vw";
		document.getElementById('activitySpace').style.display="none";

		window.addEventListener('message', function(evt) {
			scoreObject.score = evt.data;
			var userID = "<%out.print(session.getAttribute("id"));%>";
			var userType = "<%out.print(session.getAttribute("type"));%>";

			//save only when a student is playing
			if(userID!="null" && userType=="s"){
				sendInfo('gameactivity', 's', getPairID, {
					"selections" : ['pair_id'],
					"lhs" : ['game_id', 'activity_id'],
					"operator" : ['=', '='],
					"rhs" : ["<%out.print(request.getParameter("id"));%>", window.clickedNode]  
				});
			}
			if(confirm("Game over! You scored "+evt.data+"!\nRetry?")){
				var actSpace = document.getElementById('activitySpace');
				//refresh
				actSpace.src = actSpace.src;
			}		
			else{
				showMap();
			}
		});
		function showMap(){
			var myNode = document.getElementById("alchemy");
			while (myNode.firstChild) {
			    myNode.removeChild(myNode.firstChild);
			}

			alchemy = new Alchemy(config);
			var alchemyDiv = document.getElementById('alchemy');
			alchemyDiv.style.width = "80vw";
			alchemyDiv.style.height = "95vh";
			alchemyDiv.style.marginLeft = "20vw";
			document.getElementById('activitySpace').style.display='none';
			document.getElementById('activitySpace').src=""; 
			document.getElementById('alchemy').style.display='block';
			document.getElementById('curLevel').style.display="none";
		}
		function getStudentDetails(){
			if(request.readyState==4 && request.status == 200){
				var obj = JSON.parse(request.responseText);
	    		if(obj.length==0){
	    			sendInfo('stats', 'i', null, {
	    				"student_id" : "<%out.print(session.getAttribute("id"));%>",
    					"pair_id" : window.curPair,
    					"score" : scoreObject.score,
    					"last_played" : new Date().toJSON().slice(0,10)
	    			});
	    		} 
				else{
					sendInfo("stats", "u", null, {
						"updates" : ["last_played", "score"],
						"updateWith" : [new Date().toJSON().slice(0,10), "greatest(score,"+scoreObject.score+")"],
						"lhs" : ["student_id", "pair_id"],
						"operator" : ["=", "="],
						"rhs" : ["<%out.print(session.getAttribute("id"));%>", window.curPair]
					});
				}
			}
		}

		function getPairID(){
			if(request.readyState==4 && request.status == 200){
				var obj = JSON.parse(request.responseText);
				window.curPair = obj[0].pair_id;
    			sendInfo('stats', 's', getStudentDetails, {
    				"selections" : ["student_id"],
    				"lhs" : ["student_id", "pair_id"],
    				"operator" : ["=", "="],
    				"rhs" : ["<%out.print(session.getAttribute("id"));%>", obj[0].pair_id]
    			});
			}
		}
		</script>
		<div style="margin-left: 20vw">
			<ul class="nav nav-pills">
			    <li><a href="index.jsp">Home</a></li>
			    <li><a href="#">Dummy</a></li>
			</ul>
		</div>
		<div class="sidenav">
			<div id="msform">
				<fieldset>
					<div style="width: 40%; display: inline; float: left">
						<button class="btn btn-default" style="margin-left:-1vw;padding: 5vh 2.5vw" onclick="showMap()">Map</button>
					</div>
					<div style="width: 60%; display: inline; float: left">
						<span class="form-control" style="margin-top: 2.5vh;background-color:#f54747;color:#fff"><b>Now Playing</b></span>
						<%
							st = con.prepareStatement("select name from game where id = ?");
							st.setInt(1, Integer.parseInt(request.getParameter("id")));
							rs = st.executeQuery();
							rs.next();
						%>
						<span><b><%out.print(rs.getString(1));%></b></span>
					</div>
				</fieldset>
				<br>
				<fieldset>
					<h4><b><font color="#68b9fe">Top Scorers</font></b></h4>
					<%
						st = con.prepareStatement("select stats.student_id, sum(stats.score) from gameactivity, stats where game_id=? and gameactivity.pair_id=stats.pair_id group by stats.student_id order by sum(stats.score) desc");
						st.setInt(1, Integer.parseInt(request.getParameter("id")));
						rs = st.executeQuery();
					%>
					<table class="table table-striped">
						<tbody class="fs-subtitle">
							<%
							int i = 1;
							while(rs.next() && i<4){
								out.print("<tr><td>"+i+"</td>"+"<td><b>"+rs.getString(1)+"</b></td>"+"<td>"+rs.getString(2)+"pts"+"</td></tr>");
								i++;
							}
							%>
						</tbody>
					</table>
					<%
						if(session.getAttribute("type")!=null && session.getAttribute("type").equals("s")){
							out.print("<span>You get to be here!</span>");
						}
					%>
				</fieldset>
				<br>
				<fieldset id="curLevel" style="display: none">
					<h4><b><font color="#68b9fe">Current Level</font></b></h4>
					<center>
						<div style="width:80%;">
							<img id="actImage" style="width:100%;" src=""></img>
							<b><span id="imgText"></span></b>
						</div>
					</center>
				</fieldset>
			</div>

		</div>
	<%}
	%>
<%@ page import="java.sql.*" %>

<jsp:include page = "../views/header.jsp" flush = "true">
	<jsp:param name="title" value="Leaderboard"/>
</jsp:include>

<%
	Class.forName("com.mysql.jdbc.Driver"); 
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamification","archit","archit123");
	PreparedStatement st = con.prepareStatement("select stats.student_id, student.name, school.name, sum(stats.score) from school, student, stats where student.id=stats.student_id and school.id=student.school_id group by student.id order by sum(stats.score) desc");
	ResultSet rs = st.executeQuery();
%>
<table class="table table-striped">
	<thead class="">
		<tr>
			<th style="text-align: center;">Rank</th>
			<th style="text-align: center;">Alias</th>
			<th style="text-align: center;">Name</th>
			<th style="text-align: center;">School</th>
			<th style="text-align: center;">Total Score</th>
		</tr>
	</thead>
	<tbody>
		<%
		int i = 1;
		String s = "";
		while(rs.next() && i<=10){
			s+="<tr>";
			s+="<td>"+i+"</td>";
			s+="<td><strong>"+rs.getString(1)+"</strong></td>";
			s+="<td>"+rs.getString(2)+"</td>";
			s+="<td>"+rs.getString(3)+"</td>";
			s+="<td><strong>"+rs.getString(4)+"</strong></td>";
			s+="</tr>";
			i++;
		}
		out.print(s);
		%>
	</tbody>
</table>

<jsp:include page = "../views/footer.jsp" flush = "true"/>
<script type="text/javascript">
	document.getElementById('top').style.marginLeft=0;
	document.getElementById('middle').style.marginLeft=0;
	document.getElementById('bottom').style.marginLeft=0;
</script>
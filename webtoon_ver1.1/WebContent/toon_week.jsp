<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<title>cytoon</title>
<%@include file="main_top.jsp"%>
<%
	Calendar cal = Calendar.getInstance();
	int today_week = cal.get(Calendar.DAY_OF_WEEK)-1;
	String selWeek = request.getParameter("selWeek");

	int writeEnd = 0;
	
	
	if(selWeek == null){
		selWeek = String.valueOf(today_week);
		
	}
	
	if(selWeek.equals("7")){
		writeEnd =1;
	}
	
	
%>
<script type="text/javascript">
$(document).ready(function(){
	
	//월요일이 1 ~ 일요일 0
	var d = new Date();
	var today_week = d.getDay();
	
	//최초 진입 시 실행
	//오늘의 웹툰 목록을 보여줌
	var selWeek= <%=selWeek%>;
		//오늘 날짜에 맞춰 선택
		$('button[name=week]').each(function(i){
			if(i  == today_week){ //배열은 0번 부터 시작
				
				$(this).append('<span class="glyphicon glyphicon-star"></span>');
				
				$('input[name=today_week]').val($(this).val());
				$('input[name=writeEnd]').val(0);
				
			}
		});
		
 	if(selWeek == null){
 		$('button[name=week]').eq(today_week).addClass('active');
	}else{
 			$('button[name=week]').eq(selWeek).addClass('active');;
	}

$('button[name=week]').click(function(){
		var weeks = $('button[name=week]');
		weeks.each(function(){
			weeks.removeClass('active');
		});
		
		$(this).addClass('active');
		$('input[name=today_week]').val($(this).val());

	});
});
</script>
<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt;
		작품 일람
	</b>
</div>

<div class ="content-grid">
	<div class= "well" align="center">
		<button type="button" class="btn btn-outline-danger" name ="week" value="0" onclick="location='toon_week.jsp?selWeek=0'">
			Sunday
		</button>
		<button type="button" class="btn btn-outline-primary" name ="week" value="1" onclick="location='toon_week.jsp?selWeek=1'"><!-- onclick ="toonBiewInList.jsp?week='1'" -->
			Monday
		</button>
		<button type="button" class="btn btn-outline-primary" name ="week" value="2" onclick="location='toon_week.jsp?selWeek=2'">
			Tuesday
		</button>
		<button type="button" class="btn btn-outline-primary" name ="week" value="3" onclick="location='toon_week.jsp?selWeek=3'">
			Wednesday
		</button>
		<button type="button" class="btn btn-outline-primary" name ="week" value="4" onclick="location='toon_week.jsp?selWeek=4'">
			Thursday
		</button>
		<button type="button" class="btn btn-outline-primary" name ="week" value="5" onclick="location='toon_week.jsp?selWeek=5'">
			Friday
		</button>
		<button type="button" class="btn btn-outline-success" name ="week" value="6" onclick="location='toon_week.jsp?selWeek=6'">
			Saturday
		</button>
		<button type="button" class="btn btn-outline-secondary" name ="week" value="7" onclick="location='toon_week.jsp?selWeek=7'">
			완결
		</button>
	</div>

	<input type="hidden" value ="<%=today_week%>" name ="today_week">
	<input type="hidden" value ="<%=selWeek%>" name ="selWeek">

	
	<jsp:include page="toonViewInList.jsp">
		<jsp:param value="<%=selWeek%>" name="selWeek"/>
		<jsp:param value="<%=writeEnd%>" name="writeEnd"/>
	</jsp:include>
	<div style="height:500px"></div>
</div>
<%@include file="main_bottom.jsp" %>
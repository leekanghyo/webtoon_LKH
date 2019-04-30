<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="toon.WriterBean"%>
<%@page import="toon.ContentBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="toon.ToonDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<title>cytoon</title>
<link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.5.0/css/all.css' integrity='sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU' crossorigin='anonymous'>

<%@include file="main_top.jsp"%>
<%
	//작품 번호
	int workNum = Integer.parseInt(request.getParameter("workNum"));
	
	ToonDao toondao = ToonDao.getInstance();
	System.out.println("contextPath :" + request.getContextPath());

	//작품 번호를 토대로 타이틀 정보/ 각화수 정보 획득
	WriterBean wbean = toondao.getWriter(workNum);
	ArrayList<ContentBean> clist = toondao.getContentList(workNum);
	
	//최신화 연결용
	int maxEpisode = toondao.getContentsMaxCount(workNum);
	
	System.out.println("maxEpisode : " + maxEpisode);
	
	String[] weekStr ={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
	wbean.getWriteWeek();
	
	Calendar cal = new GregorianCalendar(Locale.KOREA);
	cal.add(Calendar.DAY_OF_WEEK,7);
	
	SimpleDateFormat sdf = new SimpleDateFormat ("yyyy-MM-dd");

	SimpleDateFormat sdf2 = new SimpleDateFormat ("yyyy-MM-dd E요일");

	String nextWeekDate = sdf2.format(cal.getTime());
	
	//구독중인 툰인지 검사
	boolean islib = toondao.isMyLibrary(memid, workNum);
	
	System.out.println("islib" + islib);
	
	
	
%>
<script type="text/javascript">
	$(document).ready(function(){
		
		var workNum = <%=wbean.getNum()%>;
		var viewMode = <%=wbean.getViewMode()%>;
		var viewChange;

		$('#open_blind').click(function(){
			
			if(viewMode == 0){ //공개중일 때
				var answer = confirm("비공개로 설정하면 순위 및 각 페이지에서 작품이 제외 됩니다.");
				
				if(answer == false){
					return false;
				}
				viewChange = 1; //비공개로 전환
			}else{
				var answer = confirm("공개로 설정하면 순위 및 각 페이지에서 작품이 표시 됩니다.");
				
				if(answer == false){
					return false;
				}
				
				viewChange = 0; //공개로 전환
			}
			$.ajax({
				url: "member/viewModeChangePro.jsp",
				data :({
					viewMode : viewChange,
					workNum : workNum
				}),
				success : function(data){
					if(jQuery.trim(data) == "fail"){
						alert("설정 변경 실패");
					}else{
						location.reload();
					}
				}
			});
		});
		
		$('#writeEnd').click(function(){
			
			var answer =confirm("연재를 종료하면 더 이상 해당 작품을 수정하거나 에피소드를 추가 할 수 없습니다. 연재를 종료할까요?");
			
			if(answer == true){
				$.ajax({
					url : "member/toonComplitePro.jsp",
					data :({
						writeEnd : 1,
						workNum : workNum
					}),
					success : function(data){
						if(jQuery.trim(data) == "fail"){
							alert("요청 실패");
						}else{
							location.reload();
						}
					}
				});
			}
		});
		
		$('#get_library').click(function(){
			var workNum = <%=workNum%>;
			var memId = "<%=memid%>";
			var islib = <%=islib%>;
			
			$.ajax({
				url : "member/toonLibAddDelPro.jsp",
				data:({
					workNum : workNum,
					memId : memId,
					islib : islib
				}),
				success : function(data){
					if(jQuery.trim(data) == "fail"){
						alert("요청 실패");
					}else{
						location.reload();
					}
				}
			});
		});
	});
</script>

<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt;
		<a href="<%=contextPath%>/toon_week.jsp">작품 일람</a> &gt;
		<%=wbean.getWorkName() %>
	</b>
</div>

<div class="webtoon-title-frame">
	<div class="webtoon-title-img">
		<img width="100%" src="<%=contextPath%>/webtoonDB/member/<%=wbean.getWriterId() %>/<%=wbean.getWorkName()%>/<%=wbean.getTitleImage()%>">	
	</div>
</div>
<div class ="content-grid" style="margin-top:0px;">
<h3 class="text-primary"><%=wbean.getWorkName() %></h3>
<h5 class="text-muted"><%=wbean.getWriterName() %></h5>
<h5><%=wbean.getSynop() %></h5>
<hr>
<p>
	<span class="glyphicon glyphicon-star"></span>&nbsp; <font class="text-primary" style="font-weight: bold;"><%=wbean.getLiked() %></font>
</p>
<div class ="row">
	<div class="col-sm-4">
		<b class="text-primary">연재 요일 : </b>
		<%
			switch(wbean.getWriteWeek()){
			case 7: out.print("<b class='text-danger'>" + weekStr[wbean.getWriteWeek()] + "</b>"); break;
			case 6: out.print("<b class='text-success'>" + weekStr[wbean.getWriteWeek()] + "</b>"); break;
			default: out.print("<b class='text-primary'>" + weekStr[wbean.getWriteWeek()] + "</b>");
			}
		%>	
	</div>
	<div class="col-sm-4">
		<b class="text-primary">다음 연재일 : </b>
		<%if(wbean.getWriteEnd() ==1){%>
		<font class="text-danger" style="font-weight: bold;">[연재 종료]</font>
		<%}else{ %>
		<%=nextWeekDate %>
		<%}%>
	</div>
	<%
		if(memid != null && memid.equals(wbean.getWriterId())){
	%>
 	<div class="col-sm-4">
		<input type="button" class="btn btn-success" value="차회 연재" onclick="location='<%=contextPath%>/member/toonNextAdd.jsp?workNum=<%=workNum%>&workName=<%=wbean.getWorkName()%>&writerName=<%=wbean.getWriterName()%>'" <%if(wbean.getWriteEnd() ==1){%>disabled<%} %>>&nbsp;&nbsp;
 		<div class="btn-group">
 			<%if(wbean.getViewMode() == 0) {%>
				<input id="open_blind" type="button" class="btn btn-primary" value="공개 중">
 			<%}else{%>
				<input id="open_blind" type="button" class="btn btn-secondary" value="비 공개 중">
 			<%} %>
			<input id="writeEnd" type="button" class="btn btn-danger" value="연재 종료" <%if(wbean.getWriteEnd() ==1){%>disabled<%}%>>
		</div>
	</div>
	<%}else if(memid != null && !memid.equals("admin")){%>
		<div class="col-sm-4">
			<%if(islib == true) {%>
			<input id="get_library" type="button" class="btn btn-secondary btn-lg btn-block" value="구독 취소">
			<%} else{ %>
			<input id="get_library" type="button" class="btn btn-info btn-lg btn-block" value="구독 하기">
			<%} %>
		</div>
	<%}%>
</div>
<hr>
<%if(maxEpisode > 0) {%>
<div class="row" >
	<div class="col-sm-6" align="center">
		<input type="button" class="btn btn-success btn-block" value="첫 화 보기" onclick="location='<%=contextPath%>/toonEachView.jsp?workName=<%=wbean.getWorkName()%>&workNum=<%=wbean.getNum()%>&episode=1'">
	</div>
	<div class="col-sm-6" align="center">
		<input type="button" class="btn btn-primary btn-block" value="최신 화"  onclick="location='<%=contextPath%>/toonEachView.jsp?workName=<%=wbean.getWorkName()%>&workNum=<%=wbean.getNum()%>&episode=<%=maxEpisode%>'">
	</div>
</div>
<br>
<%}%>
<!--  -->
<%for(ContentBean cbean : clist){
	String[] img = cbean.getUpload_img().split("/=/");
System.out.println(wbean.getWorkName());
System.out.println(cbean.getSubtitle());
%>
<div class="list-group">
	<a href="<%=contextPath%>/toonEachView.jsp?workName=<%=wbean.getWorkName()%>&workNum=<%=cbean.getWorkNum() %>&episode=<%=cbean.getEpisode()%>" class="list-group-item">
		<div class="row">
			<div class="col-sm-2">
				<div class="thumbnail-frame1">
					<div class="thumbnail-img1">
						<img class="img-thumbnail" src="<%=contextPath%>/webtoonDB/member/<%=wbean.getWriterId() %>/<%=wbean.getWorkName()%>/<%=cbean.getEpisode() %>/<%=img[0]%>">
					</div>
				</div>
			</div>		
		<div class="col-sm-10">
			<div class="col-sm-9">
				<b>제 <%=cbean.getEpisode() %> 화 <%if(cbean.getSubtitle() != null){%> <%=cbean.getSubtitle() %><%} %></b>
		  		<%if (cbean.getWtcReply() > 0){%>
		  			<span class="badge badge-primary badge-pill"><%=cbean.getWtcReply()%></span>
		  		<%}%>
		  	</div>
		  	<div class="col-sm-3">
	  		<font style="font-weight: bold;"><%=sdf.format(cbean.getUpload_date()) %><br>
	  		Read : <%=cbean.getWtcReadCount() %></font>
	  	</div>
		  <hr>
		  <%=cbean.getDescript() %>
		</div>
		</div>
	</a>
	
	<%if(memid != null && memid.equals(wbean.getWriterId())){%>
		<div class="row" align="right">
		<%if(cbean.getEpisode() == maxEpisode){%>
			<div class="col-sm-10">
				<input type="button" class="btn btn-info btn-block" value="수정" onclick="location='<%=contextPath%>/member/toonChange.jsp?workNum=<%=cbean.getWorkNum()%>&episode=<%=cbean.getEpisode()%>'">
			</div>
			<div class="col-sm-2">
				<%if(memid != null && memid.equals(wbean.getWriterId())){%>
					<input type="button" class="btn btn-danger btn-block" value="삭제" onclick="location='<%=contextPath%>/member/toonDeletePro.jsp?workNum=<%=cbean.getWorkNum()%>&workName=<%=cbean.getWorkName()%>&writerId=<%=cbean.getWriterId()%>&episode=<%=cbean.getEpisode()%>'">
				<%}%>
			</div>
		<%} else{%>
			<div class="col-sm-12">
				<input type="button" class="btn btn-info btn-block" value="수정" onclick="location='<%=contextPath%>/member/toonChange.jsp?workNum=<%=cbean.getWorkNum()%>&episode=<%=cbean.getEpisode()%>'">
			</div>
		<%}%>
		</div>
	<%}%>
</div>
<%} %>
<!--  -->
<div style="height: 50%"></div>
</div>


<%@include file ="main_bottom.jsp"%>
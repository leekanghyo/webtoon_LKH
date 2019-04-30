<%@page import="java.util.Calendar"%>
<%@page import="toon.WriterBean"%>
<%@page import="toon.ToonDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="member.MemberBean"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<title>cytoon - 회원 관리 페이지</title>
<%@include file="../main_top.jsp" %>

<%	
	System.out.println(bean.getAdddate());
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	String adddate = sdf.format(bean.getAdddate());
	
	//구독 관련 코드
	ArrayList<Integer> myLib  = dao.getAllLibray(memid);
	
	ToonDao toondao = ToonDao.getInstance();
	ArrayList<WriterBean> wlist = new ArrayList<WriterBean>();
	
	if(myLib.size() >0){
		wlist = toondao.getMyLibrary(myLib);	
	}
	
	Calendar cal = Calendar.getInstance();
	int toDayWeek = cal.get(Calendar.DAY_OF_WEEK) -1;
	System.out.println("toDayWeek" + toDayWeek);
	String[] weekStr ={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
	
%>
<script type="text/javascript">
$(document).ready(function() {
    if (location.hash) {
        $("a[href='" + location.hash + "']").tab("show");
    }
    $(document.body).on("click", "a[data-toggle]", function(event) {
        location.hash = this.getAttribute("href");
    });
    
    //구독 취소 기능
	$('#delLibrary').click(function(){
		var workNum = $(this).val();
		var memId = "<%=memid%>";
		var islib = true; //취소시에만 버튼이 활성화 되므로 true로 값 고정
		
		$.ajax({
			url : "toonLibAddDelPro.jsp",
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
$(window).on("popstate", function() {
    var anchor = location.hash || $("a[data-toggle='tab']").first().attr("href");
    $("a[href='" + anchor + "']").tab("show");
});


</script>
<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt; 회원정보
	</b>
</div>

<div class="content-grid" id="content-grid">

	<ul class="nav nav-tabs">
		
		<li class="active"><a data-toggle="tab" href="#profile">Profile</a></li>
		<li><a data-toggle="tab" href="#myToon">My Toon</a></li>
	</ul>

	<div class="tab-content">
		<div id="profile" class="tab-pane fade in active">
			<div class="panel panel-default">
				<div class="panel-heading" style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
					<font class="text-white" style="font-size: x-large;">Profile</font>
				</div>
				<div class="panel-body">
					<div class="row">
						<div class="col-sm-4" align="center" style="padding-top: 50">
							<div class="thumbnail-frame2">

								<img class="thumbnail-img2" src="<%=contextPath%>/webtoonDB/member/<%=memid%>/<%=userimg%>" onerror="this.src='<%=contextPath%>/img/defaultmember.jpg'">
							</div>
						</div>
						<div class="col-sm-8">
							<ul class="list-group list-group-flush">
								<li class="list-group-item">
									<font class="text-primary" style="font-size: xx-large;"><%=nickname%></font>
								</li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4"><b>ID</b></div>
										<div class="col-sm-8"><%=memid%></div>
									</div>
								</li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4"><b>Account Lv.</b></div>
										<div class="col-sm-8"><font color="red"><b>멤버</b></font></div>
									</div>
								</li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4"><b>Sign up</b></div>
										<div class="col-sm-8"><%=adddate%></div>
									</div>
								</li>
							</ul>
							<div align="right">
								<input type="button" class="btn btn-primary" value="회원 정보 수정" onclick="location='<%=contextPath%>/member/profileChange.jsp'">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div> <!--  -->
		<div id="myToon" class="tab-pane fade">
			<div class="panel panel-default">
				<div class="panel-heading" style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
					<font class="text-white" style="font-size: x-large;">My Toon</font>
				</div>
			</div>
			<div class="panel-body">
			<%if(wlist.size() <= 0) {%>
				<div class="panel panel-info">
					<div class= "panel-body">
						<div class="row">
							<div class="col-sm-12">
								<font class="text-primary">구독 정보가 없습니다.</font>
							</div>
						</div>
					</div>
				</div>
			<%} else{%>
				<div class="panel panel-info">
					<div class="panel-heading">
						<div class="row">
							<div class="col-sm-4" align="center">
								<font class="text-primary" style="font-weight: bold;">썸네일</font> 
							</div>
							<div class="col-sm-4" align="center">
								<font class="text-primary" style="font-weight: bold;">타이틀</font>
							</div>
							<div class="col-sm-2" align="center">
								<font class="text-primary" style="font-weight: bold;">연재 요일</font>
							</div>
							<div class="col-sm-2" align="center">
								<font class="text-primary" style="font-weight: bold;">구독</font>
							</div>
						</div>
					</div>
				<%for(WriterBean wbean : wlist) { %>
					<%if (wbean.getViewMode() != 1) {%>
					<div class= "panel-body">
						<div class="row">
							<div class="col-sm-4" align="center">
								<a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=wbean.getNum()%>">
									<img class="rounded" width="200px" src="<%=contextPath%>/webtoonDB/member/<%=wbean.getWriterId() %>/<%=wbean.getWorkName()%>/<%=wbean.getTitleImage() %>">
								</a>
							</div>
							<div class="col-sm-4">
								<a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=wbean.getNum()%>">
									<font class="text-primary" style="font-weight: bold; font-size: large; "><%=wbean.getWorkName() %> </font>
								</a>
								<%if(wbean.getWriteWeek() == toDayWeek ){ %>
								<span class="badge badge-pill badge-primary">today</span>
								<%} %>
							</div>
							<div class="col-sm-2" align="center">
								<font class="text-primary" style="font-weight: bold; font-size: large;"><%=weekStr[wbean.getWriteWeek()] %></font>
							</div>
							<div class="col-sm-2" align="center">
								<button id="delLibrary" type="button" class="btn btn-danger" value="<%=wbean.getNum()%>">구독 취소</button>
							</div>
						</div>
					</div>
			<%}}%> 
				</div>
			<%}%>
			</div>
		</div>
	</div>
<div style="height: 100%"></div>
</div>
<%@include file="../main_bottom.jsp" %>
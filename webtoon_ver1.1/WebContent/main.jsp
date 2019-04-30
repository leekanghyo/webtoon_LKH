<%@page import="toon.WriterBean"%>
<%@page import="toon.ToonDao"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="list.ListDao"%>
<%@page import="list.ListBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<title>cytoon</title>
<%@include file="main_top.jsp"%>
<%
	System.out.println(request.getRequestURL().toString().replace(request.getRequestURI(),""));
	ListDao listdao = ListDao.getInstance();
	int maxNoticeCount = 5; //가장 최신 공지 1~5까지만 출력한다.
	ArrayList<ListBean> list = listdao.getNoticesMain(maxNoticeCount);
	//메인에 뜨는 공지사항의 날짜표시 정보는 시간을 제외
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	Calendar cal = Calendar.getInstance();
	int selWeek = cal.get(Calendar.DAY_OF_WEEK)-1;

	//웹툰 순위 관련
	ToonDao toondao = ToonDao.getInstance();
	
	ArrayList<WriterBean> wlist = toondao.getContentListByRank();
	
	String[] weekStr ={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
%>

<div class="well well-sm" >
	<b>Main</b>
</div>
<div class ="content-grid">


<div id="myCarousel" class="carousel slide" data-ride="carousel">

  <!-- Indicators -->
  <ol class="carousel-indicators">
    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
    <li data-target="#myCarousel" data-slide-to="1"></li>
    <li data-target="#myCarousel" data-slide-to="2"></li>
  </ol>

  <!-- Wrapper for slides -->
  <div class="carousel-inner">
    <div class="item active">
      <img src="<%=contextPath%>/img/main_img1.bmp" alt="main_img1">
    </div>

    <div class="item">
      <img src="<%=contextPath%>/img/main_img2.bmp" alt="main_img2">
    </div>

    <div class="item">
      <img src="<%=contextPath%>/img/main_img3.bmp" alt="main_img3">
    </div>
  </div>

  <!-- Left and right controls -->
  <a class="left carousel-control" href="#myCarousel" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#myCarousel" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right"></span>
    <span class="sr-only">Next</span>
  </a>
</div>

<hr>

    <div class="panel panel-info">
      <div class="panel-heading"><b>Notice</b></div>
      <div class="panel-body">
	      <table class = "table">
			<%
				String personalimg;
				for (ListBean listbean : list){
					String[] pimg = null;
					try{
						pimg = listbean.getImg().split("/=/");
					}catch(NullPointerException e){
						System.out.println("이미지 없는 게시글");
					}
			%>
			<tr>
				<td width="15%" align="center"><font class="text-primary" style="font-weight: bold;"><%=sdf.format(listbean.getReg_date())%></font></td><!--  작성일 -->
				<td width="10%" align="center">
				<font class="text-primary" style="font-weight: bold;">
				<%if(listbean.getListType().equals("main")){ %>
					[메인]
				<%} else{%>
					[게시판]
				<%}%>
				</font>
				</td> <!-- 메인 화면에는 메인에 해당하는 공지사항만 출력됨 -->
				<td width="15%">
					<div class ="thumbnail-frame1">
					<%if (pimg != null){  //이미지가 있는 게시글일 경우 첫번째 업로드한 사진을 대표 사진으로 한다. //없으면 디폴트 사진%>
						<img class="img-thumbnail" src="<%=contextPath%>/webtoonDB/list/notice/<%=listbean.getNum()%>/<%=pimg[0]%>">
					<%}else {%>
						<img class="img-thumbnail" src="<%=contextPath%>/img/wtlogo.jpg">
					<%}%>
					</div>
				</td>
				<td width="70%">
					<a href="<%=contextPath%>/noticeList.jsp?noticeNum=<%=listbean.getNum()%>">
						<font class="text-primary" style="font-weight: bold; font-size: large;">
							<%=listbean.getSubject()%>
						</font>
					</a>
				</td>
				<td width="15%" align="center"><font class="text-primary" style="font-weight: bold;"><%=listbean.getReadcount()%></font></td>
			</tr>
			<%}%>
			<tr align="right">
				<td colspan="5">
					<a href="<%=contextPath%>/noticeList.jsp">
						<font style="font-weight: bold; font-size:large;">more</font>
					</a>
				</td>
			</tr>
		</table>
      </div>
    </div>
    
	<div class="panel panel-info">
		
		<div class="panel-heading"><b>Ranking (1~10)</b></div>
		
		<div class=panel-body>
			<div class="list-group">
				<table class="table table-hover">
					<thead class="thead-dark">
						<tr >
							<th width="15%" style="text-align: center">순위</th>
							<th width="65%" style="text-align: center">제목</th>
							<th width="20%" style="text-align: center">연재 요일</th>
						</tr>
					</thead>
					<%if(wlist.size() <=0){%>
							<tr><td colspan="3"><font class="text-danger">컨텐츠가 없습니다.</font></td></tr>	
					<%}else{
						int rank = 1;
						for(WriterBean wbean : wlist){
					%>
					<tr>
						<td style="text-align: center"><font class="text-primary"><%=rank++%></font></td>
						<td>
							<a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=wbean.getNum()%>">
								<font class="text-primary"><%=wbean.getWorkName() %></font>
							</a>
						</td>
						<td style="text-align: center">
							<font class="text-primary"><%=weekStr[wbean.getWriteWeek()]%></font>
						<% if(wbean.getWriteEnd() == 1){%>
							<font class="text-secondary">[연재 종료]</font>
						<%}%>
						</td>
					</tr>
					<%}}%>
							
				</table>
			</div>
		</div>
	</div>

	<div class="panel panel-info">
		<div class="panel-heading"><b>Today - 오늘 갱신 작품</b></div>
		
		<div class="panel-body">
			<jsp:include page="toonViewInList.jsp">
				<jsp:param value="<%=selWeek%>" name="selWeek"/>
			</jsp:include>
		</div>
		
	</div>
<div style="height: 550"></div>
</div>

<%@include file="main_bottom.jsp" %>	

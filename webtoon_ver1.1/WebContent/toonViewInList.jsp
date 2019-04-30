<%@page import="java.text.SimpleDateFormat"%>
<%@page import="toon.WriterBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="toon.ToonDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%

	String today_week = request.getParameter("today_week");
	String selWeek = request.getParameter("selWeek");
	int writeEnd;
	
	if(request.getParameter("writeEnd") == null){
		writeEnd = 0;
	}else{
		writeEnd = Integer.parseInt(request.getParameter("writeEnd"));
	}
	
	System.out.println("writeEnd" + writeEnd);
	ToonDao toondao = ToonDao.getInstance();
	
	int weekNum = Integer.parseInt(selWeek);
	
	ArrayList<WriterBean> wlist = new ArrayList<WriterBean>();
	
	if(writeEnd != 1){
		wlist = toondao.getWeeklyToon(weekNum);
	}else{
		wlist = toondao.getCompleteToon();		
	}
	
	
	
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	
	String[][] rankArr = {{"4","4","4"},{"gold.png","silver.png","bronze.png"}};

	int arrMax = 3; // 0 ~ 2
	if(wlist.size() < arrMax){
		arrMax = wlist.size();
	}
	
	String contextPath = request.getContextPath();
	
	System.out.println(wlist.size());
%>
<script type="text/javascript" src="<%=contextPath%>/img.js"></script>
<!-- <a href=https://kor.pngtree.com>pngtree.com의 그래픽</a> -->
<br><br>
<%
	if(wlist.size() <= 0){
%>

<div class="jumbotron">
  <h1 class="text-primary">No Contents</h1>
  <p>컨텐츠가 없습니다.</p>
</div>

<%		
	}else{
%>

<div class ="row">
<% for(int i = 0  ; i < arrMax  ; i++){
			WriterBean wbean = wlist.get(i);
			System.out.println("wbean.getWorkName() : " + wbean.getWorkName());
%>
	<div class ="col-sm-<%=rankArr[0][i]%>">
		<a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=wbean.getNum()%>">
		<div class="panel panel-default">
			<div class="panel-body" style="padding:2">
				<div class="thumbnail-frame-toon" style="overflow: hidden">
						<img class="thumbnail-img-toon"  style=" position: relative;" src="<%=contextPath %>/webtoonDB/member/<%=wbean.getWriterId()%>/<%=wbean.getWorkName()%>/<%=wbean.getTitleImage()%> ">
				</div>
			</div>
			<div class="panel-footer" style="background-color: EDC8C0">
				<img width="25px" style="margin-top: -15px"src="<%=contextPath%>/img/<%=rankArr[1][i]%>">
				<font class="" style="font-weight: bold; font-size: medium;"><%=wbean.getWorkName()%></font>
			</div>
		</div>
		</a>
	</div>
<%}
System.out.println("arrMax : " + arrMax);
System.out.println("wlist.size() : " + wlist.size());

%>
</div><!-- 4위 ~ -->
<%if(arrMax < wlist.size()){ %>
	<div class ="row">
	<%for(int i = arrMax ; i < wlist.size()  ; i++){
		WriterBean wbean = wlist.get(i);
		System.out.println("----");
		System.out.println("wbean.getWorkName() : " + wbean.getWorkName());
	 %>
		<div class ="col-sm-3">
			<a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=wbean.getNum()%>">
			<div class="panel panel-default">
				<div class="panel-body" style="padding:2">
					<div class="thumbnail-frame-toon" style="overflow: hidden">
							<img class="thumbnail-img-toon"  style=" position: relative;" src="<%=contextPath %>/webtoonDB/member/<%=wbean.getWriterId()%>/<%=wbean.getWorkName()%>/<%=wbean.getTitleImage()%> ">
					</div>
				</div>
				<div class="panel-footer" style="background-color: C2C4CC">
					<font class="text-primary" style="font-weight: bold; font-size: medium;"><%=wbean.getWorkName()%></font>
				</div>
			</div>
			</a>
		</div>
	<%}%>
	</div>
	<%}%>
<%}%>





<%@page import="list.BoardCategoryBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<title>cytoon - 게시판 목록</title>
<%@include file="main_top.jsp"%>
<%
	ListDao listdao = ListDao.getInstance();
	ArrayList<BoardCategoryBean> list = listdao.getBoardList();
%>
<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt; 게시판 목록
	</b>
</div>
<div class="content-grid" id="content-grid">
	
	<div class="panel panel-primary" style="margin-top: 30px;">
		<div class="panel-heading">
			<b>게시판 목록</b>
		</div>
		<div class ="panel-body" >
			 <div class="list-group">
		 	<%
		 		if(list.size() <=0){
		 	%>
		 		<b class ="listgroup-item">게시판이 없습니다.</b>
		 	<%}else{
		 	for(BoardCategoryBean blbean : list) { System.out.println(blbean.getBoardCategoryName());%>
		  		<a href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=blbean.getBoardCategoryName()%>&boardCategoryNum=<%=blbean.getNum()%>" class="list-group-item"><%=blbean.getBoardCategoryName()%></a>
			<%}}%>
			</div>
		</div>
	</div>
<div style="height: 100%"></div>
</div>
<%@include file="main_bottom.jsp"%>



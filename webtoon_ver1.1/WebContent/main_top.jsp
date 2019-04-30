<%@page import="member.MemberBean"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
	request.setCharacterEncoding("UTF-8");

	String contextPath = request.getContextPath();
	MemberDao dao = MemberDao.getInstance();

	//loginPro에서 가져옴
	String memid = (String) session.getAttribute("memid");
	String mempw = (String) session.getAttribute("mempw");
	
	MemberBean bean = new MemberBean();
	String wtmtype ="";
	String nickname ="";
	String userimg ="";
	
	if(memid != null && mempw != null){
		bean = dao.memberInfo(memid, mempw);
		wtmtype = bean.getWtmtype(); 
 		nickname = bean.getName();
		userimg = bean.getUserimg();
	}
%>

<link href="<%=contextPath %>/css/custom1.css" rel="stylesheet" media="screen">

<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


<script src="<%=contextPath %>/img.js"></script>
</head>
<body>

	<div class="main-top-header navbar-fixed-top" style="postion:fixed">
		<div class="main-top-head-border" style='padding-top: 5px'>
			<a href="<%=contextPath %>/main.jsp">
				<img align="left" height="60" src="<%=contextPath %>/img/wtlogo.jpg">
			</a>			
			
			<div style="padding-top: 0px ;float: none">
			<%if(memid != null) {%>
				<%if(wtmtype.equals("admin")){ %>
						<!-- 관리자 페이지 -->
						<a href="<%=contextPath%>/admin/adminMain.jsp" title="관리자 페이지">
							<img class="rounded"src="<%=contextPath%>/webtoonDB/member/<%=memid %>/<%=userimg%>" height="50px" onerror ="this.src='<%=contextPath%>/img/defaultmember.jpg'">
							<strong>환영합니다. <%=nickname %> (<%=memid %>) 님</strong>
						</a>
					<%}else if(wtmtype.equals("writer")){ %>
						<!-- 작품 관리(작가 페이지) -->
						<a href="<%=contextPath%>/member/writerMain.jsp" title="내 정보">
							<img class="rounded"src="<%=contextPath%>/webtoonDB/member/<%=memid %>/<%=userimg%>" height="50px" onerror ="this.src='<%=contextPath%>/img/defaultmember.jpg'"> &emsp;
							<strong>환영합니다. <%=nickname %> (<%=memid %>) 님</strong>
						</a>
					<%}else{%>
						<a href="<%=contextPath%>/member/memberMain.jsp" title="내 정보">
							<img class="rounded"src="<%=contextPath%>/webtoonDB/member/<%=memid %>/<%=userimg%>" height="50px" onerror ="this.src='<%=contextPath%>/img/defaultmember.jpg'"> &emsp;
							<strong>환영합니다. <%=nickname %> (<%=memid %>) 님</strong>
						</a>
				<%}%>
			<%}%>
			<div class="btn-group">
			<input type="button" class="btn btn-primary" value="작품 일람" onclick="location='<%=contextPath%>/toon_week.jsp'">
			<input type="button" class="btn btn-primary" value="게시판" onclick="location='<%=contextPath%>/boardCategoryList.jsp'">
			</div> &nbsp;&nbsp;&nbsp;&nbsp;
			<div class="btn-group">
			
			<%if(memid == null) {%>
				<input type="button" class="btn btn-primary" value="Login" onclick="location='<%=contextPath%>/login.jsp'">
				<input type="button" class="btn btn-primary" value="회원가입" onclick="location='<%=contextPath%>/member/memberAddCheck.jsp'">
			<%}else{ %>
				<%if(wtmtype.equals("admin")){ %>
					<%-- <input type="button" class="btn btn-primary" value="관리자 페이지" onclick="location='<%=contextPath%>/admin/adminMain.jsp'"> --%>
					
					<div class="btn-group">
					<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">관리자 페이지</button>
				    	<div class="dropdown-menu">
				     	 	<font>
					     	 	<a class="dropdown-item" href="<%=contextPath%>/admin/adminMain.jsp">개인 정보 & 관리자 툴</a><br>
					      		<a class="dropdown-item" href="<%=contextPath%>/noticeList.jsp">공지 사항</a><br>
				    		</font>
				    	</div>
			    	</div>		
					
				<%}else if(wtmtype.equals("writer")){ %>
					<input type="button" class="btn btn-primary" value="내 작품 관리" onclick="location='<%=contextPath%>/member/writerMain.jsp'">			
				<%}else{%>
					<input type="button" class="btn btn-primary" value="내 정보" onclick="location='<%=contextPath%>/member/memberMain.jsp'">
				<%}%>
					<input type="button" class="btn btn-info" value="로그 아웃"onclick="location='<%=contextPath%>/logout.jsp'">
			<%}%>	

			</div>
		</div>
	</div>
</div>
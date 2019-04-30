<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
	HttpSession ss = request.getSession(false);
	if(ss != null){
		session.invalidate();
	}
%>
<script>
	alert("로그아웃 했습니다.");
	location.href="main.jsp";	
</script>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	
	String workName = request.getParameter("workName");
	String workNum = request.getParameter("workNum");
	String episode = request.getParameter("episode");
	
	ListDao listdao = ListDao.getInstance();
	
	int cnt = listdao.deleteReply(num,workName,Integer.parseInt(episode));
	
	String contextPath = request.getContextPath();
	
	String msg;
	if(cnt > 0){
		
		msg = "댓글을 삭제 했습니다.";
	}else{
		msg = "댓글을 삭제에 실패 했습니다.";		
	}
%>
<script type="text/javascript">
	alert("<%=msg%>");
	location.href="<%=contextPath%>/toonEachView.jsp?workName=<%=workName%>&workNum=<%=workNum%>&episode=<%=episode%>";
</script>
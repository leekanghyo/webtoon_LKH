<%@page import="list.ListDao"%>
<%@page import="list.ListBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	
	request.setCharacterEncoding("UTF-8");

	String writerId = request.getParameter("memid");
	String writerName = request.getParameter("nickname");
	String content = request.getParameter("content");
	
	String workName = request.getParameter("workName");
	String workNum = request.getParameter("workNum");
	String episode = request.getParameter("episode");
	
		
	System.out.println(content);
	
	ListDao listdao = ListDao.getInstance();
	
	ListBean lbean = new ListBean();
	
	lbean.setWriterId(writerId);
	lbean.setWriterName(writerName);
	lbean.setListType("toon");
	lbean.setSubject("none"); //덧글, 게시글 구분용. 덧글은 무조건 none 입력
	lbean.setContent(content);
	lbean.setWhatcontents(workName + episode);
	
	String num = listdao.insertList(lbean);
	
	String msg = "";
	if(num != null){
		System.out.println("DB 입력");
		msg ="작성되었습니다.";
	}else{
		msg ="작성 실패";		
	}
	
	String contextPath = request.getContextPath();
	

%>
<script type="text/javascript">
	alert("<%=msg%>");
	location.href="<%=contextPath%>/toonEachView.jsp?workName=<%=workName%>&workNum=<%=workNum%>&episode=<%=episode%>";

</script>








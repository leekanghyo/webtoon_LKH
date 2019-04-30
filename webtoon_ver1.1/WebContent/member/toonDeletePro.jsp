<%@page import="java.io.File"%>
<%@page import="toon.ToonDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	ToonDao toondao = ToonDao.getInstance();
	
	int workNum = Integer.parseInt(request.getParameter("workNum"));
	int episode = Integer.parseInt(request.getParameter("episode"));

	String workName = request.getParameter("workName");
	String writerId = request.getParameter("writerId");
	
	
	//삭제 파일 경로
	String filePath = config.getServletContext().getRealPath("/webtoonDB/member/" + writerId +"/" +  workName + "/" + episode);
	
	//먼저 DB를 제거
	int cnt = toondao.deletToon(workName,episode);
	if(cnt <0){
		System.out.println("DB 삭제 실패");
	}else{
		File file = new File(filePath);
		
		if(file.exists()){
			toondao.FileAllDelete(file);
		}
	}
	
	String contextPath = request.getContextPath() + "/toonEachList.jsp?workNum=" +workNum;
%>
<script type="text/javascript">
	location.href="<%=contextPath%>";

</script>
	
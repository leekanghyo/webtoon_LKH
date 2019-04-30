<%@page import="java.io.File"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	
	String boardCategoryName = request.getParameter("boardCategoryName");
	int boardCategoryNum= Integer.parseInt(request.getParameter("boardCategoryNum"));
	
	
	String filePath = config.getServletContext().getRealPath("/webtoonDB/list/" + boardCategoryName);
	
	File file = new File(filePath);
	
	ListDao listdao = ListDao.getInstance();
	
	//존재하는 파일일 경우 데이터 삭제 메서드 호출
	if(file.exists()){
		listdao.FileAllDelete(file);
	}else{
		System.out.println("삭제할 데이터가 없음");
	}
	
	listdao.boardDB_delete(boardCategoryName,boardCategoryNum);
	
	String contextPath = request.getContextPath() + "/admin/adminMain.jsp";
%>
<script type="text/javascript">
	location.href="<%=contextPath%>";
</script>
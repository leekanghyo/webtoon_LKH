<%@page import="java.io.File"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String boardName = request.getParameter("boardName");
	
	ListDao listdao = ListDao.getInstance();
	
	int cnt = listdao.insertBoardList(boardName);
	
	String contextPath = request.getContextPath();

	String msg;
	
	if (cnt >0){
		msg = "[" + boardName +"] 게시판 생성 생성";
		//게시판 이름이 DB에 올라간  경우
		
		String filePath =config.getServletContext().getRealPath("/webtoonDB/list/" + boardName);
		
		System.out.println("filePath :" + filePath);
		
		//폴더 생성
		File newf = new File(filePath);
		
		//폴더가 없다면 생성
		if(!newf.exists()){
			newf.mkdir();
			System.out.println(boardName +" 폴더 생성 ");
		}	
	}else{
		msg = "[" + boardName +"] 게시판 생성 실패";
	}
	
	
%>
<script type="text/javascript">
	alert("<%=msg%>");
	location.href="<%=contextPath%>/admin/adminMain.jsp";
</script>
<%@page import="java.io.File"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="list.ListDao"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String memId = request.getParameter("memId");
	
	out.println(memId);
	MemberDao memberdao = MemberDao.getInstance();
	
	String filePath = config.getServletContext().getRealPath("/webtoonDB");
	
	
	//먼저 DB를 지운다
	memberdao.deleteMember(memId);
	
	
	//유저가 작성한 게시글 정보 파일 삭제 경로용 (게시판 이름, 게시글 번호)
	ListDao listdao = ListDao.getInstance();
	HashMap<String,Integer> boardData = listdao.getBoardNum(memId);

	Iterator<String> iter = boardData.keySet().iterator();

	
	//게시판 데이터 삭제
	while(iter.hasNext()){
		String boardName = iter.next();
		int boardNum = boardData.get(boardName);
		
		File file = new File(filePath + "\\list\\" +boardName + "\\" + boardNum);
		
		if(file.exists()){
			memberdao.FileAllDelete(file);
		}
	}
	
	File file = new File(filePath + "\\member\\" + memId);
	
	if(file.exists()){
		memberdao.FileAllDelete(file);
	}

	String contextPath = request.getContextPath() + "/admin/adminMain.jsp";
%>
<script type="text/javascript">
	location.href="<%=contextPath%>";
</script>
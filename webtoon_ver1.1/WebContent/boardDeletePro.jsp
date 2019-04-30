<%@page import="java.io.File"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	
	int boardCategoryNum = Integer.parseInt(request.getParameter("boardCategoryNum"));
	String boardCategoryName = request.getParameter("boardCategoryName");
	
	System.out.println("boardCategoryNum" + boardCategoryNum);
	System.out.println("boardCategoryName" + boardCategoryName);
	
	ListDao dao = ListDao.getInstance();
	
	int cnt = dao.deleteList(boardCategoryNum);

	
	String delpath = config.getServletContext().getRealPath("/webtoonDB/list/notice/" + boardCategoryName + "/" + boardCategoryNum);
	//System.out.println("삭제 파일 경로 확인");
	//System.out.println("Path: " + delpath);
	
	//이미지 폴더와 파일도 삭제한다.
	File delf = new File(delpath);
	File[] delflist  = delf.listFiles();
	//System.out.println("delf.isFile()" + delf.isFile());
	
	if(delf.exists()){
		for(int i = 0 ; i < delflist.length ; i ++){
			//System.out.print("대상 파일 : " + delflist[i]);
			delflist[i].delete();
			//System.out.println(" = 삭제");
			
		}
		//System.out.print("대상 폴더 : " + delf.getName());
		delf.delete();
		//System.out.println(" = 삭제");
	}
	String msg;
	
	if (cnt >0){
		msg = "정상적으로 삭제 되었습니다.";
	}else{
		msg = "삭제를 실패했습니다.";
	}
	
	String contextPath = request.getContextPath();
	
%>
<script type="text/javascript">
	alert("<%=msg%>");
	location.href="<%=contextPath%>/boardList.jsp?boardCategoryNum=<%=boardCategoryNum%>&boardCategoryName=<%=boardCategoryName%>";
</script>
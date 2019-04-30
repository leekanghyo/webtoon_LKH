<%@page import="java.io.File"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	
	String[] selDelNum = request.getParameterValues("selDelNum");
for(String noticeNum : selDelNum){
	System.out.println(noticeNum);
}
	ListDao dao = ListDao.getInstance();

	int cnt  = 0;
	for(String noticeNum : selDelNum){
		int num = Integer.parseInt(noticeNum);
		
		String delpath = config.getServletContext().getRealPath("/webtoonDB/list/notice/" + num);
		//폴더와 내부 파일 모두 삭제
		File delf = new File(delpath);
		File[] delflist  = delf.listFiles();
		
		if(delf.exists()){
			for(int i = 0 ; i < delflist.length ; i ++){
				delflist[i].delete();
			}
			delf.delete();
		}	
		cnt += dao.deleteList(num);
		System.out.println("cnt : " + cnt);
	}

	String msg;
	
	if (cnt >0){
		msg = selDelNum.length + "개 중  " + cnt + "개의 리스트를 정상적으로 삭제 되었습니다.";
	}else{
		msg = "삭제를 실패했습니다.";
	}
%>
<script type="text/javascript">
	alert("<%=msg%>");
	location.href="<%=request.getContextPath()%>/noticeList.jsp";
</script>
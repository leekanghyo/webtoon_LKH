<%@page import="member.MemberBean"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	
	String contextPath = request.getContextPath();
	String id = request.getParameter("id");
	String passwd = request.getParameter("passwd");
	
	MemberDao dao = MemberDao.getInstance();
	//회원 정보 색인
	MemberBean bean = dao.memberInfo(id, passwd);
	
	//회원 정보가 있다면
	String viewPage = "";
	System.out.println("a");
	if(bean != null){
		int num = bean.getNum();
		String _id = bean.getId();
		String wtmtype = bean.getWtmtype();
		String name = bean.getName();
		String userimg = bean.getUserimg();
		System.out.println(userimg);

		session.setAttribute("memnum", num);
		session.setAttribute("memid", _id);
		session.setAttribute("mempw", passwd);
		session.setAttribute("wtmtype", wtmtype);
/* 		
		session.setAttribute("nikename",name);
		session.setAttribute("userimg",userimg); */
		//관리자
		if(wtmtype.equals("admin")){
			viewPage = contextPath + "/admin/adminMain.jsp"; 
		
		//작가 회원
		}else if(wtmtype.equals("writer")){
			viewPage = contextPath + "/member/writerMain.jsp";		
		
		//일반 회원
		}else{ 
			viewPage = contextPath + "/main.jsp";
		}
	//미등록 회원
	}else{
		%>
		<script type="text/javascript">
			alert("기입 정보가 다르거나 가입하지 않은 회원입니다.");
			location.href="<%=contextPath%>/main.jsp";
		</script>
		<%
		
	}	
%>	
<script type="text/javascript">
	location.href="<%=viewPage%>";
</script>

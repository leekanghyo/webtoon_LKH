<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userId = request.getParameter("userId").trim();
	
	MemberDao dao = MemberDao.getInstance();
	
	int cnt = dao.searchID(userId);	
	
	System.out.println(userId);
	
	System.out.println("cnt :"+cnt);
		if (cnt == 0){
			out.print("Yes");
		}else{
			out.print("No");		
		}
		
		
%>

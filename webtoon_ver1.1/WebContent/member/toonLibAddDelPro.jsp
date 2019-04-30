<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	String memId = request.getParameter("memId");
	int workNum = Integer.parseInt(request.getParameter("workNum"));
	boolean islib = Boolean.valueOf(request.getParameter("islib"));
	MemberDao memberdao = MemberDao.getInstance();
	int cnt;

	if(islib == true){ //라이브러리를 갖고 있다면 삭제
		cnt = memberdao.delLibrary(memId, workNum);
	}else{ //없다면 추가
		cnt = memberdao.addLibrary(memId, workNum);
	}
	
	if(cnt <0){
		out.print("fail");
	}else{
		out.print("done");
	}
%>
<%@page import="toon.ToonDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	int workNum = Integer.parseInt(request.getParameter("workNum"));
	int writeEnd = Integer.parseInt(request.getParameter("writeEnd"));
	
	ToonDao toondao = ToonDao.getInstance();
	
	int cnt = toondao.setWriteEnd(workNum, writeEnd);
	if(cnt <0){
		out.println("fail");
	}else{
		out.println("done");		
	}
	
%>
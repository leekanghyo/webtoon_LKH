<%@page import="toon.ToonDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	int viewMode = Integer.parseInt(request.getParameter("viewMode"));
	int workNum = Integer.parseInt(request.getParameter("workNum"));
	
	
	ToonDao toondao = ToonDao.getInstance();
	
	int cnt = toondao.changeViewMode(workNum,viewMode);
	
	if(cnt <0){
		out.println("fail");
	}else{
		out.println("done");
	}
	
	
	




%>

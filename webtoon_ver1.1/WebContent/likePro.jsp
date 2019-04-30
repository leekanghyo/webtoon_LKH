<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	String memid = request.getParameter("memid");
	String workName = request.getParameter("workName");
	String workNum = request.getParameter("workNum");
	String episode = request.getParameter("episode");
	
	
	ListDao listdao = ListDao.getInstance();
	
	int count = listdao.likeCheck(memid, workName, episode);
	
	System.out.println("count : " + count);
	
	if(count > 0){
		out.print("already");
	}else{
		listdao.likeAdd(memid, workName, episode);
		out.print("yet");
	}

%>
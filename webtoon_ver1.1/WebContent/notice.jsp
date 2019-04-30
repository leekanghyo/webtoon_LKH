<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="main_top.jsp" %>
<%
	int nPageNum = Integer.parseInt(request.getParameter("nPageNum"));
	String noticePageLv = request.getParameter("nPageNum");
	
	
	if(noticePageLv  == null){
		noticePageLv = "10";
	}
	

	
	
	
%>

<%@include file="main_bottom.jsp" %>
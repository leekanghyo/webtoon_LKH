<%@page import="java.text.SimpleDateFormat"%>
<%@page import="list.ListBean"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	if(request.getParameter("noticeNum") == null){
		return; //페이지 넘버가 넘어오지 않았으면 돌려보냄
	}

	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();

	int noticeNum = Integer.parseInt(request.getParameter("noticeNum"));

	ListDao listdao = ListDao.getInstance();
	
	//조회수
	listdao.readCounting(noticeNum);
	
	ListBean listbean = listdao.getNotice(noticeNum);
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");

	String newcon = listbean.getContent();
	try{
	//이미지 정보들 배열로 분할
	String[] imgArr = listbean.getImg().split("/=/");
	
 	for(int i = 0 ; i < imgArr.length ; i++){
		String stamp = "{img:" + i +"}";
		String stamp2 = "<img height='200' src='" + contextPath +"/webtoonDB/list/notice/" + listbean.getNum() +"/" + imgArr[i] + "'>";
		newcon = newcon.replace(stamp,stamp2); //문자열을 이미지 태그로 치환
		}
	}catch(NullPointerException e){
		System.out.println("Null포인트 익셉션 발생, 이미지 정보가 없을 경우, 위 코드는 넘어간다.");
	}
%>


	<div class="panel panel-default">
  		<div class="panel panel-heading">
  			<%=sdf.format(listbean.getReg_date()) %> &nbsp;
			<%if(listbean.getListType().equals("main")){%>
			[메인]<%}else{%>[게시판]<%}%>&nbsp;&nbsp;
			<%=listbean.getSubject()%>
				<br>Read : <%=listbean.getReadcount() %><br>
				
  		</div>
  		<div class="panel-body" style="height: auto; min-height: 300px">
			<pre style="height: auto; min-height: 300px"><%=newcon %></pre>
		</div>
		<div class="panel-footer">

		</div>
	</div>


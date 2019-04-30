<%-- <%@page import="java.text.SimpleDateFormat"%>
<%@page import="list.ListBean"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="../main_top.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	int noticeNum = Integer.parseInt(request.getParameter("noticeNum"));
	ListDao listdao = ListDao.getInstance();
	
	ListBean listbean = listdao.getNotice(noticeNum);
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");

	String newcon = listbean.getContent();
	try{
	//이미지 정보들 배열로 분할
	String[] imgArr = listbean.getImg().split("/=/");
	
 	for(int i = 0 ; i < imgArr.length ; i++){
		String stamp = "{img:" + i +"}";
		String stamp2 = "<img width='350'src='" + contextPath +"/webtoonDB/list/notice/" + listbean.getNum() +"/" + imgArr[i] + "'>";
		newcon = newcon.replace(stamp,stamp2); //문자열을 이미지 태그로 치환
		//System.out.println("stamp : " + stamp);
		//System.out.println("stamp2 : " + stamp2);
		//System.out.println("stamp2 : " + newcon);
		}
	}catch(NullPointerException e){
		System.out.println("Null포인트 익셉션 발생, 이미지 정보가 없을 경우, 위 코드는 넘어간다.");
	}
%>
	<div class="panel panel-default">
  		<div class="panel-body">
  			<h2><%=sdf.format(listbean.getReg_date()) %> &nbsp;
				<%if(listbean.getListType().equals("main")){%>
				[메인]<%}else{%>[게시판]<%}%>&nbsp;&nbsp;
				<%=listbean.getSubject()%>
				</h2>
				<p style="float: none;" align="right">
					Read : <%=listbean.getReadcount() %><br>
					Like : <%=listbean.getLiked() %>
				</p>
  		</div>
  		<div class="panel-body">
			<pre><%=newcon %></pre>
		</div>
	
	</div>

	<table border =1 width="900">
		<tr>
			<td>Notice</td>
		</tr>
		<tr>
			<!-- 날짜 - 태그 - 제목 조합 -->
			<td>
				<h2><%=sdf.format(listbean.getReg_date()) %> &nbsp;
				<%if(listbean.getListType().equals("main")){%>
				[메인]<%}else{%>[게시판]<%}%>&nbsp;&nbsp;
				<%=listbean.getSubject()%>
				</h2>
				<p style="float: none;" align="right">
					Read : <%=listbean.getReadcount() %><br>
					Like : <%=listbean.getLiked() %>
					
				</p>
			</td>
		</tr>
		<tr>
		
		<td style ="text-align: left; vertical-align: top">
			<pre><%=newcon %></pre>
		</td>
		</tr>
		<tr>
			<td>
				<input type="button" class="btn" value = "Like">
			</td>
		</tr>
	</table>

<div class = "content-Line" ></div>




<%@include file="../main_bottom.jsp" %> --%>
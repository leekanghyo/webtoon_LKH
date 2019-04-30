<%@page import="java.text.SimpleDateFormat"%>
<%@page import="list.ListBean"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	if(request.getParameter("boardCategoryName") == null || request.getParameter("contentNum") == null){
		return; //게시판 이름이나 게시글 번호가 넘어오지 않았으면 돌려보냄
	}

	String memid = (String) session.getAttribute("memid");
	
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	
	//각 게시글 번호
	int contentNum = Integer.parseInt(request.getParameter("contentNum"));
	
	//게시판 이름
	String boardCategoryName = request.getParameter("boardCategoryName");
	String boardCategoryNum = request.getParameter("boardCategoryNum");
	
	ListDao listdao = ListDao.getInstance();
	//조회수
	listdao.readCounting(contentNum);

	ListBean listbean = listdao.getBoardContent(contentNum);
	
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	String newcon = listbean.getContent();
	
	try{
	//이미지 정보들 배열로 분할
	String[] imgArr = listbean.getImg().split("/=/");
	
 	for(int i = 0 ; i < imgArr.length ; i++){
		String stamp = "{img:" + i +"}";
		String stamp2 = "<img height='200' src='" + contextPath +"/webtoonDB/list/"+ boardCategoryName +"/" + listbean.getNum() +"/" + imgArr[i] + "'>";
		newcon = newcon.replace(stamp,stamp2); //문자열을 이미지 태그로 치환
		}
	}catch(NullPointerException e){
		System.out.println("Null포인트 익셉션 발생, 이미지 정보가 없을 경우, 위 코드는 넘어간다.");
	}
%>

<div class="panel panel-default">
	<div class="panel panel-heading">
		<font class="text-primary" style="font-weight: bold; font-size: x-large;">
		<%=sdf.format(listbean.getReg_date()) %> &nbsp;
		[<%=listbean.getWhatcontents()%>]
		&nbsp;&nbsp;
		<%=listbean.getSubject()%>
		</font>
			<hr>
			Writer : <%=listbean.getWriterName()%> (<%=listbean.getWriterId() %>)<br>
			Read : <%=listbean.getReadcount() %><br>
	</div>
	<div class="panel-body" style="height: auto; min-height: 300px">
		<pre style="height: auto; min-height: 300px"><%=newcon %></pre>
	</div>
	<div class="panel-footer" align="center">
		<%if (memid != null && (memid.equals("admin") || listbean.getWriterId().equals(memid))){  System.out.println("listbean.getWriterId() : "  + listbean.getWriterId() + " / " + memid);%>		
			<input type="button" class="btn btn-info" value="수정" onclick ="location='<%=contextPath%>/boardUpdate.jsp?boardNum=<%=listbean.getNum()%>&boardCategoryName=<%=listbean.getWhatcontents()%>&boardCategoryNum=<%=listbean.getNum()%>'">
			<input type="button" class="btn btn btn-danger" value="삭제" onclick="location='<%=contextPath%>/boardDeletePro.jsp?boardCategoryName=<%=listbean.getWhatcontents()%>&boardCategoryNum=<%=listbean.getNum()%>'">
		<%}%>
		
	</div>
</div>


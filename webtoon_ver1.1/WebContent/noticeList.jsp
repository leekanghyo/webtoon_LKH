<%@page import="java.text.SimpleDateFormat"%>
<%@page import="list.ListBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<title>cytoon - notice</title>
<%@include file="main_top.jsp"%>
<link href="<%=contextPath %>/css/custom1.css" rel="stylesheet" media="screen">
<%
	request.setCharacterEncoding("UTF-8");
	String sortMode =request.getParameter("sortMode");

	if(sortMode == null){
		sortMode = "all";
	}
	//사용자가 선택한 한 페이지에 보일 컨텐츠 수
	String viewRow = request.getParameter("viewRow");
	if(viewRow == null){
		viewRow = "10";
	}
	
	//숫자로 변환
	int pageView = Integer.parseInt(viewRow);
	//현재 페이지 Num
	String pageNum =request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	
	//int형으로 변환
	int currentPageNum = Integer.parseInt(pageNum);
	//시작 줄
	int startRow = (currentPageNum - 1) * pageView + 1; //1,11,21
	//끝 줄
	int endRow = startRow + pageView -1;
	
	ListDao listdao = ListDao.getInstance();
	
	//전체 게시글 수 리턴
	int contentAllRow = listdao.getNoticeListCount(sortMode);
	
	//보기 좋게 게시글 번호 정렬에 필요한 변수
	int viewNum = contentAllRow - ((currentPageNum - 1) * pageView);
	// viewNum = 전체 게시글 수 - (현재 페이지 - 1) * 표시 줄 수 
	// = 20 - (2-1) * 10;
	
	ArrayList<ListBean> list = new ArrayList<ListBean>();
	
	if(contentAllRow > 0){
		list = listdao.getAllNoticeFilter(sortMode, startRow,endRow);
	}
	
	SimpleDateFormat sdf = new SimpleDateFormat ("yyyy-MM-dd"); 
	
	String noticeNum = request.getParameter("noticeNum");

%>
<script type="text/javascript">

	function allChkd(){
		chk = document.myform.selDelAll.checked;
		cl = document.getElementsByName("selDelNum");
		
		//전체 체크 해제 및 설정
		if(chk){
			for(i = 0 ; i< cl.length ; i++){
				cl[i].checked = true;
			}
						
		}else{
			for(i = 0 ; i< cl.length ; i++){
				cl[i].checked =false;;
			}
		}
	}
	//선택된 것 삭제
	function chkdDel(){
		cl = document.getElementsByName("selDelNum");
		
		flag = false;
		for(i = 0 ; i< cl.length ; i++){
			if(cl[i].checked){
				flag = true;
			}
		}
		if(!flag){
			alert("하나 이상 선택하세요.")
			return;
		}
		//삭제 폼으로 이동
		document.myform.submit();
	}	
</script>

<div  class="well well-sm" >
	<b>
		<a href="<%=contextPath%>/main.jsp">Main</a> &gt; 공지사항
	</b>
</div>

<div class ="content-grid">
	<br>
	<!-- 뷰 페이지 로드, 없을 경우 생략 -->
	<% if(noticeNum != null) {%>
		<jsp:include page="noticeViewInList.jsp">
			<jsp:param value="<%=noticeNum %>" name="noticeNum"/>
		</jsp:include>
	<%}%>
	<br>

<form name = "myform" method="post" action="<%=contextPath%>/admin/multiDeleteNoticePro.jsp">
   <div class="panel panel-primary">
      <div class="panel-heading">Notice</div>
      <div class="panel-body">
		<div align="left">
			<div style="float: left"><h5 style="font-weight: bold;">PageView: </h5></div>
			<ul class="pagination" style="margin: 0px 0;">
				<li class="page-item">
					<a class="page-link" href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=10&pageNum=1">10</a>
			  	</li>
			  	<li class="page-item">
					<a class="page-link" href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=20&pageNum=1">20</a>
			  	</li>
			  	<li class="page-item">
					<a class="page-link" href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=30&pageNum=1">30</a>
			  	</li>
			  	<li class="page-item">
					<a class="page-link" href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=50&pageNum=1">50</a>
				</li>
			</ul>
			
			<div style="float: right">
				<b>Sort By : </b>
				<div class="btn-group">
					<input type="button" class="btn" value="All" onclick="location.href='<%=contextPath%>/noticeList.jsp?sortMode=all&viewRow=<%=viewRow%>'"> &ensp;
					<input type="button" class="btn" value="Main" onclick="location.href='<%=contextPath%>/noticeList.jsp?sortMode=main&viewRow=<%=viewRow%>'"> &ensp;
					<input type="button" class="btn" value="Boarder" onclick="location.href='<%=contextPath%>/noticeList.jsp?sortMode=board&viewRow=<%=viewRow%>'">
				</div>
			</div>
		</div>
	</div>
	<div class="panel-body">
		<table class = "table table-hover">
		<thead class="thead-dark">
			<tr>
				<%if (wtmtype.equals("admin")){ %>
				<th align="center" width="5%">
					<input type="checkbox" name ="selDelAll" onclick="return allChkd()">
				</th>
				<%} %>
				<th align="center">No.</th>
				<th width="10%" align="center">Type</th>
				<th colspan="2" width="50%" >Title</th>
				<th width="15%">Date</th>
				<th>Read</th>
				<%if (wtmtype.equals("admin")){ %>
				<th width="15%" align="center">Admin Tool</th>
				<%} %>
			</tr>
			</thead>
			<%
			String personalimg;
			if(list.size() <= 0){
			%>
				<tr><td colspan="8" align="center">게시글이 없습니다.</td></tr>
			<%}else{
				for(ListBean listbean : list){
					String[] pimg = null;
					try{
						pimg = listbean.getImg().split("/=/");
						}catch(NullPointerException e){
							System.out.println("이미지 없는 게시글");
						}
				%>
				<tr>
					<%if (wtmtype.equals("admin")){ %>
					<td align="center">
							<input type="checkbox" name ="selDelNum" value="<%=listbean.getNum()%>">
					</td>
					<%}%>
					
					<td align="center"><h4><%=viewNum-- %></h4></td>
					
					<td align="center">
						<%if(listbean.getListType().equals("main")){ %>
							<h4>[메인]</h4>
						<%} else{%>
							<h4>[게시판]</h4>
						<%}%>
					</td>
					<td align="center" width="9%">
						<div class ="thumbnail-frame1">
						<%if (pimg != null){  //이미지가 있는 게시글일 경우 첫번째 업로드한 사진을 대표 사진으로 한다. //없으면 디폴트 사진%>
								<a href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&pageNum=<%=pageNum%>&noticeNum=<%=listbean.getNum()%>&viewRow=<%=viewRow%>%>">
									<img class="img-thumbnail" src="<%=contextPath%>/webtoonDB/list/notice/<%=listbean.getNum()%>/<%=pimg[0]%>">
								</a>
							<%}else {%>
								<a href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&pageNum=<%=pageNum%>&noticeNum=<%=listbean.getNum()%>&viewRow=<%=viewRow%>%>">
							<img class="img-thumbnail" src="<%=contextPath%>/img/wtlogo.jpg">
							</a>
			
						<%}%>
						</div>
					</td>
					<td>					
						<h4><a href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode %>&pageNum=<%=pageNum %>&noticeNum=<%=listbean.getNum() %>&viewRow=<%=viewRow %>%>"><%=listbean.getSubject() %></a></h4>
					</td>
					<td align="center">
						<h4><%=sdf.format(listbean.getReg_date())%></h4>
					</td><!--  작성일 -->
					<td align="center">
						<%=listbean.getReadcount() %>
					</td>
					
					<%if (wtmtype.equals("admin")){ %>
					<td>
						<input type="button" class="btn btn-info" value="수정" onclick ="location='<%=contextPath%>/admin/noticeUpdate.jsp?noticeNum=<%=listbean.getNum()%>'">
						<input type="button" class="btn btn btn-danger" value="삭제" onclick="location='<%=contextPath%>/admin/deleteNoticePro.jsp?noticeNum=<%=listbean.getNum()%>'">
					</td>
					<%}%>
				</tr>
			<%}}%>
		</table>
		</div>
		<div class="panel-footer" align="right">
		<%if (wtmtype.equals("admin")){ %>
			<input type="button" class="btn btn-danger" value ="선택 목록 삭제" onclick ="return chkdDel();">
			<input type="button" class="btn btn-primary" value="공지 작성" onclick="location='<%=contextPath%>/admin/noticeWrite.jsp'">
		<%}%>
		</div>
	</div>
</form>
	<%
		//전체 페이지 갯수를 구함
		int pageCount = contentAllRow / pageView + (contentAllRow%pageView == 0 ? 0 : 1);
		int pagePool = 10; //개씩 페이지를 보여 주겠다.
		
		//시작페이지1,11
		int startPage = ((currentPageNum -1) / pagePool * pagePool) +1;
		//끝 페이지10,20
		int endPage = startPage + pagePool -1 ;
		//만약 표시할 끝 페이지가 전체 페이지 한도 보다 클 경우 최대 표시 할 수 있는 페이지를 엔드 페이지로 하겠다.
		if(endPage > pageCount){ endPage = pageCount; }
	%>
		<div align="center">
			<ul class="pagination">
		
	<%	
		//표시 페이지 수가 10보다 클 경우 이전 버튼 추가
		if(startPage > pagePool){
	%>
			<li class="page-item">
				<a class="page-link" href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=<%=viewRow%>&pageNum=<%=startPage - pagePool%>">
					&laquo;
				</a>
			</li>
<%-- 		<input type="button" value="&laquo;" onclick="location='<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=<%=viewRow%>&pageNum=<%=startPage - pagePool%>'">		 --%>
	<%
		} System.out.println(endPage +" : " + endPage);
		for(int i = startPage ; i <= endPage ; i++){ //1,2,3,4 페이지 수 열거
	%>
		<li class="page-item">
			<a href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=<%=viewRow%>&pageNum=<%=i%>"><%=i%></a>
		</li>
<%-- 	<input type="button" value="<%=i %>" onclick="location='<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=<%=viewRow%>&pageNum=<%=i%>'"> --%>
	<%
		}
		//표시하는 끝 페이지보다 전체 페이지가 더 클 경우, 다음 버튼 추가
		if(endPage < pageCount){
		%>
			<li class="page-item">
				<a class="page-link" href="<%=contextPath%>/noticeList.jsp?sortMode=<%=sortMode%>&viewRow=<%=viewRow%>&pageNum=<%=startPage + pagePool%>">
					&raquo;
				</a>
			</li>
		<%-- <input type="button" value="&raquo;" onclick="location='<%=contextPath%>/noticeList.jsp?pageNum=<%=startPage + pagePool%>'">	 --%>	
		<%
		}
		%>
		</ul>
	</div>
<div style="height: 300"></div>
</div>

<%@include file="main_bottom.jsp"%>

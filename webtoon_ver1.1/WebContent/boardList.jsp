<%@page import="java.text.SimpleDateFormat"%>
<%@page import="list.ListBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<title>cytoon - 게시판 </title>
<%@include file="main_top.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String boardCategoryName = request.getParameter("boardCategoryName");
	String boardCategoryNum = request.getParameter("contentNum");
	
	System.out.println("boardCategoryName :" + boardCategoryName);
	
	String sortMode = request.getParameter("sortMode");
	
	if(sortMode == null){
		sortMode ="all";
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
	int contentAllRow = listdao.getBoardCount(sortMode,boardCategoryName);
	
	//보기 좋게 게시글 번호 정렬에 필요한 변수
	int viewNum = contentAllRow - ((currentPageNum - 1) * pageView);
	// viewNum = 전체 게시글 수 - (현재 페이지 - 1) * 표시 줄 수 
	// = 20 - (2-1) * 10;
	
	ArrayList<ListBean> list = new ArrayList<ListBean>();
	
	if(contentAllRow > 0){
		list = listdao.getAllBoardContentFilter(sortMode,boardCategoryName,startRow,endRow);
	}
	
	SimpleDateFormat sdf = new SimpleDateFormat ("yyyy-MM-dd"); 
	
	//각 게시글 번호
	String contentNum = request.getParameter("contentNum");
	
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


<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt;
		<a href="<%=contextPath%>/boardCategoryList.jsp">게시판 목록</a>
		&gt; <%=boardCategoryName%>
	</b>
</div>
<div class="content-grid" id="content-grid">
	<!-- 뷰 페이지 로드, 없을 경우 생략 -->
	<% if(boardCategoryName != null && contentNum != null) {%>
		<jsp:include page="boardViewInList.jsp">
			<jsp:param value="<%=boardCategoryName %>" name="boardCategoryName"/>
			<jsp:param value="<%=contentNum %>" name="contentNum"/>
		</jsp:include>
	<%}%>
<br>

<form name = "myform" method="post" action="<%=contextPath%>/admin/multiDeleteNoticePro.jsp">
   <div class="panel panel-primary">
      <div class="panel-heading"><%=boardCategoryName %></div>
      <div class="panel-body">
		<div align="left">
			<div style="float: left"><h5 style="font-weight: bold;">PageView: </h5></div>
			<ul class="pagination" style="margin: 0px 0;">
				<li class="page-item">
					<a class="page-link" href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&viewRow=10&sortMode=<%=sortMode%>&pageNum=1">10</a>
			  	</li>
			  	<li class="page-item">
					<a class="page-link" href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&viewRow=20&sortMode=<%=sortMode%>&pageNum=1">20</a>
			  	</li>
			  	<li class="page-item">
					<a class="page-link" href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&viewRow=30&sortMode=<%=sortMode%>&pageNum=1">30</a>
			  	</li>
			  	<li class="page-item">
					<a class="page-link" href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&viewRow=50&sortMode=<%=sortMode%>&pageNum=1">50</a>
				</li>
			</ul>
			
			<div style="float: right">
				<div class="btn-group">
					<input type="button" class="btn" value="All" onclick="location.href='<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&sortMode=all&viewRow=<%=viewRow%>'">
					<input type="button" class="btn" value="내가 쓴 글" onclick="location.href='<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&sortMode=<%=memid%>&viewRow=<%=viewRow%>'" <%if(memid == null){%>disabled<%} %>>
				</div>
			</div>
		</div>
	</div>
	<div class="panel-body">
		<table class = "table table-hover">
			<thead class="thead-dark">
				<tr>
					<th align="center" width="5%">
						<input type="checkbox" name ="selDelAll" onclick="return allChkd()">
					</th>
					<th align="center">No.</th>
					<th align="center">Writer</th>
					<th width="50%" align="center">Title</th>
					<th width="15%" align="center">Date</th>
					<th align="center">Read</th>
					<%if (wtmtype.equals("admin")){ %>
					<th width="15%" align="center">Admin Tool</th>
					<%} %>
				</tr>
			</thead>
			<%
			if(list.size() <= 0){
			%>
				<tr><td colspan="8" align="center">게시글이 없습니다.</td></tr>
			<%}else{
				for(ListBean listbean : list){
				%>
				<tr>
					<td align="center">
						<input type="checkbox" name ="selDelNum" value="<%=listbean.getNum()%>">

					</td>
					<td><%=viewNum-- %></td>
					<td><%=listbean.getWriterName()%><br>(<%=listbean.getWriterId() %>)</td>
					<td>
					<a href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&pageNum=<%=pageNum %>&contentNum=<%=listbean.getNum() %>&viewRow=<%=viewRow %>"><%=listbean.getSubject() %></a></td>
					<td align="center"><%=sdf.format(listbean.getReg_date())%></td><!--  작성일 -->
					<td><%=listbean.getReadcount() %></td>
					<!-- 관리자의 경우, 게시글 외부에서 삭제 가능 -->
					<%if (wtmtype.equals("admin")){ %>
					<td>
						<input type="button" class="btn btn-info" value="수정" onclick ="location='<%=contextPath%>/boardUpdate.jsp?boardNum=<%=listbean.getNum()%>&boardCategoryName=<%=listbean.getWhatcontents()%>&boardCategoryNum=<%=listbean.getNum()%>'">
						<input type="button" class="btn btn btn-danger" value="삭제" onclick="location='<%=contextPath%>/boardDeletePro.jsp?boardCategoryName=<%=listbean.getWhatcontents()%>&boardCategoryNum=<%=listbean.getNum()%>'">
					</td>
					<%}%>
				</tr>
			<%}}%>
		</table>
		</div>
		<div class="panel-footer" align="right">
		<%if (memid != null){ %>
			<input type="button" class="btn btn-primary" value="새 글 작성" onclick="location='<%=contextPath%>/boardWrite.jsp?boardCategoryName=<%=boardCategoryName%>&boardCategoryNum=<%=boardCategoryNum%>'">
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
				<a class="page-link" href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&sortMode=<%=sortMode%>&viewRow=<%=viewRow%>&pageNum=<%=startPage - pagePool%>">
					&laquo;
				</a>
			</li>
	<%
		} System.out.println(endPage +" : " + endPage);
		for(int i = startPage ; i <= endPage ; i++){ //1,2,3,4 페이지 수 열거
	%>
		<li class="page-item">
			<a href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&sortMode=<%=sortMode%>&viewRow=<%=viewRow%>&pageNum=<%=i%>"><%=i%></a>
		</li>
	<%
		}
		//표시하는 끝 페이지보다 전체 페이지가 더 클 경우, 다음 버튼 추가
		if(endPage < pageCount){
		%>
			<li class="page-item">
				<a class="page-link" href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName%>&sortMode=<%=sortMode%>&viewRow=<%=viewRow%>&pageNum=<%=startPage + pagePool%>">
					&raquo;
				</a>
			</li>
		<%}%>
		</ul>
	</div>
</div>
<%@include file="main_bottom.jsp"%>
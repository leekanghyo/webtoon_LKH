<%@page import="java.text.SimpleDateFormat"%>
<%@page import="list.ListBean"%>
<%@page import="list.ListDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>


<title>Insert title here</title>

<%@include file="../main_top.jsp" %>
<%
	int boardNum = Integer.parseInt(request.getParameter("boardNum"));
	String boardCategoryName = request.getParameter("boardCategoryName");
	String boardCategoryNum = request.getParameter("boardCategoryNum");
	
	ListDao listdao = ListDao.getInstance();
	ListBean listbean = listdao.getNotice(boardNum);
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");

	String newcon = listbean.getContent();
	String[] imgArr = null;
	try{
		//이미지 정보들 배열로 분할
		imgArr = listbean.getImg().split("/=/");
	
	}catch(NullPointerException e){
		System.out.println("Null포인트 익셉션 발생, 이미지 정보가 없을 경우, 위 코드는 넘어간다.");
	}
%>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js "></script>

<script type="text/javascript">

	var rowIndex = 1;
	var max = 4 //추가 할 수 있는 수량은 최대 5로 한정
	var oldImgFileTable;
	var oldImgRows
	$(document).ready(function(){
		//기존에 올린 데이터가 존재한다면
		oldImgFileTable = document.getElementById("oldImgFileTable");
		oldImgRows = oldImgFileTable.rows.length;
		max -= oldImgRows; //수량 통일을 위해 이후 추가 할 수 있는 파일을 제한
	});
	
	function addFile(){
		if(rowIndex > max) return false; //추가한 파일 슬롯이 max를 넘을 경우 돌려보냄
		
		var getTable = document.getElementById('insertImgFileTable');
		var oCurrentRow = getTable.insertRow(getTable.rows.length); //한 줄 추가
		//다음의 HTML 태그를 추가한다.
		oCurrentRow.innerHTML = "<tr><td colspan=4><INPUT class=input TYPE=FILE NAME='filename" +(rowIndex + 1) + "' size=25></td></tr>";
		rowIndex++; //한 줄 추가 카운트
		$('span[id=imgCount]').text("첨부 파일 수 [5 : " + rowIndex + "]");
	}
	
	function deleteFile(){
		
		if(rowIndex < 2) return false; //삭제 할 때 슬롯이 1개인 경우 돌려보냄
		rowIndex--; //한줄 빼기
		var getTable = document.getElementById('insertImgFileTable');
		getTable.deleteRow(rowIndex);
		$('span[id=imgCount]').text("첨부 파일 수 [5 : " + rowIndex + "]");
	}
	
	var delStack =""
	function deletOldFile(elem){
		//테이블 정보
		//부모의 부모의 요소 중 data-row-no 값을 담는다.
		var parentElem = elem.parentElement.parentElement.getAttribute("data-row-no");
		delImg = elem.parentElement.parentElement.getAttribute("img-val");
		
		alert("이미지 삭제 :" + delImg);
		max++;
		
		//로우 삭제
		oldImgFileTable.deleteRow(parentElem);
		
		var oldimgArr = $('table[id=oldImgFileTable] tr');
		//로우 삭제로 인해 생긴 공백을 매꾸기 위해 data-row-no를 재 정렬
		i = 0;
		$.each(oldimgArr, function(){
			$(this).attr("data-row-no", i);
			i++;
		});
	}
	
</script>
<div class="well well-sm">
	<b>
		<a href="<%=contextPath%>/main.jsp">Main</a> &gt;
		<a href="<%=contextPath%>/boardCategoryList.jsp">게시판 목록</a> &gt;
		<a href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=boardCategoryName %>&boardCategoryNum=<%=boardCategoryNum%>"><%=boardCategoryName%></a> &gt;
		게시글 수정
	</b>
</div>

<div class="content-grid">
	<form method="post" action="<%=contextPath %>/boardUpdatePro.jsp" enctype="multipart/form-data">
	<input type="hidden" name ="boardCategoryNum" value="<%=listbean.getNum()%>">
	<input type="hidden" name ="boardCategoryName" value="<%=listbean.getWhatcontents()%>">
	<h3 class="text-primary">게시글 수정</h3>
	<table class="table">
		<tr>
			<th>분류</th>
			<td>
				<input class="form-control" type="text" value ="<%=boardCategoryName%>" disabled>
			</td>
		</tr>
		<tr>
			<th>
				제목
			</th>
			<td><input type="text" class="form-control" name ="subject" value="<%=listbean.getSubject() %>" placeholder="[게시글 제목]"></td>
		</tr>
		<tr>
			<th class="text-primary">첨부 파일</th>
			<td>
				<table id ='insertImgFileTable'>
					<tr>
						<td>
							<input type="file" name ='filename1'>
						</td>
						<td>
			        		<input type="button" class="btn btn-primary" value="추가" onClick="addFile()">
			        		<input type="button" class="btn btn-danger" value="삭제" onClick="deleteFile()">
						</td>						
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<% if(imgArr != null) {%>
			<th class="text-primary">기존 업로드 이미지</th>
						
			<td>
				<table id ="oldImgFileTable">
					<%for(int i = 0 ; i < imgArr.length ; i++){%>
				<tr data-row-no=<%=i %> img-val=<%=imgArr[i]%>>
					<td>
						<input type ="button" class="btn btn-danger" value="삭제" onclick="deletOldFile(this)">
						<input type="hidden" name ="delf"value="<%=imgArr[i] %>">
						<a href="#"
						onclick="window.open('<%=contextPath%>/webtoonDB/list/<%=boardCategoryNum%>/<%=listbean.getNum() %>/<%=imgArr[i] %>','<%=imgArr[i] %>','width=500,height=600'); return false"
						><%=imgArr[i] %>
						</a>
					</td>
				</tr>
			<%}%>
				</table>
			</td>
			<%}%>
		</tr>
		<tr>
			<th class="text-primary">내용</th>
			<td>
        		<span id ="imgCount">첨부 파일 슬롯 [5 : 1]</span><br>
				내용에서 사진을 출력할때는 태그 추가 {img:0} ~ {img:..}<br>
				<textarea class="form-control" rows="30" cols="70" name = "content"><%=listbean.getContent() %></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" class="btn btn-primary" value ="수정">
				<input type="button" class="btn btn-danger" value ="취소" onclick="history.back()">
			</td>
		</tr>
		
	</table>
	</form>	
	
</div>
<div style="height: 100"></div>

<%@include file="../main_bottom.jsp" %>
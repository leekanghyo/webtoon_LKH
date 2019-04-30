<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="main_top.jsp"%>
<%
	String boardCategoryName = request.getParameter("boardCategoryName");

	//파일 업로드 경로를 위해 일시적으로 세션 지정
	session.setAttribute("whatContents", boardCategoryName);

	System.out.println("boardCategoryName1 :" + boardCategoryName);
%>
<title>Insert title here</title>
<script type="text/javascript">
//첨부 파일 추가
	var rowIndex = 1;
	var max = 4 //추가 할 수 있는 수량은 최대 5로 한정
	function addFile(){
	 	
		if(rowIndex > max) return false; //추가한 파일 슬롯이 max를 넘을 경우 돌려보냄
		
		
		var getTable = document.getElementById('insertImgFileTable');
		

		var oCurrentRow = getTable.insertRow(getTable.rows.length); //한 줄 추가
	    //var oCurrentCell = oCurrentRow.insertCell(1);
		//alert(oCurrentCell);

		//다음의 HTML 태그를 추가한다.
		oCurrentRow.innerHTML = "<tr><td colspan=4><INPUT class=input TYPE=FILE NAME='filename" + (rowIndex+1) + "' size=25></td></tr>";
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
	
	
	function contentCheck(){
 		if($('input[name=subject]').val() ==""){
			alert("제목과 내용은 반드시 입력해야합니다.");
			$('input[bname=subject]').focus();
			return false;
		}

 		if($('textarea[name=content]').val() ==""){
			alert("제목과 내용은 반드시 입력해야합니다.");
			$('textarea[name=content]').focus();
			return false;
		}
	}

</script>
<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt; <a
		href="<%=contextPath%>/boardCategoryList.jsp">게시판 목록</a> &gt; <%=boardCategoryName%>
		&gt; <%=boardCategoryName%> - 게시글 작성
	</b>
</div>
<%
%>
<div class="content-grid" id="content-grid">
	<form method="post" action="<%=contextPath%>/boardWritePro.jsp" enctype="multipart/form-data">
		<input type="hidden" name="nickname" value="<%=nickname %>">
		<!-- 작성자는 세션 지정이므로 별도 선언 없음 -->
		<!--  게시판 분류는 세션 지정으로 별도 선언 없음 -->
		<div class="panel panel-default">
			<div class="panel-heading">
				<b>신규 게시글</b>
			</div>
			<div class="panel-body">
				<ul class="list-group list-group-flush">
					<!-- 게시글 분류 -->
					<li class="list-group-item">
						<div class="row">
							<div class="col-sm-2">
								<b>게시판 분류</b>
							</div>
							<div class="col-sm-8">
								<div class="col-xs-8">
									<b><%=boardCategoryName%></b>
								</div>
							</div>
						</div>
					</li>
					<!-- 게시글 분류 -->
					<!-- 게시글 제목 -->
					<li class="list-group-item">
						<div class="row">
							<div class="col-sm-2">
								<b>제목</b>
							</div>
							<div class="col-sm-8">

								<input type="text" class=form-control name="subject">

							</div>
						</div>
					</li>
					<!-- 게시글 제목 -->
					<!-- 첨부 파일 -->
					<li class="list-group-item">
						<div class="row">
							<div class="col-sm-2">
								<b>첨부 파일</b>
							</div>
							<div class="col-sm-8">
								<table id='insertImgFileTable'>
									<tr>
										<td>
											<input type="file" name='filename1'>
										</td>
										<td>
											<input type="button" class="btn btn-info" value="추가" onClick="addFile()"> <input type="button" class="btn btn-danger" value="삭제" onClick="deleteFile()">
										</td>
									</tr>
								</table>
							</div>
						</div>
					</li>
					<!-- 첨부 파일 -->
					<!-- 게시글 내용-->
					<li class="list-group-item">
						<div class="row">
							<div class="col-sm-2">
								<b>내용</b>
							</div>
							<div class="col-sm-8">
								<span id="imgCount">첨부 파일 슬롯 [5 : 1]</span><br> 내용에서 사진을
								출력할때는 태그 추가 {img:0} ~ {img:..}<br>
								<textarea class="form-control" rows="30" name="content"></textarea>
							</div>
						</div>
					</li>
					<!-- 게시글 내용-->
					<!-- 작성 버튼 -->
					<li class="list-group-item">
						<div align="center">
							<input type="submit" class="btn btn-primary btn-lg" value="작성">
						</div>
					</li>
				</ul>
			</div>
		</div>
	</form>
</div>
<%@include file="main_bottom.jsp"%>
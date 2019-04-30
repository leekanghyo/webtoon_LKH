<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<title>Insert title here</title>

<%@include file="../main_top.jsp" %>
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
		oCurrentRow.innerHTML = "<tr><td colspan=4><input type='file' name='filename'" + (rowIndex+1) + "'></td></tr>";
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
	<b>
		<a href="<%=contextPath%>/main.jsp">Main</a> &gt;
		<a href="<%=contextPath%>/admin/adminMain.jsp">Main</a> &gt;
		신규 공지 작성
	</b>
</div>
<div class="content-grid">

	<form method="post" action="noticeWritePro.jsp" enctype="multipart/form-data" onsubmit ="return contentCheck()">
	<input type="hidden" name="nickname" value="<%=nickname%>">
	<h3 class="text-primary">신규 공지 작성</h3>
	<table class="table">
		<tr>
			<th class="text-primary">분류</th>
			<td>
				<select class="form-control" name ="listType">
					<option value="main">메인 공지</option>
					<option value="board">게시판 공지</option>
				</select>
			</td>
		</tr>
		<tr>
			<th class="text-primary">제목</th>
			<td><input type="text" class="form-control" name ="subject" value="" placeholder="[공지 제목]"></td>
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
			        		<input type="button" class="btn btn-info" value="추가" onClick="addFile()">
			        		<input type="button" class="btn btn-danger" value="삭제" onClick="deleteFile()">
						</td>						
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<th class="text-primary">내용</th>
			<td>
        		<span id ="imgCount">첨부 파일 슬롯 [5 : 1]</span><br>
				내용에서 사진을 출력할때는 태그 추가 {img:0} ~ {img:..}<br>
				<textarea class="form-control" rows="30" cols="70" name = "content"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div align="center">
					<input type="submit" class="btn btn btn-success" value ="작성">
					<input type="button" class="btn btn-dark" value ="취소" onclick="history.back()">
				</div>
			</td>
		</tr>

	</table>
	</form>	
	
<div style="height: 100"></div>
</div>

<%@include file="../main_bottom.jsp" %>

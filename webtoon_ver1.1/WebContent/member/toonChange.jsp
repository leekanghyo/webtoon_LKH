<%@page import="toon.ContentBean"%>
<%@page import="toon.ToonDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<title>cytoon</title>
<%@include file="../main_top.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");

	ToonDao toondao = ToonDao.getInstance();
	
	int workNum = Integer.parseInt(request.getParameter("workNum"));
	int episode = Integer.parseInt(request.getParameter("episode"));

	ContentBean cbean = toondao.getContent(workNum, episode);
	
	
	int contentNum = cbean.getNum();
	
	String workName = cbean.getWorkName();
	
	

%>

<script type="text/javascript">
	$(document).ready(function(){
  		$('[data-toggle="tooltip"]').tooltip(); 
  		
  		$('input[name=episode]').keyup(function(){
  			
  			if($(this).isNaN){
  				$(this).val("");
  			}
  		});
	});
	//---------------------------------------툴팁 함수
	//첨부 파일 추가
	var rowIndex = 1;
	var max = 8 //추가 할 수 있는 수량은 최대 9로 한정
	function addFile(){
	 	
		if(rowIndex > max) return false; //추가한 파일 슬롯이 max를 넘을 경우 돌려보냄
		
		var getTable = document.getElementById('insertImgFileTable');
		
		var oCurrentRow = getTable.insertRow(getTable.rows.length); //한 줄 추가
	    //var oCurrentCell = oCurrentRow.insertCell(1);
		//alert(oCurrentCell);

		//다음의 HTML 태그를 추가한다.
		oCurrentRow.innerHTML = "<tr><td colspan=4><input type='file' name='filename" + (rowIndex+1) + "'></td></tr>";
		rowIndex++; //한 줄 추가 카운트
		$('span[id=imgCount]').text("첨부 파일 수 [10 : " + rowIndex + "]");
		
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
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt;
		작품 일람
	</b>
</div>

<div class ="content-grid">
	<form method="post" action="toonChangePro.jsp" enctype="multipart/form-data">
		<div class="panel panel-default">
			<div class="panel-heading bg-dark text-white">
				<input type="hidden" name="workNum" value="<%=workNum%>">
				<input type="hidden" name="workName" value="<%=workName%>">
				<b><%=cbean.getWorkName()%> - Next Work</b>
			</div>
			<div class="panel-body">
				<ul class="list-group">
					<!-- Name -->
					<li class="list-group-item">
					  	<div class ="row">
					  		<div class ="col-sm-4">
					  			<a href="#" data-toggle="tooltip" data-placement="right" title="에피소드 화수를 자동으로 설정합니다.">
					  				<b>EPISODE</b> <!-- 이번 화 홧수 숫자만 입력 -->
					  			</a>
					  		</div>
					  		<div class = "col-sm-6">
					  			<input type="hidden" name ="episode" value="<%=episode%>">
						  		<input type="text" class="form-control" value ="<%=episode%>" disabled>
					  		</div>
					  	</div>
					</li>
					<li class="list-group-item">
						<div class ="row">
							<div class ="col-sm-4">
								<a href="#" data-toggle="tooltip" data-placement="right" title="이번 화의 제목을 입력하세요.">
					  				<b> SUBTITLE</b> <!-- 서브 타이틀 명 -->
					  			</a>
							</div>
							<div class = "col-sm-6">
								<input type="text" class="form-control" name="subtitle" value="<%=cbean.getSubtitle()%>">
							</div>
						</div>
					</li>
					<li class="list-group-item">
						<div class ="row">
							<div class ="col-sm-4">
								<a href="#" data-toggle="tooltip" data-placement="right" title="이번화의 줄거리를 입력하세요.">
									<b>DESCRIPT</b> <!-- 작품 화 설명 -->
								</a>
							</div>
							<div class = "col-sm-6">
								<input type="text" class="form-control" name="descript" value="<%=cbean.getDescript()%>">
							</div>
						</div>
					</li>
					<li class="list-group-item">
					  	<div class ="row">
							<div class ="col-sm-4">
								<a href="#" data-toggle="tooltip" data-placement="right" title="작가 코멘트를 남겨주세요.&nbsp;입력하지 않아도 무방합니다.">
									<b>COMMENT</b> <!-- 작가 코멘트 -->
								</a>
							</div>
							<div class = "col-sm-6">
								<input type="text" class="form-control" name="writerComment" value="<%=cbean.getWriterComment()%>">
							</div>
						</div>
					</li>
					<li class="list-group-item">
						<div class ="row">
							<div class ="col-sm-4">
								<a href="#" data-toggle="tooltip" data-placement="right" title="수정하는 경우, 이미지 파일을 다시 올려야 합니다. 이전에 업로드한 파일은 삭제됩니다.">
									<b>UPLOAD FILE</b> <!--파일 업로드 -->
								</a>
							</div>
							<div class = "col-sm-6">
								<span id ="imgCount">첨부 파일 슬롯 [9 : 1]</span>
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
							</div>
						</div>
					</li>
				</ul>
				<div align="center">
					<input type="submit" class="btn btn-success btn-lg" value="Create Web Toon">
				</div>
			</div>
		</div>
	</form>
</div>
<%@include file="../main_bottom.jsp" %>
<%@page import="toon.WriterBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="toon.ToonDao"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="member.MemberBean"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<title>cytoon - 회원 관리 페이지</title>
<%@include file="../main_top.jsp" %>
<%	
	//날짜 관련
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	String adddate = sdf.format(bean.getAdddate());

	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd",Locale.KOREA);
	Date currentDate = new Date();
	String dateStr = sdf2.format(currentDate);
	
	int todayWeek = cal.get(Calendar.DAY_OF_WEEK)  - 1;
	
	System.out.println("todayWeek : " + todayWeek);
	String[] weekArr ={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
	String weekStr = weekArr[todayWeek];
	//------------------------------------------------------------------------------
	
	//현재 보유 웹툰 리스트
	ToonDao toondao = ToonDao.getInstance();
	ArrayList<WriterBean> wList = toondao.getWorkList(memid);
	
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
		$('span[id=imgCount]').text("첨부 파일 수 [9 : " + rowIndex + "]");
		
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
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt; 회원정보
	</b>
</div>


<div class="content-grid" id="content-grid">

	<ul class="nav nav-tabs">
		<li class="active">
			<a data-toggle="tab" href="#Profile">Profile</a>
		</li>
		<li>
			<a data-toggle="tab" href="#MyWork">My Work</a>
		</li>
		<li>
			<a data-toggle="tab" href="#CreateWork">Create Work</a>
		</li>
	</ul>

	<div class="tab-content">
		<div id="Profile" class="tab-pane fade in active">
			<div class="panel panel-default">
				<div class="panel-heading" style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
					<font class="text-white" style="font-size: x-large;">Profile</font>
				</div>
				<div class="panel-body">
					<div class="row">
						<div class="col-sm-4" align="center" style="padding-top: 50">
							<div class="thumbnail-frame2">
								<img class=" thumbnail-img2"src="<%=contextPath%>/webtoonDB/member/<%=memid %>/<%=userimg%>" onerror="this.src='<%=contextPath%>/img/defaultmember.jpg'">
							</div>
						</div>
						<div class="col-sm-8">
							<ul class="list-group list-group-flush">
								<li class="list-group-item">
									<font class="text-primary" style="font-size: xx-large;"><%=nickname%></font>
								</li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4"><b>ID</b></div>
										<div class="col-sm-8"><%=memid%></div>
									</div>
								</li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4"><b>Account Lv.</b></div>
										<div class="col-sm-8"><font color="Blue"><b>작가</b></font></div>
									</div>
								</li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4"><b>Sign up</b></div>
										<div class="col-sm-8"><%=adddate%></div>
									</div>
								</li>
							</ul>
							<div align="right">
								<input type="button" class="btn btn-primary" value="회원 정보 수정" onclick="location='<%=contextPath%>/member/profileChange.jsp'">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div> <!--  -->
		<!-- 연재 중인 작품 관리 -->
		<div id="MyWork" class="tab-pane fade">
			<!-- 리스트 -->
			<div class="panel panel-default">
				<div class="panel-heading" style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
					<font class="text-white" style="font-size: x-large;">My Work</font>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading bg-dark text-white">
						My WorkList
					</div>
					<div class="panel-body">

							<table class="table table-hover">
								<thead class="thead-dark">
									<tr>
										<th style="text-align: center">No.</th>
										<th style="text-align: center" width="20%">제목</th>
										<th style="text-align: center">썸네일</th>
										<th style="text-align: center">시놉시스</th>
										<th style="text-align: center">첫 연재일</th>
										<th style="text-align: center" width="10%">연재 요일</th>
										<th style="text-align: center" width="13%">연재</th>
										<th style="text-align: center" width="10%">공개</th>
									</tr>
								</thead>
								<%
								if(wList.size() <= 0){
									out.println("<tr><td colspan='6'>보유 작품이 없습니다.<td><tr>");
								}else{
									for(WriterBean wbean : wList){
									System.out.println(contextPath);
								%>
								<tr>
									
									<td><%=wbean.getNum() %></td>
									<td><a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=wbean.getNum()%>"><%=wbean.getWorkName() %></a></td>
									<td>
										<div class="thumbnail-frame1">
											<a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=wbean.getNum()%>">
											<img class ="thumbnail-img1" src="<%=contextPath%>/webtoonDB/member/<%=memid %>/<%=wbean.getWorkName()%>/<%=wbean.getTitleImage()%>" >
											</a>
										</div>
									</td>
									 <td>
										 <a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=wbean.getNum()%>">
											 <font style="font-size: small;"><%=wbean.getSynop() %></font>
										</a>
									</td>
									 
									 <td><%=sdf2.format(wbean.getWriteStart())%></td>
									 <td><%=weekArr[wbean.getWriteWeek()]%></td>
									 <td>
									 	<%if(wbean.getWriteEnd() == 1) {%>
									 		<font class="text-danger">[연재 종료]</font>
									 	<%}else { %>
									 		<font class="text-primary">[연재 중]</font>	
									 	<%} %>
									 </td>
									<td>
									 	<%if(wbean.getViewMode() == 1){ %>
									 		<font class="text-secondary">[비공개]</font>
									 	<%}else{%>
									 		<font class="text-primary">[공개 중]</font>
									 	<%}%>
									</td>
								</tr>
								<%}}%>
							</table>
					</div>
				</div>
			</div>
		</div>
		<!-- 연재 중인 작품 관리 -->
		
<!-- 신규 작품 투고 -->
			<div id="CreateWork" class="tab-pane fade">
				<form method="post" action="toonFirstAddPro.jsp" enctype="multipart/form-data">
					<div class="panel panel-default">
						<div class="panel-heading" style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
							<font class="text-white" style="font-size: x-large;">Create Work</font>
						</div>
						<div class="panel-body">
							<div class="panel panel-default">
								<div class="panel-heading bg-dark text-white">
									Add Work Profile
								</div>
								<div class="panel-body">
									<ul class="list-group">
										<!-- Name -->
										<li class="list-group-item">
										  	<div class ="row">
										  		<div class ="col-sm-4">
										  			<a href="#" data-toggle="tooltip" data-placement="right" title="작품 연재 회원의 이름이 표시됩니다.">
										  				<b> WRITER</b> <!-- 작가명 -->
										  			</a>
										  		</div>
										  		<div class = "col-sm-6">
										  			<input type="hidden" name="writerName" value="<%=nickname%>">
										  			<input type="text" class="form-control" name="writerName" value="<%=nickname%>" disabled>
										  		</div>
										  	</div>
										</li>
										<li class="list-group-item">
											<div class ="row">
												<div class ="col-sm-4">
													<a href="#" data-toggle="tooltip" data-placement="right" title="웹툰의 제목을 입력합니다.">
											  			<b> TITLE</b> <!-- 작품 명 -->
											  		</a>
												</div>
												<div class = "col-sm-6">
													<input type="text" class="form-control" name="workName" value="">
												</div>
											</div>
										</li>
										<li class="list-group-item">
											<div class ="row">
												<div class ="col-sm-4">
													<a href="#" data-toggle="tooltip" data-placement="right" title="웹툰 페이지에서 썸네일 이미지로 사용합니다. 반드시 업로드 해주세요.">
										  			<b> THUMBNAIL IMG</b> <!-- 작품 대표 사진 -->
										  			</a>
												</div>
												<div class = "col-sm-6">
													<input type="file" name="titleImage">
												</div>
											</div>
										</li>
										<li class="list-group-item">
											<div class ="row">
												<div class ="col-sm-4">
													<a href="#" data-toggle="tooltip" data-placement="right" title="작품에 대해 간단한 줄거리 및  시나리오를 입력해주세요.">
													<b>SYNOPSIS</b> <!-- 작품 시놉 -->
													</a>
												</div>
												<div class = "col-sm-6">
													<textarea class= "form-control" rows="3" name="synop"></textarea>
												</div>
											</div>
										</li>
										<li class="list-group-item">
										  	<div class ="row">
												<div class ="col-sm-4">
													<a href="#" data-toggle="tooltip" data-placement="right" title="작품의 장르를 입력하세요.">
														<b>GENRE</b> <!-- 작품 장르 -->
													</a>
												</div>
												<div class = "col-sm-6">
													<input type="text" class="form-control" name="genre">
												</div>
											</div>
										</li>
										<li class="list-group-item">
											<div class ="row">
												<div class ="col-sm-4">
													<a href="#" data-toggle="tooltip" data-placement="right" title="작품 신청한 당일이 연재 요일입니다.">
													<b>UPLOAD WEEK</b> <!-- 연재 요일 -->
													</a>
												</div>
												<div class = "col-sm-6">
													<input type="hidden" name="writeWeek" value="<%=todayWeek%>">
													<p><font class="text-primary" style="font-weight: bold;"><%=weekStr%></font> <b>(첫 연재일: <%=dateStr%>)</b></p>
													작품 신청한 당일이 연재 요일입니다.
												</div>
											</div>
										</li>
									</ul>
								</div>
							</div>
						</div>		
					</div>
					<!-- <div class="panel panel-default"> --> <!-- 최초 생성시에는 1화를 반드시 업로드 해야함 -->
					<div class="panel panel-default">
						<div class="panel-heading bg-dark text-white">
							<b>First Work</b>
						</div>
						<div class="panel-body">
							<ul class="list-group">
								<!-- Name -->
								<li class="list-group-item">
								  	<div class ="row">
								  		<div class ="col-sm-4">
								  			<a href="#" data-toggle="tooltip" data-placement="right" title="에피소드 화수를 설정합니다. 첫 화는 1로 고정입니다.">
								  				<b>EPISODE</b> <!-- 이번 화 홧수 숫자만 입력 -->
								  			</a>
								  		</div>
								  		<div class = "col-sm-6">
								  			<input type="hidden" name ="episode" value="1">
								  			<input type="text" class="form-control" value ="1" disabled>
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
											<input type="text" class="form-control" name="subtitle">
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
											<input type="text" class="form-control" name="descript">
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
											<input type="text" class="form-control" name="writerComment">
										</div>
									</div>
								</li>
								<li class="list-group-item">
									<div class ="row">
										<div class ="col-sm-4">
											<a href="#" data-toggle="tooltip" data-placement="right" title="웹툰 이미지 파일을 올려주세요. 최대 10개 까지 분할 업로드 가능합니다.">
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
<!-- 신규 작품 투고 -->
	</div>
<div style="height: 100%"></div>
</div>
<%@include file="../main_bottom.jsp" %>
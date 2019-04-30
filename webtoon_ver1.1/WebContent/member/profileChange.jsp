<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<title>Insert title here</title>
<%@include file="../main_top.jsp" %>
<%
		String adddate = request.getParameter("adddate");
%>

<script type="text/javascript">		
	function checkAttr(){
		
		/* DB의 패스워드 */
		var mempw = $('input[name=mempw]');

		/* 사용자가 입력한 패스워드 */
		var apw = $('input[name=apw]');
		var bpw = $('input[name=bpw]');
		var bpwr = $('input[name=bpwr]');
		
		/* 기존 패스워드 */
		if(apw.val() == ""){
			alert("PW를 입력하세요.");
			apw.focus();
			return false;
		}

		var regexp = /^[A-Za-z0-9]{3,5}$/; // 영 대소문자 숫자 조합 12~15자
		
		if (!regexp.test(apw.val())) {
			alert("PW 양식이 맞지 않습니다. 영문자와 숫자 조합 3~5자 사이로 입력하세요.");
			return false;
		}
		
		if( (bpw.val() != "") && (bpwr.val() != "")){
			if(apw.val() != mempw.val()){
				alert("새로 입력한 PW가 입력한 기존의 PW와 다릅니다.");
				apw.val("");
				apw.focus();
				return false;
			}
			
			var chk_num = apw.val().search(/[0-9]/);
			var chk_eng = apw.val().search(/[a-z]/i); // i : 대소문자 구분X
					
			if (chk_num < 0 || chk_eng < 0) {
				alert("입력한 PW 양식이 맞지 않습니다. 영문자와 숫자 조합 3~5자 사이로 입력하세요.");
				apw.val("");
				apw.focus();
				return false;
			}
	
			if(mempw.val() == bpw.val()){
				alert("PW를 변경할 때는 기존과 다르게 입력해야 합니다. PW 변경을 원치 않을때는 PW 관련 입력란을 공백으로 설정하세요.");
				apw.val("");
				apw.focus();
				return false;
			}
	
			chk_num = bpw.val().search(/[0-9]/);
			chk_eng = bpw.val().search(/[a-z]/i); // i : 대소문자 구분X
					
			if (chk_num < 0 || chk_eng < 0) {
				alert("변경할 PW가 양식에 맞지 않습니다. 영문자와 숫자 조합 3~5자 사이로 입력하세요.");
				bpw.val("");
				bpw.focus();
				return false;
			}
			
			if(bpw.val() != bpwr.val()){
				alert("새로 입력한 비밀번호와 비밀번호 확인에 입력한 내용일 일치하지 않습니다.");
				bpwr.val("");
				bpwr.focus();
				return false;
			}		
		}
	}
</script>

<script type="text/javascript" src="<%=contextPath%>/js/jquery.js "></script>
<script type="text/javascript"  src="<%=contextPath%>/script.js"></script>
<div class="well well-sm">
		<a href="<%=contextPath%>/main.jsp">Main</a> &gt;
		<%if(wtmtype.equals("admin")){%>
			<a href="<%=contextPath%>/admin/adminMain.jsp">관리자 페이지</a> &gt; 
		<%}else if(wtmtype.equals("writer")){%>
			<a href="<%=contextPath%>/member/writerMain.jsp"><%=nickname%>(<%=memid%>) 님 개인 페이지</a> &gt; 
		<%}else{%>
			<a href="<%=contextPath%>/member/memberMain.jsp"><%=nickname%>(<%=memid%>) 님 개인 페이지</a> &gt; 
		<%}%>
		회원 정보 수정
</div>
	
<div class="content-grid">
	<form method="post" action="prifileChagePro.jsp" enctype="multipart/form-data" onsubmit="return checkAttr()">
		<input type="hidden" name ="mempw" value="<%=mempw%>">
		
		
		<div class="panel panel-default">
			<div class="panel-heading" style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
				<font class="text-white" style="font-size: x-large;">회원 정보 수정</font>
			</div>
			<div class="panel-body">
				<div class="row">
					<div class="col-sm-4">
						<!-- 본래 설정 이미지 보여주기 용-->
						<div class="thumbnail-frame2">
							<img class="thumbnail-img2"src="<%=contextPath%>/webtoonDB/member/<%=memid%>/<%=userimg%>" height="50px" onerror ="this.src='<%=contextPath%>/img/defaultmember.jpg'">
						</div>
						<br>
						<input type="file" name="userimg">
					</div>
					<div class="col-sm-8">
						<ul class="list-group">
							
							<li class="list-group-item">



							</li>
							<li class="list-group-item">
								<div class="row">
									<div class="col-sm-4">
										<font class="text-primary" style="font-weight: bold;">ID</font>
									</div>
									<div class="col-sm-8">
										<%=memid%>
									</div>
								</div>
							</li>
		
							<li class="list-group-item">
								<div class="row">
									<div class="col-sm-4">
										<font class="text-primary" style="font-weight: bold;">Account Lv.</font>
									</div>
									<div class="col-sm-8">
										<%if(wtmtype.equals("admin")){ %>
											<font color="red"><b>관리자</b></font>
										<%} else if (wtmtype.equals("writer")){%>
											<font color="blue"><b>작가</b></font>				
										<%}else {%>
											<font><b>일반 회원</b></font>
										<%}%>
									</div>
								</div>
							</li>
		
							<li class="list-group-item">
								<div class="row">
									<div class="col-sm-4">
										<font class="text-primary" style="font-weight: bold;">Name</font>
									</div>
									<div class="col-sm-8">
										<input type="text" class ="form-control" value="<%=nickname%>" name="name">
									</div>
								</div>
							</li>
		
							<li class="list-group-item">
								<div class="row">
									<div class="col-sm-4">
										<font class="text-primary" style="font-weight: bold;">기존 비밀 번호</font>
									</div>
									<div class="col-sm-8">
										<input type="password" class="form-control" name ="apw" value="">
									</div>
								</div>
							</li>
		
							<li class="list-group-item">
								<div class="row">
									<div class="col-sm-4">
										<font class="text-primary" style="font-weight: bold;">변경할 비밀번호</font>
									</div>
									<div class="col-sm-8">
										<input type="password" class ="form-control" name ="bpw" value="">
									</div>
								</div>
							</li>
							<li class="list-group-item">
								<div class="row">
									<div class="col-sm-4" style="font-weight: bold;">
										<font class="text-primary">변경할 비밀번호 확인</font>
									</div>
									<div class="col-sm-8">
										<input type="password" name ="bpwr" class="form-control" value="">
									</div>
								</div>
							</li>
							<li class="list-group-item">
								<div class="row">
									<div class="col-sm-4" >
										<font class="text-primary" style="font-weight: bold;">가입일</font>
									</div>
									<div class="col-sm-8">
										<font class="text-primary"><%=bean.getAdddate()%></font>
									</div>
								</div>
							</li>
							<li class="list-group-item">
								<div align="right">
									<input type="submit" class="btn btn-success" value="회원 정보 수정">
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>

	</form>
	<div style="height: 100"></div>	
</div>


<%@include file="../main_bottom.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<title>cytoon - Sign Up</title>
<%@include file="../main_top.jsp"%>
<script src="<%=contextPath %>/script.js"></script>
<%
	//세션 설정에서 사용할 변수를 그대로 재활용
	wtmtype = request.getParameter("wtmtype").trim();
%>
<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt; <a
		href="<%=contextPath%>/member/memberAddCheck.jsp"> Sign Up 1단계 </a>&gt;
		Sign Up 2단계
	</b>
</div>
<div class="content-grid">
	<form method="post" action="memberAddPro.jsp" enctype="multipart/form-data" onsubmit="return writeSave()">
	<div style="width: 700; margin: auto;">
		<font class="text-primary" style="font-size: xx-large;">Sign Up</font>
		<input type="hidden" name="wtmtype" value="<%=wtmtype%>">
		<div class="panel panel-info">
			<div class=" panel-heading">
				<b>Sign Up</b>
			</div>
			<div align="center">
				<div class="panel-body">
					<ul class="list-group list-group-flush">
						<!-- 아이디 -->
						<li class="list-group-item">
							<div align="center">
								<div class="row">
									<div class="col-sm-3">
										<b>ID</b>
									</div>
									<div class="col-xs-3">
										<input type="text" class=form-control name="id">
									</div>
									
									<div class="row">
										<div class="col-sm-6">
											<input type="button" class="btn btn-info" value="중복체크" onclick="accountcheck()">
										</div>
										<div class="col-sm-6">
											<span id="idmessage" style="display: none; font-weight: bold;"></span>
										</div>
									</div>
								</div>
							</div>
						</li>
						<!-- 닉네임 -->
						<li class="list-group-item">
							<div align="center">
								<div class="row">
									<div class="col-sm-3">
										<b>Name</b>
									</div>
									<div class="col-xs-3">
										<input type="text" class=form-control name="name">
									</div>

								</div>
							</div>
						</li>
						<!-- PW -->
						<li class="list-group-item">
							<div align="center">
								<div class="row">
									<div class="col-sm-3">
										<b>PW</b>
									</div>
									<div class="col-xs-3">
										<input type="password" name="passwd" class="form-control" onblur="return pwcheck()" onchange="cleaerpwmsg()">
									</div>
									<div>
										<span id="pwmessage" style="display: none"></span>
									</div>

								</div>
							</div>
						</li>
						<!-- Re PW -->
						<li class="list-group-item">
							<div align="center">
								<div class="row">
									<div class="col-sm-3">
										<b>Re PW</b>
									</div>
									<div class="col-xs-3">
										<input type="password" name="repasswd" class=form-control
											onkeyup="passwd_keyUp()">
									</div>
								</div>
							</div>
						</li>
						<!-- 프로필 이미지 -->
						<li class="list-group-item">
							<div align="center">
								<div class="row">
									<div class="col-sm-3">
										<b>Profile Image</b>
									</div>
									<div class="col-xs-3">
										<input type="file" name=userimg>
									</div>
								</div>
							</div>
						</li>
					</ul>
					<input type="submit" class="btn btn-primary btn-lg" value="등록">
				</div>
			</div>
		</div>
		</div>
	</form>
	<div style="height: 500"></div>
</div>

<%@include file="../main_bottom.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript">
	function logincheck() {
		if ($('input[name=id]').val() == "") {
			alert("아이디를 입력하세요.");
			return false;
		}
		if ($('input[name=passwd]').val() == "") {
			alert("패스워드를 입력하세요.");
			return false;
		}
	}
</script>
<%@include file="main_top.jsp"%>
<title>cytoon - login</title>

<div class="well well-sm">
	<b><a href="<%=contextPath%>/main.jsp">Main</a> &gt; Log in</b>
</div>
<div class="content-grid">
	<form method="post" action="loginPro.jsp" onsubmit="return logincheck()">
		<div style="width: 500; margin: auto;">
			<font class="text-primary" style="font-size: xx-large;">Login</font>
			<div class="panel panel-info">
				<div class=" panel-heading">
					<b>Login</b>
				</div>

				<div class="panel-body">
					<ul class="list-group list-group-flush">
						<li class="list-group-item">
							<div class="row">
								<div class="col-sm-2">
									<b>ID</b>
								</div>
								<div class="col-sm-8">
									<div class="col-xs-8">
										<input type="text" class ="form-control" name="id">
									</div>
								</div>
							</div>
						</li>
						<li class="list-group-item">
							<div class="row">
								<div class="col-sm-2">
									<b>PW</b>
								</div>
								<div class="col-sm-8">
									<div class="col-xs-8">
										<input type="password" class="form-control"name="passwd">
									</div>
								</div>
							</div>
						</li>
					</ul>
				</div>
				<div class="panel-footer" align="right">
					<div style="float: left; padding-top: 10;">
						아직 회원이 아니신가요?
						<input type="button" class="btn btn-info" value="가입하기" onclick="location.href='<%=contextPath%>/member/memberAddCheck.jsp'">
					</div>
					<input type="submit" class="btn btn-success btn-lg" value="로그인">
				</div>
			</div>
		</div>
	</form>
<div style="height: 550"></div>
</div>
<%@include file="main_bottom.jsp"%>
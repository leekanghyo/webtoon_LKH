<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<title>cytoon - Sign Up</title>
<%@include file="../main_top.jsp"%>
<div class="well well-sm">
	<b><a href="<%=contextPath%>/main.jsp">Main</a> &gt; Sign Up 1단계</b>
</div>
<div class="content-grid">
	<form method="get" action="<%=contextPath%>/member/memberAdd.jsp">		
		<div style="width: 500; margin: auto;">
			<font class="text-primary" style="font-size: xx-large;">Sign Up</font>
			<div class="panel panel-info">
				<div class=" panel-heading">
					<b>회원 가입 유형</b>
				</div>
				<div class="panel-body">
					<ul class="list-group list-group-flush">
						<li class="list-group-item">
							<div class="row" align="center" style="margin: auto">
								<div class="col-sm-5">
									<input type="radio" value="normal" name="wtmtype" checked>일반 회원
								</div>
								<div class="col-sm-5">		
									<input type="radio" value="writer" name="wtmtype">작가 회원
								</div>
							</div>
						</li>
						<li class="list-group-item">
							<div align="center">
								<input type="submit" class="btn btn-success btn-lg" value="확인">
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</form>
<div style="height: 600"></div>
</div>
<%@include file="../main_bottom.jsp"%>

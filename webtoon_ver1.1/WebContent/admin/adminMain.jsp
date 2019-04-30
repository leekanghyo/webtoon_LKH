<%@page import="list.BoardCategoryBean"%>
<%@page import="list.ListBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="list.ListDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="member.MemberBean"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<title>cytoon - 관리자 페이지</title>
<%@include file="../main_top.jsp"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	String adddate = sdf.format(bean.getAdddate());

	ListDao listdao = ListDao.getInstance();

	//게시판 리스트 획득
	ArrayList<BoardCategoryBean> list = listdao.getBoardList();
	
	//멤버 리스트 획득
	ArrayList<MemberBean> memList = dao.getAllMember();
%>
<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt; 회원정보
	</b>
</div>


<div class="content-grid" id="content-grid">

	<ul class="nav nav-tabs">
		<li class="active"><a data-toggle="tab" href="#profile">profile</a></li>
		<!-- 프로필 탭 -->
		<li><a data-toggle="tab" href="#boards">Boards</a></li>
		<!-- 게시판 관리 탭 -->
		<li><a data-toggle="tab" href="#members">Members</a></li>
		<!-- 맴버 관리 탭 -->
	</ul>
	<div class="tab-content">
		<div id="profile" class="tab-pane fade in active">
			<!-- 프로필 패널 -->

			<div class="panel panel-default">
				<div class="panel-heading"
					style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
					<font class="text-white" style="font-size: x-large;">Profile</font>
				</div>
				<div class="panel-body">
					<div class="row">
						<div class="col-sm-4" align="center" style="padding-top: 50">
							<div class="thumbnail-frame2">
								<img class=" thumbnail-img2"
									src="<%=contextPath%>/webtoonDB/member/admin/<%=userimg%>" onerror="this.src='<%=contextPath%>/img/defaultmember.jpg'">
							</div>
						</div>
						<div class="col-sm-8">
							<ul class="list-group list-group-flush">
								<li class="list-group-item"><font class="text-primary"
									style="font-size: xx-large;"><%=nickname%></font></li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4">
											<b>ID</b>
										</div>
										<div class="col-sm-8"><%=memid%></div>
									</div>
								</li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4">
											<b>Account Lv.</b>
										</div>
										<div class="col-sm-8">
											<font color="red"><b>관리자</b></font>
										</div>
									</div>
								</li>
								<li class="list-group-item">
									<div class="row">
										<div class="col-sm-4">
											<b>Sign up</b>
										</div>
										<div class="col-sm-8"><%=adddate%></div>
									</div>
								</li>
							</ul>
							<div align="right">
								<input type="button" class="btn btn-primary" value="회원 정보 수정"
									onclick="location='<%=contextPath%>/member/profileChange.jsp'">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--  -->
		<div id="boards" class="tab-pane fade">
			<!-- 개시판 관리 패널 -->
			<div class="panel panel-default">
				<div class="panel-heading"
					style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
					<font class="text-white" style="font-size: x-large;">Boards</font>
				</div>
				<div class="panel-body">
					<div class="row">
						<div class="col-sm-4">
							<!-- 게시판 리스트 -->
							<div class="panel panel-default">
								<div class="panel-heading">
									<b>Boader List</b>
								</div>
								<div class="panel-body">
									<!-- 게시판 목록 -->
									<div class="list-group">
										<%
											if (list.size() <= 0) {
										%>
										<b class="listgroup-item">게시판이 없습니다.</b>
										<%
											} else {
												for (BoardCategoryBean blbean : list) {
										%>
										<div class ="row">
											<div class="col-sm-8">
												<a href="<%=contextPath%>/boardList.jsp?boardCategoryName=<%=blbean.getBoardCategoryName()%>" class="list-group-item"><%=blbean.getBoardCategoryName()%></a>
											</div>
											<div class="col-sm-4">
												<input type="button" class="btn btn-danger" value="삭제" onclick="location='<%=contextPath%>/admin/boardListDeletePro.jsp?boardCategoryNum=<%=blbean.getNum()%>&boardCategoryName=<%=blbean.getBoardCategoryName()%>'">
											</div>
											
										</div>
										<%}}%>
									</div>
									<!-- 게시판 목록 -->
								</div>
							</div>
						</div>
							<div class="col-sm-8">
								<div class="panel panel-default">
									<div class="panel-heading">
										<b>Boad Add</b>
									</div>
									<div class="panel-body">
										<form method="post"action="<%=contextPath%>/admin/boardAddPro.jsp">
											<!-- 게시판 추가 -->
											<div class="col-xs-6">
												<div class="input-group mb-3">
													<input type="text" value="" name="boardName"
														class="form-control">
													<div class="input-group-append">
														<button class="btn btn-success" type="submit">ADD</button>
													</div>
												</div>
											</div>
											<!-- 게시판 추가 -->
										</form>
									</div>
								</div>
							</div>
					</div>
				</div>
			</div>
		</div>
		<div id="members" class="tab-pane fade">
			<!-- 맴버 관리 패널 -->
			<div class="panel panel-default">
				<div class="panel-heading" style="background-image: url('<%=contextPath%>/img/profilebg.bmp');">
					<font class="text-white" style="font-size: x-large;">Boards</font>
				</div>
				<div class="panel-body">
					<table class="table table-hover">
						<thead class="thead-dark">
							<tr>
								<th>
									<input type="checkbox">
								</th>
								<th>member No.</th>
								<th >ID</th>
								<th>Password</th>
								<th>Type</th>
								<th>Add Date</th>
								<th>Account</th>
							</tr>
						</thead>

						<%if(memList.size() <= 0){ 
						%>
							<tr><td>멤버 목록 없음</td></tr>
						<%
						}else{
							for(MemberBean mbean : memList){
						%>
						<tr>
							<td>
								<input type="hidden" name="memNum" value="<%=mbean.getNum() %>">
							</td>
							<td><%=mbean.getNum() %></td>
							<td><%=mbean.getId() %></td>
							<td><%=mbean.getPasswd() %></td>
							<td><%=mbean.getWtmtype() %></td>
							<td><%=sdf.format(mbean.getAdddate()) %></td>
							<td><input type="button" class="btn btn-danger" value="강제 탈퇴" onclick="location='<%=contextPath%>/admin/memberDeletePro.jsp?&memId=<%=mbean.getId()%>'"></td>
						</tr>
						<%}} %>
					</table>
				
				</div>
			</div>
		</div>
	</div>
<div style="height: 100%"></div>
</div>
<%@include file="../main_bottom.jsp"%>



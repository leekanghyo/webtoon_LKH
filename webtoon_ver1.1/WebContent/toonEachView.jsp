<%@page import="com.sun.org.apache.bcel.internal.generic.SIPUSH"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="list.ListBean"%>
<%@page import="list.ListDao"%>
<%@page import="toon.ToonDao"%>
<%@page import="toon.ContentBean"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<title>Insert title here</title>
<%@include file="main_top.jsp"%>
<%
	String workName = request.getParameter("workName");
	int workNum = Integer.parseInt(request.getParameter("workNum"));
	int episode = Integer.parseInt(request.getParameter("episode"));
	ToonDao toondao = ToonDao.getInstance();
	
	//조회수 증가
	toondao.readCounting(workNum, episode);
	
	ContentBean cbean= toondao.getContent(workNum,episode);
	
	String[] imgs = cbean.getUpload_img().split("/=/");
	
	MemberDao memberdao = MemberDao.getInstance();
	
	String writerImg = memberdao.writerImg(cbean.getWriterId());
	
	ListDao listdao = ListDao.getInstance();
	
	ArrayList<ListBean> llist = listdao.getReply(workName,cbean.getEpisode());
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	
	
	int maxEpisode = toondao.getContentsMaxCount(workNum);
	System.out.println("maxEpisode" + maxEpisode);
%>
<script type="text/javascript">
	
	function replyCheck(){
		var memid = $('input[name=memid]').val();
		
		if(memid == 'null'){
			alert("회원만 덧글을 등록할 수 있습니다.");
			return false;
		}

		if($('textarea[name=content]').val() ==""){
			alert("내용을 입력하세요.");
			return false;
		}
	}
	function like(){
		var memid = $('input[name=memid]').val();
		var workNum = $('input[name=workNum]').val();
		var workName = $('input[name=workName]').val();
		var episode  = $('input[name=episode]').val();

		var whatcontents = workName + episode;
		
		if(memid == 'null'){
			alert("회원만 할 수 있습니다.");
			return false;
		}
		
		$.ajax({
			url : "likePro.jsp",
			data : ({
				memid : memid,
				workName : workName,
				workNum : workNum,
				episode :episode 
			}),
			success : function(data){
				if (jQuery.trim(data) == "already"){
					alert("이미 추천한 웹툰 입니다.");
				}else{
					alert("추천했습니다.");
				}
			}
		});
	}

</script>
<div class="well well-sm">
	<b> <a href="<%=contextPath%>/main.jsp">Main</a> &gt;
		<a href="<%=contextPath%>/toon_week.jsp">작품 일람</a> &gt;
		<a href="<%=contextPath%>/toonEachList.jsp?workNum=<%=workNum%>"><%=workName %></a> &gt;
		제 <%=cbean.getEpisode() %> 화  <%=cbean.getSubtitle() %>
	</b>
</div>
<div class ="toon-grid" align="center">
	<div class="panel panel-default">
		<div class="panel-body">
			<div class="row">
				<div class="col-sm-8" align="left">
					<font class="text-primary" style="font-size: large; font-weight: bold;">
						<%=workName%> - 제 <%=cbean.getEpisode() %> 화 : <%=cbean.getSubtitle() %>
					</font>
				</div>
				<div class="col-sm-4" align="right">
					<%if(cbean.getEpisode() !=1){ %>
						<input type="button" class="btn" value="&laquo; Previous" onclick="location='<%=contextPath%>/toonEachView.jsp?workName=<%=workName%>&workNum=<%=workNum%>&episode=<%=cbean.getEpisode() - 1 %>'">
					<%}%>
					<%if(maxEpisode > cbean.getEpisode()) {%>
						<input type="button" class="btn" value="Next &raquo;" onclick="location='<%=contextPath%>/toonEachView.jsp?workName=<%=workName%>&workNum=<%=workNum%>&episode=<%=cbean.getEpisode() + 1 %>'">
					<%}%>
				</div>
				
			</div>
			<hr>
			<div align="left">
				<font class="text-secondary"><%=cbean.getDescript() %></font><br>
				<font class="text-secondary"> Reply : <%=cbean.getWtcReply()%></font><br>				
				<font class="text-secondary"> Read : <%=cbean.getWtcReadCount()%></font>				
			</div>
			
		</div>
	</div>
	
	<%for(String img : imgs){ %>
	<img class="toon-img" src="<%=contextPath%>/webtoonDB/member/<%=cbean.getWriterId()%>/<%=workName%>/<%=cbean.getEpisode()%>/<%=img%>">
	<br>
	<%}%>
</div>

<div class ="content-grid" align="center"style="margin-top:0px;">
	<hr>
	<div style="height: 25px"></div>
	
	<div class="row" style="width: 50%">
		<div class="col-sm-4">
			<%if(cbean.getEpisode() !=1){ %> <!-- 이전 페이지 -->
				<input type="button" class="btn btn-block" value="&laquo; Previous" onclick="location='<%=contextPath%>/toonEachView.jsp?workName=<%=workName%>&workNum=<%=workNum%>&episode=<%=cbean.getEpisode() - 1 %>'">
			<%}%>
		</div>
		<!-- 추천 -->
		<div class="col-sm-4">
			<b><input type="button" class="btn btn-primary btn-block"value="LIKE" onclick="like()"></b>
		</div>
		<div class="col-sm-4">
			<%if(maxEpisode > cbean.getEpisode()) {%> <!-- 다음 페이지 -->
				<input type="button" class="btn btn-block" value="Next &raquo;" onclick="location='<%=contextPath%>/toonEachView.jsp?workName=<%=workName%>&workNum=<%=workNum%>&episode=<%=cbean.getEpisode() + 1 %>'">
			<%}%>
		</div>
	</div>

	<div style="height: 25px"></div>
	<hr>
	
	<!-- 작가 프로필 -->
	<!-- 작가 프로필 -->
	<div class="panel panel-default">
		<div class="panel-body">
			<div class="row">
				<div class="col-sm-4" align="center" style="">
					<div class="thumbnail-frame2">
						<img class=" thumbnail-img2"src="<%=contextPath%>/webtoonDB/member/<%=cbean.getWriterId() %>/<%=writerImg%>">
					</div>
				</div>
				<div class="col-sm-8" align="left">
					<ul class="list-group list-group-flush">
						<li class="list-group-item">
							<font class="text-primary" style="font-size: large; font-weight: bold;"><%=cbean.getWriterName()%></font>						
						</li>
						<li class="list-group-item">
							<%=cbean.getWriterComment() %>
						</li>
					</ul>
				</div>
			</div>		
		</div>
	</div>
	<!-- 작가 프로필 -->
	<form method="post" action="toonReplyAddPro.jsp" onsubmit="return replyCheck()">
		<input type="hidden" name ="memid" value="<%=memid%>">
		<input type="hidden" name = "nickname" value="<%=nickname%>">
		<input type="hidden" name = "workName" value="<%=workName%>">
		<input type="hidden" name = "workNum" value="<%=workNum%>">
		<input type="hidden" name = "episode" value="<%=cbean.getEpisode()%>">
		
		<div class="panel panel-default">
			<div class="panel-heading" align="left">
				<h3 class="text-primary">Comment</h3>
			</div>
			<div class="panel-body" align="right">
				<p>
				<textarea name="content" class="form-control"></textarea>
				</p>
				<input type="submit" class="btn btn-success" value="작성">
				
			</div>
			<div class="panel-footer">	
				<% if(llist.size() <=0){%>
				<div class="panel panel-default">
					<div class="panel-body">
					<font class="text-secondary">덧글이 없습니다.</font>
					</div>
				</div>				
				<%}else{
				for(ListBean lbean : llist){%>
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="row">
							<div class="col-sm-2" align="left"> <!--아이디 닉네임-->
								<font class="text-primary" style="font-weight: bold;"><%=lbean.getWriterId() %></font>
							</div>
							<div class="col-sm-6" align="left"> <!--내용-->
							<%=lbean.getContent() %>
							</div>
							<div class="col-sm-2"> <!--날짜-->
								<%=sdf.format(lbean.getReg_date())%>
							</div>
							<%if(memid != null && (lbean.getWriterId().equals(memid) || memid.equals("admin"))){%>
							<div class="col-sm-2">
								<input type="button" class="btn btn-danger" value ="삭제" onclick ="location='<%=contextPath%>/deleteReply.jsp?num=<%=lbean.getNum()%>&workName=<%=workName%>&workNum=<%=workNum%>&episode=<%=episode%>'">
							</div>
							<%} %>
						</div>
					</div>
				</div>				
				<%}}%>
			</div>
		</div>
	</form>

</div>

<%@include file ="main_bottom.jsp"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Vector"%>
<%@page import="java.io.File"%>
<%@page import="list.ListBean"%>
<%@page import="list.ListDao"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	
	//공지사항 업로드
	request.setCharacterEncoding("UTF-8");
	
	
	//최초 작성-----------------------------------------------------------------------
	String filePath = config.getServletContext().getRealPath("/webtoonDB/");
	File newPath = new File(filePath);
	if(!newPath.exists()){
		newPath.mkdir();
	}
	filePath = config.getServletContext().getRealPath("/webtoonDB/list");
	newPath = new File(filePath);
	if(!newPath.exists()){
		newPath.mkdir();
	}
	filePath = config.getServletContext().getRealPath("/webtoonDB/list/notice");
	newPath = new File(filePath);
	if(!newPath.exists()){
		newPath.mkdir();
	}
	//------------------------------------------------------------------------------
	
	
	filePath = config.getServletContext().getRealPath("/webtoonDB/list/notice");
	int fileMax = 1024 * 1024 * 100; //파일 용량은 100메가로 제한
	
	MultipartRequest mul = new MultipartRequest(
			request, //객체
			filePath, // 저장 경로
			fileMax, // 용량 한도
			"UTF-8", //인코딩
			new DefaultFileRenamePolicy() //이름 중복 시 처리
			);

	//1차 DB 작성 (공간 확보)
	String listType = mul.getParameter("listType"); // 작성 타입, 메인 공지, 게시판 공지
	String writerId = (String) session.getAttribute("memid"); //작성자
	String writerName = mul.getParameter("nickname");
	
	String subject = mul.getParameter("subject"); //제목
	String content = mul.getParameter("content"); //내용
	
	ListDao dao = ListDao.getInstance();
	ListBean bean = new ListBean();
	
	bean.setListType(listType);
	bean.setWriterId(writerId);
	bean.setWriterName(writerName);
	bean.setSubject(subject);
	bean.setContent(content);
	
	//파일 명 가공
	Enumeration en = mul.getFileNames();
	String img ="";
	

	TreeMap<String, String> imgMap = new TreeMap<String, String>();
	
	while(en.hasMoreElements()){ //값이 없을 때 까지
		String nameTemp1 = (String) en.nextElement(); //file 태그의 name 획득
		String nameTemp2 = (String) mul.getFilesystemName(nameTemp1); //각 배열의 파일 명 획득
		//테이터 입력에 알맞게 파일 명 가공
		//기존 경로에서 모든 파일들을 이동시키기 위함
		
		imgMap.put(nameTemp1,nameTemp2);
	}
	
	//불규칙하게 들어온 순서를 키값 기준오름차순으로 정렬한다.
	Map.Entry<String,String> entry = null;
	while(!imgMap.isEmpty()){
		entry = imgMap.pollFirstEntry(); //가장 낮은 키를 불러오고 제거함
		
		if (entry.getValue() != null){
			img+=entry.getValue() + "/=/";
			//System.out.println(entry.getValue());
		}
	}
	
	//System.out.println("img 1차 가공 정보 : " +img);
	
	
	String[] imgArr = img.split("/=/"); // 이미지 이름을 배열 형으로 나눔
	//--------------------------------------------------
	/* for(int i = 0 ; i < imgArr.length ; i++){
		System.out.println("imgArr[" + i +"]: " + imgArr[i]); //파일명 확인용 Log 
	} */
	//--------------------------------------------------
	
	bean.setImg(img); //이미지 가공 정보
	String returnSeqNum = dao.insertList(bean); //DB등록 후, 시퀀스 번호 획득
	
	String msg ="";
	if(returnSeqNum == null){
		msg +="DB 등록 실패/";
		return;
	}
	
	if(img != ""){
		//파일 생성 직후 주소 입력, 순환하며 이동하기 위해 배열 형으로 선언
		File[] oldf = new File[imgArr.length];
		for(int i = 0; i < imgArr.length ;i++ ){
			//구 주소
			oldf[i] = new File(filePath + "\\" + imgArr[i]);		
		}
		
		//System.out.println("작성 할 폴더 경로 filePath : " + filePath +"\\" + returnSeqNum);
		//신 주소:  발급 받은 seq번호를 기준으로 폴더 생성
		File newf = new File(filePath +"\\" + returnSeqNum);
		for(int i = 0; i < imgArr.length ;i++ ){
			if(!newf.exists()){ //폴더가 존재하지 않는 다면
				newf.mkdir(); //폴더 생성
			}else{
				//폴더가 존재한다면 기존 파일 모두 삭제(메모리 절약)
				File[] oldfiles = newf.listFiles();
				
				for(int j = 0 ; i < oldfiles.length ; j ++){
					//System.out.print("기존 파일 : " + oldfiles[j]);
					oldfiles[i].delete();
					//System.out.println(" Delete");
				}	
			}
		} //for
		
		//구 주소(생성 직후 주소)에서 신 주소로 각각 이동
		for(int i = 0 ; i < imgArr.length ; i++ ){
			if(oldf[i].renameTo(new File(newf, imgArr[i]))){
				//System.out.println("파일 비치 성공  : " + imgArr[i]);
			}else{
				System.out.println("파일 비치 실패  : " + imgArr[i]);

				}
			}//for
	}
	String url = request.getContextPath() + "/noticeList.jsp";
	if(msg.equals("")){
		msg ="정상적으로 등록 되었습니다.";
	}
%>
<script type="text/javascript">
	alert("<%=msg%>");
	location.href="<%=url%>";
	
</script>
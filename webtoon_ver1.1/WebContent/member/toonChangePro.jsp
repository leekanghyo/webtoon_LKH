<%@page import="java.io.File"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Enumeration"%>
<%@page import="toon.ContentBean"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="toon.ToonDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	//각 투고 작품은 회원의 개인 폴더에 저장된다.
	request.setCharacterEncoding("UTF-8");
 	String writerId =(String)session.getAttribute("memid");
	//작품 투고 시점에는 이미 서버에 유저 폴더가 생성되어 있음 최초 파일 업로드
	String filePath = config.getServletContext().getRealPath("/webtoonDB/member/" + writerId);
	int fileSize = 1024 * 1024 * 1000;
	
	MultipartRequest mul = new MultipartRequest(
				request,
				filePath,
				fileSize,
				"UTF-8",
				new DefaultFileRenamePolicy()
			);
	
	//모든 작업 완료 후 페이지 이동용
	int workNum = Integer.parseInt(mul.getParameter("workNum"));
	
	
	//변경되는 정보------------------------------------------------
	String subtitle = mul.getParameter("subtitle");
	String descript = mul.getParameter("descript");
	String writerComment = mul.getParameter("writerComment");
	//---------------------------------------------------------
	
	//폴더 경로 색인용
	int episode = Integer.parseInt(mul.getParameter("episode"));
	String workName = mul.getParameter("workName");
	
	ContentBean cbean = new ContentBean();
	
	//테이블 색인용
	cbean.setWorkName(workName);
	cbean.setEpisode(episode);
	
	//실제 변경 정보
	cbean.setSubtitle(subtitle);
	cbean.setDescript(descript);
	cbean.setWriterComment(writerComment);
	//실제 변경 정보

	
	//이미지 갱신
	Enumeration en = mul.getFileNames();
	String img ="";
	
	
	TreeMap<String, String> imgMap = new TreeMap<String, String>();
	
	System.out.println("nameTemp1--------------------------");
	while(en.hasMoreElements()){ //값이 없을 때 까지
		String nameTemp1 = (String) en.nextElement(); //file 태그의 name 획득
		String nameTemp2 = (String) mul.getFilesystemName(nameTemp1); //각 배열의 파일 명 획득
		//테이터 입력에 알맞게 파일 명 가공
		//기존 경로에서 모든 파일들을 이동시키기 위함
		
		if(!nameTemp1.equals("titleImage")){
			imgMap.put(nameTemp1,nameTemp2);
		}
	}
	//불규칙하게 들어온 순서를 키값 기준오름차순으로 정렬한다.
	Map.Entry<String,String> entry = null;
	while(!imgMap.isEmpty()){
		entry = imgMap.pollFirstEntry(); //가장 낮은 키를 불러오고 제거함
		
		if (entry.getValue() != null){
			img+=entry.getValue() + "/=/";
		}
	}
	
	System.out.println("img 1차 가공 정보 : " +img);
	
	String[] imgArr = img.split("/=/"); // 이미지 이름을 배열 형으로 나눔
	
	cbean.setUpload_img(img);
	
	// DB 수정
	ToonDao toondao = ToonDao.getInstance();	
	
	
	int cnt = toondao.updateContent(cbean);
	
	if(cnt <=0){
		System.out.println("DB 작성 실패");
		return;
	}
	
	File newf = new File(filePath + "\\" + workName + "\\" + episode);
	if(!newf.exists()){ //에피소드 파일이 없다면
		if(newf.mkdir()){
			for (int i = 0 ; i < imgArr.length ; i ++){
				File oldf = new File(filePath +"\\" + imgArr[i]);
				oldf.renameTo(new File(newf,imgArr[i]));
			}
		}
	}else{
		File[] oldfiles = newf.listFiles();
		for(int i =0 ; i < oldfiles.length ; i ++){
			System.out.print("oldfiles[i] : " + oldfiles[i]);
			if(oldfiles[i].delete()){
				System.out.println(" -- 삭제");			
			}
		}
		
		for (int i = 0 ; i < imgArr.length ; i ++){
			File oldf = new File(filePath +"\\" + imgArr[i]);
			oldf.renameTo(new File(newf,imgArr[i]));
		}
	}
	
	String contextPath =request.getContextPath() + "/toonEachList.jsp?workNum=" + workNum;
%>
<script type="text/javascript">
	location.href="<%=contextPath%>";
</script>	

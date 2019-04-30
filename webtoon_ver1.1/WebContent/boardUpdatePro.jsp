<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="list.ListBean"%>
<%@page import="list.ListDao"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String filePath = config.getServletContext().getRealPath("/webtoonDB/list");
	
	int fileMax = 1024 * 1024 * 100; //파일 용량은 100메가로 제한
	
	MultipartRequest mul = new MultipartRequest(
			request, //객체
			filePath, // 저장 경로
			fileMax, // 용량 한도
			"UTF-8", //인코딩
			new DefaultFileRenamePolicy() //이름 중복 시 처리
			);
	
	int boardCategoryNum = Integer.parseInt( mul.getParameter("boardCategoryNum"));
	//DB 객체 생성
	ListDao dao = ListDao.getInstance();
	ListBean bean = new ListBean();
	
	String boardCategoryName = mul.getParameter("boardCategoryName");
	String subject = mul.getParameter("subject"); //제목
	String content = mul.getParameter("content"); //내용
	String deleteStack  = mul.getParameter("deleteStack"); //삭제 할 이미지 //제거 예정
	
	//이미지 정보 외 변경될 정보들을 bean에 입력
	bean.setSubject(subject); //제목
	bean.setContent(content);// 내용
	bean.setWhatcontents(boardCategoryName); //작성 장소
	bean.setNum(boardCategoryNum); // 게시글 카테고리 번호

	//이미지 정렬을 위해 기존 값을 가져옴
	ListBean loadimg = dao.getNotice(boardCategoryNum); //노티스 메서드 명은 차후 변경 예정
	String loadedimg = loadimg.getImg();

	String msg; //결과값 안내에 필요
	String images = ""; //삭제하고 삽입할 파일 정보
	
	File newf;
	//추가한 파일도 없고 모든 기존의 파일이 모두 삭제 되었을 경우 폴더 자체를 삭제하기 위함
	boolean deadFlag = false;
	
	String[] alivef = null;
	try{
		//히든 태그에서 남아있는 delf 값을 모두 불러와 리스트화 함(살아 남아야할 파일 정보들)
		alivef = mul.getParameterValues("delf"); //남아있는 파일이 없을 경우 예외 발생
	}catch(NullPointerException e){
		System.out.println("남겨둘 파일이 없음");
	}
	
	ArrayList<String> aliveflist = new ArrayList<String>();
		
	//System.out.println("살아 남는 파일들");
	if(alivef != null){
		for(int i = 0 ; i < alivef.length ; i ++){
			//System.out.println(alivef[i]);
			aliveflist.add(alivef[i]);
			images += alivef[i]+"/=/";
		}		
	}
	//System.out.println("살아 남는 파일들");
		
	//삭제 수행 --------------------------------------------------
		

	//파일 정보 호출
	
	newf = new File(filePath +"\\" + boardCategoryName);
	if(!newf.exists()){ //폴더가 없으면 생성
		newf.mkdir();
	}	
	
	newf = new File(filePath +"\\" + boardCategoryName + "\\" + boardCategoryNum);
	
	//삭제 수행 --------------------------------------------------
	if(!newf.exists()){ //폴더가 없으면 생성
		newf.mkdir();
	}
	if(newf.exists()){ //경로가 존재할 경우
		//파일 삭제 작업
		File[] delFile = newf.listFiles();
		ArrayList<String> deadFile = new ArrayList<String>(); 
			
		//System.out.println("------------------------------------------------");
		//기존의 DB 데이터를 리스트화
		String[] str =null;
		try{
			str = loadedimg.split("/=/");
			
		}catch(NullPointerException e){
			System.out.println("파일 정보 없음");
		}
		
		List<String> loadedimgList = new ArrayList<String>();
		if(str != null){
			for(int i = 0 ; i < str.length ; i ++){
				loadedimgList.add(str[i]);
			}
				
			//남아있을 파일 그룹의 차집합을 구함-----------
			loadedimgList.removeAll(aliveflist);
			//---------------------------------			
				
			//System.out.println("Dead Files");
			for(int i = 0 ; i < delFile.length ; i ++){
				for(String testColl : loadedimgList){
					//System.out.println(testColl);
						
					if(delFile[i].getName().equals(testColl)){
						//System.out.println("delFile[" + i + "] :" + delFile[i]);
						delFile[i].delete();
						//System.out.println("삭제");
					}
				}
			}
		}
		if (loadedimgList.isEmpty()){
			//기존의 모든 파일이 삭제 되었을 경우
			deadFlag = true;
		}
		//System.out.println("------------------------------------------------");
		
	}

	//System.out.println("삽입 과정-------------------------------");

	//삽입 DB 데이터용으로 가공 및 이동 작업
	Enumeration en = mul.getFileNames(); //새로 추가한 파일 이름 배열화
	
	// Enumeration 특성상 불규칙한 순서로 오는 것을 정렬하기 위한 객체
	TreeMap<String, String> imgMap = new TreeMap<String, String>();
	
	//getFileNames 전체를 순환
	while(en.hasMoreElements()){ //값이 없을 때 까지
		String nameTemp1 = (String) en.nextElement(); //file 태그의 name 획득
		String nameTemp2 = (String) mul.getFilesystemName(nameTemp1); //각 배열의 파일 명 획득

		//기존 경로에서 모든 파일들을 이동시키기 위함
		//System.out.println("nameTemp2 : " + nameTemp1 + "/" + nameTemp2);
		//획득한 파일 명을 우선 맵에 삽입
		imgMap.put(nameTemp1,nameTemp2);
	}

	//불규칙하게 들어온 순서를 키값 기준오름차순으로 정렬한다.
	Map.Entry<String,String> entry = null;
	
	//신규 파일, 위 try문이 기능하지 않을 경우를 대비해 재차 선언
	newf = new File(filePath +"\\" + boardCategoryName + "\\" + boardCategoryNum);
	
	while(!imgMap.isEmpty()){
		entry = imgMap.pollFirstEntry(); //가장 낮은 키를 불러오고 제거함 즉 오름 차순으로 정렬하는 효과
		
		if (entry.getValue() != null){
			//이미지가 없는 게시글이었는데, 생긴 경우 폴더 생성
			if(!newf.exists()){newf.mkdir();}
			
			images+=entry.getValue() + "/=/";
			//System.out.println(entry.getValue());
			
			File oldf = new File(filePath +"\\" + entry.getValue());
			
			oldf.renameTo(new File(newf,entry.getValue())); //파일 이동
		}
	}
	
	//기존에 있던 삭제하지 않을 데이터를 포함한 결과 값
	//System.out.println("noticeWritePro.jsp----------------------------------------");
	//System.out.println("img 가공  정보 : " +images);
	//System.out.println("noticeWritePro.jsp----------------------------------------");
	
	bean.setImg(images); //이미지 정보
	
	
	
	if(newf.exists()){// 폴더 자체는 존재하는데
		if (deadFlag == true && images == ""){
			//기존의 모든 파일도 삭제 되었고 추가한 파일도 없을 경우  폴더 삭제
			newf.delete();
		}
	}
	
	//삭제하거나 추가할 파일이 아무것도 없을 경우 기존 값을 그대로 사용함
	if(images == ""){
		bean.setImg(images);
	}

	int cnt = dao.updateNotice(bean);
		
	if(cnt > 0){
		msg = "수정했습니다.";
	}else{
		msg = "수정 실패했습니다.";
	}
	
	String contextPath = request.getContextPath();
%>
<script type="text/javascript">
	alert("<%=msg%>");	


	location.href="<%=contextPath%>/boardList.jsp?boardCategoryNum=<%=boardCategoryNum%>&boardCategoryName=<%=boardCategoryName%>";
</script>

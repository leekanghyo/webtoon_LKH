<%@page import="member.MemberBean"%>
<%@page import="member.MemberDao"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	//최초 작성---------------------------------------------------------------
	String filePath = config.getServletContext().getRealPath("/webtoonDB/");
	File newPath = new File(filePath);
	if(!newPath.exists()){
		newPath.mkdir();
	}
	filePath = config.getServletContext().getRealPath("/webtoonDB/member");
	newPath = new File(filePath);
	if(!newPath.exists()){
		newPath.mkdir();
	}
	//최초 작성---------------------------------------------------------------
	
	
	int fileMax = 1024 * 1024 * 100; //파일 용량은 10메가로 제한

	MultipartRequest mul = new MultipartRequest(
			request, //객체
			filePath, // 저장 경로
			fileMax, // 용량 한도
			"UTF-8", //인코딩
			new DefaultFileRenamePolicy() //이름 중복 시 처리
			);
	
	String fileSaveName = mul.getFilesystemName("userimg");
	
	String id = mul.getParameter("id");//작가 라면 아이디를 토대로 폴더를 만드는데 사용
	String returnMsg;
	String returnUrl;
	
	//작가인 경우 즉, 이미지가 올라온 경우
	if(fileSaveName != null){
		//생성 직후 주소
		String oldPath = filePath ;
		//경로 획득
		File oldf = new File(oldPath+"\\" + fileSaveName);
		
		//주소에 작가 아이디 폴더를 생성
		filePath += "/" + id;
		File newf = new File(filePath);
		if(!newf.exists()){
			newf.mkdir();
		}else{
			//예외 만약 파일이 있다면 모두 삭제
			File[] oldfiles = newf.listFiles();
			for(int i =0 ; i < oldfiles.length ; i ++){
				//System.out.print("기존 파일 : " + oldfiles[i]);
				oldfiles[i].delete();
				//System.out.println(" Delete");
			}
		}
		//-----------------------
		
		//System.out.println("memberAddPro.jsp --------------");
		//System.out.println("옛 주소 : " + oldf );
		//System.out.println("새 주소 : " +newf);
		
		//파일 이동
		if(oldf.renameTo(new File(newf, fileSaveName))){
			//System.out.println("파일 비치 성공");
		}else{
			System.out.println("파일 비치 실패");		
			//System.out.println("-------------------------------");
		}
	}

	//공통 사항
	//db작업
	MemberDao dao = MemberDao.getInstance();
	MemberBean bean = new MemberBean();
	
	//나머지 프로필 정보
    String name = mul.getParameter("name");
    String passwd = mul.getParameter("passwd");
    String wtmtype = mul.getParameter("wtmtype");
    String userimg = mul.getFilesystemName("userimg"); //작가 전용 없을 경우 null
	
	bean.setId(id);
    bean.setName(name);
    bean.setPasswd(passwd);
    bean.setWtmtype(wtmtype);
    bean.setUserimg(userimg);
	
    int cnt = dao.insertMember(bean);
    if(cnt >0){
    	System.out.println("DB 입력 성공");
		returnMsg ="가입에 성공했습니다.";
		
		//추후 로그인 작업 진행
		returnUrl ="../main.jsp";
		//---------------
    }else{
    	System.out.println("DB 입력 실패");	  
		returnMsg ="가입에 실패했습니다.";
		returnUrl ="memberAdd.jsp?wtmtype=" + wtmtype;
    }
	
%>
<script>
	alert("<%=returnMsg%>");
	var login = confirm("지금 로그인 하시겠습니까?");
	
	if (login){
		<%
			session.setAttribute("memid", id);
			session.setAttribute("mempw", passwd);
		%>		
		location.href="<%=returnUrl%>";	
	}else{
		location.href="<%=returnUrl%>";	
	}
</script>

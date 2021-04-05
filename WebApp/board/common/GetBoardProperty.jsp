<%@ page import="kr.co.kcc.bf.config.*" %>

<%
	/* 게시판 종류 Property를 가져온다.*/
	String noticeBoard = "";			//게시판 - 공지사항 
	String freeBoard = "";				//게시판 - 자유게시판
	String dataBoard = "";				//게시판 - 자료실
	String qnaBoard = "";				//게시판 - 묻고답하기 
	String reportBoard = "";			//게시판 - 보도자료
	
	String allNoticeBoard = "";		//포럼 전체 공지사항 
	String allFreeBoard = "";			//포럼 전체 게시판  

	String webPath = "";					//웹루트 경로
	String uploadPath = "";				//첨부파일 저장할 디렉토리 (절대경로)
	
	String fileMaxSize = "";				//첨부파일 최대크기
	String boardMaxCnt = "";			//개별포럼 게시판 최대 갯수 
	int intKBSize = 0;						//KB로 계산한 첨부파일 최대크기 
	
	String  noticeDataCnt = "";		//문의게시판 공지사항 갯수 
	
	try {
	
		Config objConfig = PropertyConfig.getInstance();
		
		noticeBoard = objConfig.get("board.noticeBoard");
		freeBoard = objConfig.get("board.freeBoard");
		dataBoard = objConfig.get("board.dataBoard");
		qnaBoard = objConfig.get("board.qnaBoard");
		reportBoard = objConfig.get("board.reportBoard");
		
		allNoticeBoard = objConfig.get("board.forumAllNotice");
		allFreeBoard = objConfig.get("board.forumAllFree");

		webPath = objConfig.get("nads.dsdm.webapp.path");  
		uploadPath = objConfig.get("upload.filePath");  
		
		boardMaxCnt = objConfig.get("forum.board.maxcnt");  
		
		fileMaxSize = objConfig.get("board.fileMaxSize");  
		//첨부파일 최대용량 KB계산
		float fltSize = (Integer.valueOf(fileMaxSize).floatValue())/1048576;
		if(fltSize < 1){
			intKBSize = 1;
		} else {
			 intKBSize = Math.round(fltSize);
		}
		
		noticeDataCnt = objConfig.get("board.noticeData.maxCnt");
		
	} catch (ConfigException objConfigEx) {
		
		//Common.properties에 있는 기본값을 넣어준다.
		noticeBoard = "001";
		freeBoard = "002";
		dataBoard = "003";
		qnaBoard = "004";
		reportBoard = "005";
		
		allNoticeBoard = "998";
		allFreeBoard = "999";

		webPath = "C:/bea/user_projects/domains/NADSDomain/applications/NADS/DSDM/WebApp";
		uploadPath = "/upload/";
		
		boardMaxCnt = "5";
		
		fileMaxSize = "5242880";
		//첨부파일 최대용량 KB계산
		float fltSize = (Integer.valueOf(fileMaxSize).floatValue())/1048576;
		if(fltSize < 1){
			intKBSize = 1;
		} else {
			 intKBSize = Math.round(fltSize);
		}
	
	}
%>
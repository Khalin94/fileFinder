<%@ page import="kr.co.kcc.bf.config.*" %>

<%
	/* �Խ��� ���� Property�� �����´�.*/
	String noticeBoard = "";			//�Խ��� - �������� 
	String freeBoard = "";				//�Խ��� - �����Խ���
	String dataBoard = "";				//�Խ��� - �ڷ��
	String qnaBoard = "";				//�Խ��� - ������ϱ� 
	String reportBoard = "";			//�Խ��� - �����ڷ�
	
	String allNoticeBoard = "";		//���� ��ü �������� 
	String allFreeBoard = "";			//���� ��ü �Խ���  

	String webPath = "";					//����Ʈ ���
	String uploadPath = "";				//÷������ ������ ���丮 (������)
	
	String fileMaxSize = "";				//÷������ �ִ�ũ��
	String boardMaxCnt = "";			//�������� �Խ��� �ִ� ���� 
	int intKBSize = 0;						//KB�� ����� ÷������ �ִ�ũ�� 
	
	String  noticeDataCnt = "";		//���ǰԽ��� �������� ���� 
	
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
		//÷������ �ִ�뷮 KB���
		float fltSize = (Integer.valueOf(fileMaxSize).floatValue())/1048576;
		if(fltSize < 1){
			intKBSize = 1;
		} else {
			 intKBSize = Math.round(fltSize);
		}
		
		noticeDataCnt = objConfig.get("board.noticeData.maxCnt");
		
	} catch (ConfigException objConfigEx) {
		
		//Common.properties�� �ִ� �⺻���� �־��ش�.
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
		//÷������ �ִ�뷮 KB���
		float fltSize = (Integer.valueOf(fileMaxSize).floatValue())/1048576;
		if(fltSize < 1){
			intKBSize = 1;
		} else {
			 intKBSize = Math.round(fltSize);
		}
	
	}
%>
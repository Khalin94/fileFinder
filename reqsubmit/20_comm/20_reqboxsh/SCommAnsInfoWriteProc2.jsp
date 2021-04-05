<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>
<%@ page import="java.io.*, java.util.*" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.*" %>
<%@ page import="nads.lib.reqsubmit.EnvConstants" %>

<link href="/css/global.css"  rel="stylesheet" type="text/css" />

<%
	/*
	 *******************************************************************************************
	 * 등록폼에서 선택된 유형에 따라서 처리 작업을 다르게 진행한다.
	 * 물론, 해당하는 요구 ID를 필수로 입력받아야 하며 선택된 답변 유형에 따라서 파라미터 NULL 체크를 다르게 해주자
	 * 파일 업로드 컴퍼넌트를 사용하자. 아마도 MultipartRequest를 쓰겠지...
	 * 혹시 통계 또는 LOG 관련한 테이블이 있음 친절하게 해당 데이터를 INSERT 같이 해 주자
	 *******************************************************************************************
	 */

	String tmpPath = null; // 임시 저장소 절대 경로
	String reqID = null; // 요구 ID
	String reqBoxID = null; // 요구함 ID
	String ansType = null; // 답변 유형
	String originFile = null; // 원본 문서명
	String pdfFile = null; // PDF 파일명
	String ansOpinion = null; // 제출 의견
	String realSavePath = null; // 실제로 저장될 폴더의 절대 경로(Windows경로)
	String nowYear = null; // 시스템의 현재 년도
	String idxFileName = null; // 추출된 txt 파일명
	String signData = null; // 전자 서명 정보
	String openCL = null; // 공개여부
	String ansrID = null; // 입력자 ID
	 
	try {
	
		// 필요한 함수를 사용할 Delegate 정의
		// SLSubmitDocumentDelegate selfDelegate = new SLSubmitDocumentDelegate();
		SMemAnsInfoDelegate selfDelegate = new SMemAnsInfoDelegate();
	 
		tmpPath = EnvConstants.WIN_TEMP_SAVE_PATH; // 파일 저장 경로. 나중에는 어딘가에 설정되어지겠죠
		
		// 나중에 사용 될 저장용 폴더 생성을 위해서 미리 구해 놓는다. 내가 구해줄게!!!
		Calendar now = Calendar.getInstance();
 		nowYear = String.valueOf(now.get(Calendar.YEAR));
		
		reqID = request.getParameter("ReqID");
		reqBoxID = request.getParameter("ReqBoxID");
		ansType = request.getParameter("ansType");
		ansOpinion = StringUtil.toMulti(request.getParameter("ansOpinion"));
		originFile = StringUtil.toMulti(request.getParameter("originFile"));
		pdfFile = StringUtil.toMulti(request.getParameter("pdfFile"));
		signData = StringUtil.toMulti(request.getParameter("signData"));
		openCL = request.getParameter("openCL");
		ansrID = StringUtil.toMulti(request.getParameter("ansrID"));
		
		// 인코딩 바꿔야 하나???
		//System.out.println(ansOpinion);
		//System.out.println(originFile);
		//System.out.println(pdfFile);
		//System.out.println(signData);
		
		
		// 요구ID가 NULL이면 안된다. 절대로~~. 다른 것들 중에서도 없음 안되는 것들이 있다. 체크하자.
		if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(reqID))) {
		 	out.println("요구 ID가 없습니다. 답변을 제출하실 수 없습니다.");
	 	} else if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(ansType))) {
			out.println("선택된 답변 유형이 없습니다. 답변을 제출하실 수 없습니다.");
		} else if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(reqBoxID))) {
			out.println("요구함 ID가 없습니다. 답변을 제출하실 수 없습니다.");
	 	} else if ("".equalsIgnoreCase(signData)) { // 여기 까지 왔는데 이게 없음 안돼지..
	 		out.println("Sign Data가 없습니다. 현재 단계에서는 없음 안돼부러~");
	 	}
	 	
 		// 파일관련 작업 3총사 등장
 		// 작업. 1. 하일라이트 색인을 하자
 		// 나중에 문규씨가 wrapping class를 만들어 주문 바꿀기라예~ 어서 바꿔주이소~
 		int HLSuccess = selfDelegate.setHLIndex(pdfFile);
 		if (HLSuccess < 1) {
 			out.println("등록된 PDF 파일의 하일라이트 색인 과정에서 에러가 발생했습니다.");
 		}
	 		
 		// 작업.2. Full Text 색인을 위한 TXT 파일을 추출하자
 		idxFileName = selfDelegate.getIdxFile(pdfFile);
 		if ("".equalsIgnoreCase(idxFileName)) {
 			out.println("TXT 파일 추출작업에서 에러가 발생했습니다.");
 		}
	 			 		
 		// 파일명으로 생성할 답변 ID의 시퀀스 넘버를 받아오자.
 		String ansInfoID = selfDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
 		
		// TBDS_ANS_FILE_INFO의 SEQUENCE를 받아온다.
		String ansFileID = selfDelegate.getSeqNextVal("TBDS_ANS_FILE_INFO");
	 			 		
 		// 우선은 파일을 진짜 진짜 저장 위치로 복사?이동? 시키자
 		// 폴더 저장 구조를 상기시키자 ==> 약속된 저장소 + 연도 + 요구함ID
 		realSavePath = EnvConstants.UNIX_SAVE_PATH+nowYear+"/"+StringUtil.padl(reqBoxID, 10)+ "/";
 		
 		// 만약 저장하고자 하는 폴더가 생성이 안된 경우에는 만들어주자
		FileUtil.prepareFolder(realSavePath);
		
		// 이동시킬 새로운 파일명을 생성하자. 너에게 새로운 인생을...... -ㅅ-
		String newOriginFileName = StringUtil.padl(ansFileID, 10)+"."+originFile.substring(originFile.lastIndexOf('.')+1, originFile.length());
		String newPdfFileName = StringUtil.padl(ansFileID, 10)+".pdf";
		String newIdxFileName = StringUtil.padl(ansFileID, 10)+"."+idxFileName.substring(idxFileName.lastIndexOf('.')+1, idxFileName.length());
		
		//System.out.println("New Origin File Name : " + newOriginFileName);
		//System.out.println("New PDF File Name : " + newPdfFileName);
		//System.out.println("New HL Index File Name : " + newIdxFileName);
			
 		// 지정된 저장소에 약속된 파일명으로 복사를 하자.
 		boolean success1 = FileUtil.copyFile(tmpPath+originFile, realSavePath+newOriginFileName);
 		boolean success2 = FileUtil.copyFile(tmpPath+pdfFile, realSavePath+newPdfFileName);
 		boolean success3 = FileUtil.copyFile(tmpPath+idxFileName, realSavePath+newIdxFileName);
 		// 나중에 아주 먼 훗 날에 하일라이트 인덱스 관련된 파일을 따로 빼내서 저장 관리하는 API가 구부장님을 통해서
 		// 완성된다면.. 그때는 파일 복사 성공 여부를 하나 더 체크해 줘야 할 것이다...
	 		
 		if (success1 && success2 && success3) { // 셋 다 성공해야 다음 프로세스를 진행하지...
 		
 			Vector paramI = new Vector();
 			Vector paramII = new Vector();
 			
 			// insertAnsFileInfo() parameter Vector
 			paramI.add(ansFileID); // 1
			paramI.add(nowYear+"/"+StringUtil.padl(reqBoxID, 10)+"/"+newPdfFileName); // 2
			paramI.add(nowYear+"/"+StringUtil.padl(reqBoxID, 10)+"/"+newOriginFileName); // 3
			paramI.add(signData); // 4
			paramI.add(EnvConstants.UNIX_SAVE_PATH+nowYear+"/"+StringUtil.padl(reqBoxID, 10)+"/"+newIdxFileName); // 5
			
			// insertAnswerInfo parameter Vector
			paramII.add(ansInfoID); 				// 1
			paramII.add(reqID); 						// 2
			paramII.add(ansFileID); 				// 3
			paramII.add(ansrID); 					// 4
			paramII.add(ansOpinion); 				// 5
			paramII.add(ansType); 					// 6
			paramII.add(openCL); 					// 7
			paramII.add(""); 							// 8 - 매체 유형
			paramII.add(""); 							// 9 - 발송 방법
			 			
 			int dbSuccess1 = selfDelegate.insertAnsFileInfo(paramI);
 			int dbSuccess2 = selfDelegate.insertAnswerInfo(paramII);
 			
 			if (dbSuccess1 > 0 && dbSuccess2 > 0) {
 				out.println("<script>alert('답변 등록을 정상적으로 완료하였습니다.');</script>");
 				out.println("<meta http-equiv='refresh' content='0; url=SMakeReqInfoVList.jsp?ReqID="+reqID+"&ReqBoxID="+reqBoxID+"'>");
 			} else {
 				out.println("<script>alert('Sorry.............. Check Error..... and Please, try again.. ');</script>");
 			}
 			
	 	} else {
	 		out.println("파일 복사 과정 중 에러 발생");
	 	}
		
	 } catch(IOException e) {
	 	out.println("IOException : " + e.getMessage());
	 } catch(Exception e) {
	 	out.println("Exception : " + e.getMessage());
	 }
%>

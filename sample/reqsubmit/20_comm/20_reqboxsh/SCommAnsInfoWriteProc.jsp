<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>
<%@ page import="java.io.*, java.util.*" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.lib.reqsubmit.EnvConstants" %>
<%@ page import="kr.co.kcc.pf.ejb.EJBExtendException" %>

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
	String savePath = null; // 저장 경로
	int sizeLimit = 0; // 업로드 제한 크기
	String reqID = null; // 요구 ID
	String reqBoxID = null; // 요구함 ID
	String ansType = null; // 답변 유형
	String originFile = null; // 원본 문서명
	String pdfFile = null; // PDF 파일명
	String matType = null; // 매체 유형
	String sendWay = null; // 발송 유형
	String ansOpinion = null; // 제출 의견
	String realSavePath = null; // 실제로 저장될 폴더의 절대 경로(Windows경로)
	String nowYear = null; // 시스템의 현재 년도
	String idxFileName = null; // 추출된 txt 파일명
	String msgDigest = null; // Msg Digest
	String aSignFile = null; // 전자서명 관련 정보 파일
	String openCL = null; // 공개여부
	String ansrID = null; // 입력자 ID
	
	Vector param = new Vector(); // 전자문서의 경우는 필요없지만, 비전자문서, 해당기관아님의 경우에는 본 페이지에서 바로 INSERT
	
	try {
	
		CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
		FileUtil fuBean = new FileUtil();
	 
		savePath = EnvConstants.WIN_TEMP_SAVE_PATH; // 파일 저장 경로. 나중에는 어딘가에 설정되어지겠죠
		
		// 만약 저장하고자 하는 폴더가 생성이 안된 경우에는 만들어주자
		FileUtil.prepareFolder(savePath);
		
		// 오래된 파일들은 용서하지 않겠다!
		fuBean.DeloldFile(savePath);
		
		// 나중에 사용 될 저장용 폴더 생성을 위해서 미리 구해 놓는다. 내가 구해줄게!!!
		Calendar now = Calendar.getInstance();
 		nowYear = String.valueOf(now.get(Calendar.YEAR));
		
		sizeLimit = 50 * 1024 * 1024 ; // 50메가까지만 사이즈 제한을 주겠다. 물론 더 줄수도 있지만...
		
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "EUC-KR");
		// MultipartRequest 의 특징이라구 하면... 내가 생각하는 단점이라구 하면...
		// 객체의 생성과 동시에 해당하는 파일의 업로드를 동시에 진행한다라는 것이다.
		// 안타까움... 필요로 하는 파라미터를 분리시키기두 전에 이미 파일은 올라가버리니..
		// 자칫 잘못 하면 쓸데없는 파일들의 쓰레기들이 생겨날 수도 있지 않을까 하는.. 잡념.. 
		// 떽! 코딩이나 열심히 하자구요~ 그러자구요~
		
		reqID = multi.getParameter("CommReqID");
		reqBoxID = multi.getParameter("ReqBoxID");
		ansType = multi.getParameter("ansType");
		ansOpinion = multi.getParameter("ansOpinion");
		openCL = multi.getParameter("openCL");
		ansrID = multi.getParameter("ansrID");
		
		// 요구ID가 NULL이면 안된다. 절대로~~. 다른 것들 중에서도 없음 안되는 것들이 있다. 체크하자.
		if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(reqID))) {
			out.println("요구 ID가 없습니다. 답변을 제출하실 수 없습니다.");
		 	//throw new EJBExtendException("요구 ID가 없습니다. 답변을 제출하실 수 없습니다.");
	 	} else if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(ansType))) {
			out.println("선택된 답변 유형이 없습니다. 답변을 제출하실 수 없습니다.");
			//throw new EJBExtendException("선택된 답변 유형이 없습니다. 답변을 제출하실 수 없습니다.");
		} else if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(reqBoxID))) {
			out.println("요구함 ID가 없습니다. 답변을 제출하실 수 없습니다.");
			//throw new EJBExtendException("요구함 ID가 없습니다. 답변을 제출하실 수 없습니다.");
	 	}
	 	
	 	// 파일 유형에 따라서 파라미터를 설정하고 나머지 프로세스를 처리하도록 하자
	 	if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(ansType)) { // '전자 파일'의 경우
	 		
	 		originFile = multi.getFilesystemName("originFile");
	 		pdfFile = multi.getFilesystemName("pdfFile");
	 		
	 		msgDigest = objAnsInfo.getMsgDigest(savePath+pdfFile);

			out.println("<form method='post' name='autoForm' action=''>\n");
			out.println("<input type='hidden' name='signData' value=''>\n");
			out.println("<input type=\"hidden\" name=\"ReqBoxID\" value=\""+reqBoxID+"\">\n");
			out.println("<input type=\"hidden\" name=\"ReqID\" value=\""+reqID+"\">\n");
			out.println("<input type=\"hidden\" name=\"ansType\" value=\""+ansType+"\">\n");
			out.println("<input type=\"hidden\" name=\"originFile\" value=\""+originFile+"\">\n");
			out.println("<input type=\"hidden\" name=\"pdfFile\" value=\""+pdfFile+"\">\n");
			out.println("<input type=\"hidden\" name=\"ansOpinion\" value=\""+ansOpinion+"\">\n");
			out.println("<input type=\"hidden\" name=\"openCL\" value=\""+openCL+"\">\n");
			out.println("<input type=\"hidden\" name=\"ansrID\" value=\""+ansrID+"\">\n");
			out.println("</form>\n");
			out.println("<DIV id=\"loadingDIV\" style=\"position:relative; left:0px;top:0px;width:500; z-index:1; border-width:0px; border-style:none; display:none; \">");
			out.println("<CENTER><p><br></p><p><br></p><p><br></p><p><br></p>");
			out.println("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border:1px solid #c0c0c0\">");
			out.println("<tr><td width=\"250\" height=\"100\" align=\"center\"><img src=\"/reqsubmit/image/loading6.gif\" border=\"0\"></td>");
			out.println("</tr></table></DIV></CENTER>");
%>
<html>
<head>
<title>NADS</title>
<script language="vbscript" src="/js/activex.vbs"></script>
<script language="javascript" src="/js/axkcase.js"></script>
<script language="javascript">
	function NADSEncryptDigest() {
		var encdigetdata;
		if(!CheckAX()) {
			alert("클라이언트 프로그램이 설치되지 않아 수행할 수 없습니다.");
			return;
		}
		var dn = document.AxKCASE.SelectCert();
		if ((dn == null) || (dn == "")) {
			if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
			return false;
		}
		encdigetdata = document.AxKCASE.EncryptedDigest(dn, "", '<%= msgDigest %>');
		
		if((encdigetdata == null) || (encdigetdata == "")) {
			if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
			return;
		}
		
		autoSubmit(encdigetdata);
	}
	
	function autoSubmit(str) {
		var f = document.autoForm;
		f.signData.value = str;
		f.action = "SCommAnsInfoWriteProc2.jsp";
		f.submit();		
		document.all.loadingDIV.style.display = '';
	}
</script>
</head>

<body onLoad="javascript:NADSEncryptDigest();">

<script language="javascript" src="/js/AxNAROK2.js"></script>

</body>

</html>

<%
	 	} else if (CodeConstants.ANS_MTD_ETCS.equalsIgnoreCase(ansType)) { // '비전자 파일' 의 경우
	 	
	 		matType = multi.getParameter("matType");
			sendWay = multi.getParameter("sendWay");
			
			//System.out.println("발송 방법 : " + sendWay);
			
			// 파일명으로 생성할 답변 ID의 시퀀스 넘버를 받아오자.
	 		String ansInfoID = objAnsInfo.getSeqNextVal("TBDS_ANSWER_INFO");
	 		
	 		// insertAnswerInfo parameter Vector
	 		param.add(ansInfoID); 				// 1
			param.add(reqID); 					// 2
			param.add(""); 							// 3
			param.add(ansrID); 					// 4
			param.add(ansOpinion);				// 5
			param.add(ansType); 				// 6
			param.add(openCL); 					// 7
			param.add(matType);				// 8 - 매체 유형
			param.add(sendWay);				// 9 - 발송 방법
			
			int dbSuccess = objAnsInfo.insertAnswerInfo(param);
			
			if (dbSuccess > 0) {
				out.println("<script>alert('비전자 문서 답변 제출을 정상적으로 완료하였습니다.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url=SMakeReqInfoVList.jsp?ReqID="+reqID+"&ReqBoxID="+reqBoxID+"'>");
			} else {
				out.println("<script>alert('oh.. sorry.. Please, Check the Error Message.....T_T');</script>");
			}
				 	
	 	} else if (CodeConstants.ANS_MTD_NONE.equalsIgnoreCase(ansType)) { // '해당기관없음'의 경우
	 	
	 		// 파일명으로 생성할 답변 ID의 시퀀스 넘버를 받아오자.
	 		String ansInfoID = objAnsInfo.getSeqNextVal("TBDS_ANSWER_INFO");
	 		
	 		// insertAnswerInfo parameter Vector
	 		param.add(ansInfoID); 				// 1
			param.add(reqID); 					// 2
			param.add(""); 							// 3
			param.add(ansrID); 					// 4
			param.add(ansOpinion);				// 5
			param.add(ansType); 				// 6
			param.add(openCL); 					// 7
			param.add("");				// 8 - 매체 유형
			param.add("");				// 9 - 발송 방법
			
			int dbSuccess = objAnsInfo.insertAnswerInfo(param);
			
			if (dbSuccess > 0) {
				out.println("<script>alert('요구 내용에 해당하는 기관이 아님을 통보하였습니다.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url=SMakeReqInfoVList.jsp?ReqID="+reqID+"&ReqBoxID="+reqBoxID+"'>");
			} else {
				//throw new EJBExtendException("oh.. sorry.. Please, Check the Error Message.....T_T");
				out.println("oh.. sorry.. Please, Check the Error Message.....T_T");
			}
	 	
	 	} else { // 그 외의 모든 경우은 없응께 돌려보내더라고~
			//throw new EJBExtendException("선택하신 답변 유형은 존재하지 않습니다.");
			out.println("선택하신 답변 유형은 존재하지 않습니다.");
	 	}

	 } catch(IOException e) {
	 	//throw new EJBExtendException("IOException : " + e.getMessage(), e);
		out.println(e.getMessage());
		System.out.println(e.getMessage());
		e.printStackTrace();
	 } catch(Exception e) {
	 	//throw new EJBExtendException("Exception : " + e.getMessage(), e);
		out.println(e.getMessage());
		System.out.println(e.getMessage());
		e.printStackTrace();
	 }
%>

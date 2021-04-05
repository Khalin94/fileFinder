<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.reqsubmit.util.*"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.common.pdfviewdelegate.PdfViewDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoEditForm" %>
<%@ page import = "java.io.*" %>

<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strPluralYn = request.getParameter("PluralYn");
 //Runtime.getRuntime().runFinalization();
 //이용자 정보 설정.
 long lasttime=session.getLastAccessedTime();

 long createdtime=session.getCreationTime();

 long time_used=(lasttime-createdtime)/60000;
 System.out.println("sessiontimeout : "+time_used+"분");
 System.out.println("sessionip : "+request.getHeader("Proxy-Client-IP"));

 String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);

 if(strUserID==null || strUserID.equals("")){
 	//throw new ReqsubmitException(request.getRequestURI(),"NoSessionUserInfo","사용자 ID가 세션에 존재하지 않네요");
 	//strUserID="tester1";//세션에서 받을 사용자 ID Test용. ※※※ 테스트 끝에 삭제 요망.
 }
 UserInfoDelegate objUserInfo=(UserInfoDelegate)session.getAttribute(CodeConstants.USER_INFO_DELEGATE);
 if(objUserInfo==null){
 	//objUserInfo=new UserInfoDelegate(strUserID);
 	objUserInfo=new UserInfoDelegate(request);
 	session.setAttribute(CodeConstants.USER_INFO_DELEGATE,(Object)objUserInfo);
 }

// 답변파일의 조회자가 요구자일 경우 답변조회여부 FLAG 를 'N'->'Y' 로 수정

    SMemAnsInfoEditForm objParamForm = new SMemAnsInfoEditForm();	

	String strTopIsRequesterGbn = (String)session.getValue("IS_REQUESTER");

	if("true".equals(strTopIsRequesterGbn)){

		// 파라미터가 정상적으로 넘어온건지 확인해보자
		boolean blnParamCheck = false;
		blnParamCheck = objParamForm.validateParams(request);
		if(!blnParamCheck) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSPARAM-0000");
			objMsgBean.setStrMsg(objParamForm.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
		} // end if

		String strAnsID = String.valueOf(objParamForm.getParamValue("paramAnsId"));				

		//int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo_view(objParamForm);
		//if (intUpdateResult < 1) {
		//	throw new AppException("요구자 답변 조회 여부 업데이트가 정상적으로 처리되지 못했습니다. 확인바랍니다.");
		//}
	}
%>

<%
  Hashtable objHashtable = null;
  String strReqCont = null;
  String strPdfFilePath = null;
  String strDocFilePath = null;
  String strHttpFilePath = null;
  String strfilename = null;
  String strSubmtGbn = null; 	//정부제출자료 코드구분
  String  strTOCFilePath = null; //정부제출자료 TOC파일패스


  Vector  objPdfFilePath  = null;
  Vector  objDocFilePath  = null;
  int intResult = 0;
  String strCntNum = null;

  String strAnsId =  request.getParameter("paramAnsId");
  String strREQSEQ = request.getParameter("REQSEQ");
  String SubmtOrganNm = request.getParameter("SubmtOrganNm");

  //실제파일명 저장 20170818
  AnsInfoDelegate selfDelegate = new AnsInfoDelegate();
  ResultSetSingleHelper objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strAnsId));   
  
  String strPdfFileName = (String)objRsSH.getObject("PDF_FILE_NAME");
  String strOrgFileName = (String)objRsSH.getObject("ORG_FILE_NAME");
  
  System.out.println("kangthis logs ReqFileOpen2.jsp strPdfFileName => " + strPdfFileName);
  System.out.println("kangthis logs ReqFileOpen2.jsp strOrgFileName => " + strOrgFileName);
  
  String strDoc =  request.getParameter("DOC");
  //System.out.println("[RegFileOpen] strAnsId =" + strAnsId + "\n");
  //System.out.println("[RegFileOpen] strDoc =" + strDoc);
  //strAnsId = "1"; // 답변 ID

  PdfViewDelegate PdfDelegate = new PdfViewDelegate();
  //String strLocalIpAddress =  PdfDelegate.getLocalIpAddress();
%>

<%
	if(strDoc.compareTo("PDF") == 0 || strDoc.compareTo("DOC") == 0){

		//System.out.println(" **PDF 문서 다운 시작 **");

		objHashtable =   PdfDelegate.getFileInfo(strAnsId); // 답변  id  = 1 로 셋팅
		int intCount =  objHashtable.size();

		//System.out.println(" 해시테이블의 갯수 = " + intCount);

		Vector  objReqCont = (Vector)objHashtable.get("REQ_CONT");
		Vector  objCntNum= (Vector)objHashtable.get("ANS_QRY_CNT");

	    objPdfFilePath = (Vector)objHashtable.get("PDF_FILE_PATH");
		objDocFilePath = (Vector)objHashtable.get("ORG_FILE_PATH");

		strPdfFilePath =  (String)objPdfFilePath.elementAt(0);
		strDocFilePath =  (String)objDocFilePath.elementAt(0);
		strReqCont =  (String)objReqCont.elementAt(0);

		strReqCont = StringUtil.ReplaceString(strReqCont,"&lt;","<");
		strReqCont = StringUtil.ReplaceString(strReqCont,"&gt;",">");

		FileUtil.getFileExtension(strPdfFilePath);
		if(strDoc.compareTo("PDF") == 0){
			strfilename = strPdfFilePath;
			//strReqCont = strReqCont+"("+strREQSEQ+")"+"("+SubmtOrganNm+")"+"."+FileUtil.getFileExtension(strPdfFilePath);
			strReqCont = strReqCont+"("+SubmtOrganNm+")"+"-"+strPdfFileName;
		}else{
			strfilename = strDocFilePath;
			//strReqCont = strReqCont+"("+strREQSEQ+")"+"("+SubmtOrganNm+")"+"."+FileUtil.getFileExtension(strDocFilePath);
			strReqCont = strReqCont+"("+SubmtOrganNm+")"+"-"+strOrgFileName;
		}
		


		if(strPdfFilePath == null || strPdfFilePath.equals("")){ // PDF파일이  없다

			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0040"); //PDF 파일이 가 존재하지 않는다.
			objMsgBean.setStrMsg("PDF파일이 존재하지 않습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{
			
			FileInputStream fis = null;
			DataInputStream dis = null;
			OutputStream os = null;

			try
			{
				String path = "/mnt/nads/reqsubmit/";
				String fileName = strfilename;
				String fileName2 = new String(fileName.getBytes("8859_1"), "MS949");

				File file = new File(path+fileName2);
			
				fis = new FileInputStream(file);
				dis = new DataInputStream(new BufferedInputStream(fis));
			
				os = response.getOutputStream();
			
				response.reset() ;
				response.setContentType("application/octet-stream");
				//response.setHeader("Content-Disposition", "attachment; filename="+new String(strReqCont.getBytes("euc-kr"),"8859_1"));
				// 크롬 최신버전에서 다운이 안되는 현상 조치
				response.setHeader("Content-Disposition", "attachment; filename=\""+new String(strReqCont.getBytes("euc-kr"),"8859_1") + "\"");
				response.setHeader("Content-Length", ""+file.length() );
			
	   
				byte[] buffer = new byte[1024];
				int count = -1;
			
				while ((count = dis.read(buffer)) != -1) {
					os.write(buffer, 0, count);				
				}
			}
			catch (Exception e)
			{
				e.printStackTrace();
				System.out.println("error");
			}finally{
				if(dis !=null)try{dis.close();dis=null;}catch(Exception e){}
				if(os  !=null)try{os.close();os=null;}catch(Exception e){}
			}
		}

	} else if( strDoc.compareTo("GPDF") == 0 ){ // 정보제출자료함 일경우의 PDF파일 보기

		//System.out.println(" ** [RegFileOpen] 정부제출자료 PDF 문서 다운 시작 **");
		objHashtable =   PdfDelegate.getGovFileInfo(strAnsId); // 정부제출자료  id  = 1 로 셋팅
		int intCount =  objHashtable.size();

		//System.out.println(" [RegFileOpen] 해시테이블의 갯수 = " + intCount);

		strPdfFilePath = (String)objHashtable.get("APD_PDF_FILE_PATH");

	    if(strPdfFilePath == null || strPdfFilePath.equals("")){ // PDF파일이  없다

			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0040"); //PDF 파일이 가 존재하지 않는다.
			objMsgBean.setStrMsg("PDF파일이 존재하지 않습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{

	 		//System.out.println(" [RegFileOpen] db조회값 strPdfFilePath = " + strPdfFilePath);
			strHttpFilePath = "/reqsubmit/common/PDFView.jsp?PDF=" + strPdfFilePath;
		    //System.out.println(" [RegFileOpen] [ PDF 문서보기] strHttpFilePath =" + strHttpFilePath);
	%>
		<HTML>
		<HEAD>
		<TITLE> 회의자료 PDF보기 </TITLE>
		</HEAD>
		<BODY leftmargin="0" topmargin="0"> <!--onLoad="javascript:open()">-->
		<iframe name="view" width=100% height=100% src="<%=strHttpFilePath%>"  frameborder=0>
		</iframe>
		<BODY>
		</HTML>
	<%
		}
    } else if( strDoc.compareTo("GDOC") == 0 ){ // 정보제출자료함 일경우의 원본 문서 파일 다운로드

		String strYear =  request.getParameter("YEAR");
	    String strFileName =  request.getParameter("FName");

		//System.out.println(" ** [RegFileOpen] 정부제출자료 원본문서 다운 시작 **");
		objHashtable =   PdfDelegate.getGovFileInfo(strAnsId); // 정부제출자료  id  = 1 로 셋팅

		strDocFilePath = (String)objHashtable.get("APD_ORG_FILE_PATH");

		if(strDocFilePath == null || strDocFilePath.equals("")){

			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0041"); // 원본 파일이 가 존재하지 않는다.
			objMsgBean.setStrMsg("원본파일이 존재하지 않습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{

	 		//System.out.println(" [RegFileOpen] db조회값 strDocFilePath = " + strDocFilePath);
		    //strHttpFilePath = "/reqsubmit/common/FileDownLoad.jsp?DOC=" + strDocFilePath;

		    strHttpFilePath = "/reqsubmit/common/FileDownLoad.jsp?GDOC=" + strDocFilePath + "&YEAR=" + strYear + "&FName=" + strFileName ;
		    //System.out.println(" [RegFileOpen] [ DOC 문서보기] strHttpFilePath =" + strHttpFilePath);
			response.sendRedirect(strHttpFilePath);
	     }

     } else if( strDoc.compareTo("GTOC") == 0 ){ // 정보제출자료함 일경우의 TOC 파일 다운로드

		String strYear =  request.getParameter("YEAR");
	    String strFileName =  request.getParameter("FName");

		//System.out.println(" ** [RegFileOpen] 정부제출자료 TOC 문서 다운 시작 **");
		objHashtable =   PdfDelegate.getGovFileInfo(strAnsId); // 정부제출자료  id  = 1 로 셋팅
	    strTOCFilePath = (String)objHashtable.get("APD_TOC_FILE_PATH");

	    if(strTOCFilePath == null || strTOCFilePath.equals("")){

			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0042"); // TOC 파일이 가 존재하지 않는다.
			objMsgBean.setStrMsg("목차 파일(*.TOC)이 존재하지 않습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{
	 		//System.out.println(" [RegFileOpen] db조회값 strTOCFilePath = " + strTOCFilePath);
			strHttpFilePath = "/reqsubmit/common/FileDownLoad.jsp?GDOC=" + strTOCFilePath + "&YEAR=" + strYear + "&FName=" + strFileName ;
		    //System.out.println(" [RegFileOpen] [ TOC 문서 다운] strHttpFilePath =" + strHttpFilePath);
			response.sendRedirect(strHttpFilePath);
		}

    }  else if( strDoc.compareTo("LPDF") == 0 ){ // 국정감사시스템 연계 일경우의 PDF파일 보기

		//System.out.println(" ** [RegFileOpen] 국정감사시스템  PDF 문서 다운 시작 **");
		objHashtable =   PdfDelegate.getBindingConnectFileInfo(strAnsId);
		strPdfFilePath = (String)objHashtable.get("PDF_FILE_PATH");

		if(strPdfFilePath == null || strPdfFilePath.equals("")){ // PDF파일이  없다
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0040"); //PDF 파일이 가 존재하지 않는다.
			objMsgBean.setStrMsg("PDF파일이 존재하지 않습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{

	 		//System.out.println(" [RegFileOpen] db조회값 strPdfFilePath = " + strPdfFilePath);
			strHttpFilePath = "/reqsubmit/common/PDFView.jsp?PDF=" + strPdfFilePath;
		    //System.out.println(" [RegFileOpen] [ PDF 문서보기] strHttpFilePath =" + strHttpFilePath);
%>
			<HTML>
			<HEAD>
			<TITLE> 국정감사시스템 연계 PDF보기 </TITLE>
			</HEAD>
			<BODY leftmargin="0" topmargin="0"> <!--onLoad="javascript:open()">-->
			<iframe name="view" width=100% height=100% src="<%=strHttpFilePath%>"  frameborder=0>
			</iframe>
			<BODY>
			</HTML>
<%
		}
	}
%>




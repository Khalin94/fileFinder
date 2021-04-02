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
 //�̿��� ���� ����.
 long lasttime=session.getLastAccessedTime();

 long createdtime=session.getCreationTime();

 long time_used=(lasttime-createdtime)/60000;
 System.out.println("sessiontimeout : "+time_used+"��");
 System.out.println("sessionip : "+request.getHeader("Proxy-Client-IP"));

 String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);

 if(strUserID==null || strUserID.equals("")){
 	//throw new ReqsubmitException(request.getRequestURI(),"NoSessionUserInfo","����� ID�� ���ǿ� �������� �ʳ׿�");
 	//strUserID="tester1";//���ǿ��� ���� ����� ID Test��. �ءء� �׽�Ʈ ���� ���� ���.
 }
 UserInfoDelegate objUserInfo=(UserInfoDelegate)session.getAttribute(CodeConstants.USER_INFO_DELEGATE);
 if(objUserInfo==null){
 	//objUserInfo=new UserInfoDelegate(strUserID);
 	objUserInfo=new UserInfoDelegate(request);
 	session.setAttribute(CodeConstants.USER_INFO_DELEGATE,(Object)objUserInfo);
 }

// �亯������ ��ȸ�ڰ� �䱸���� ��� �亯��ȸ���� FLAG �� 'N'->'Y' �� ����

    SMemAnsInfoEditForm objParamForm = new SMemAnsInfoEditForm();	

	String strTopIsRequesterGbn = (String)session.getValue("IS_REQUESTER");

	if("true".equals(strTopIsRequesterGbn)){

		// �Ķ���Ͱ� ���������� �Ѿ�°��� Ȯ���غ���
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
		//	throw new AppException("�䱸�� �亯 ��ȸ ���� ������Ʈ�� ���������� ó������ ���߽��ϴ�. Ȯ�ιٶ��ϴ�.");
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
  String strSubmtGbn = null; 	//���������ڷ� �ڵ屸��
  String  strTOCFilePath = null; //���������ڷ� TOC�����н�


  Vector  objPdfFilePath  = null;
  Vector  objDocFilePath  = null;
  int intResult = 0;
  String strCntNum = null;

  String strAnsId =  request.getParameter("paramAnsId");
  String strREQSEQ = request.getParameter("REQSEQ");
  String SubmtOrganNm = request.getParameter("SubmtOrganNm");

  //�������ϸ� ���� 20170818
  AnsInfoDelegate selfDelegate = new AnsInfoDelegate();
  ResultSetSingleHelper objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strAnsId));   
  
  String strPdfFileName = (String)objRsSH.getObject("PDF_FILE_NAME");
  String strOrgFileName = (String)objRsSH.getObject("ORG_FILE_NAME");
  
  System.out.println("kangthis logs ReqFileOpen2.jsp strPdfFileName => " + strPdfFileName);
  System.out.println("kangthis logs ReqFileOpen2.jsp strOrgFileName => " + strOrgFileName);
  
  String strDoc =  request.getParameter("DOC");
  //System.out.println("[RegFileOpen] strAnsId =" + strAnsId + "\n");
  //System.out.println("[RegFileOpen] strDoc =" + strDoc);
  //strAnsId = "1"; // �亯 ID

  PdfViewDelegate PdfDelegate = new PdfViewDelegate();
  //String strLocalIpAddress =  PdfDelegate.getLocalIpAddress();
%>

<%
	if(strDoc.compareTo("PDF") == 0 || strDoc.compareTo("DOC") == 0){

		//System.out.println(" **PDF ���� �ٿ� ���� **");

		objHashtable =   PdfDelegate.getFileInfo(strAnsId); // �亯  id  = 1 �� ����
		int intCount =  objHashtable.size();

		//System.out.println(" �ؽ����̺��� ���� = " + intCount);

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
		


		if(strPdfFilePath == null || strPdfFilePath.equals("")){ // PDF������  ����

			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0040"); //PDF ������ �� �������� �ʴ´�.
			objMsgBean.setStrMsg("PDF������ �������� �ʽ��ϴ�.");
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
				// ũ�� �ֽŹ������� �ٿ��� �ȵǴ� ���� ��ġ
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

	} else if( strDoc.compareTo("GPDF") == 0 ){ // ���������ڷ��� �ϰ���� PDF���� ����

		//System.out.println(" ** [RegFileOpen] ���������ڷ� PDF ���� �ٿ� ���� **");
		objHashtable =   PdfDelegate.getGovFileInfo(strAnsId); // ���������ڷ�  id  = 1 �� ����
		int intCount =  objHashtable.size();

		//System.out.println(" [RegFileOpen] �ؽ����̺��� ���� = " + intCount);

		strPdfFilePath = (String)objHashtable.get("APD_PDF_FILE_PATH");

	    if(strPdfFilePath == null || strPdfFilePath.equals("")){ // PDF������  ����

			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0040"); //PDF ������ �� �������� �ʴ´�.
			objMsgBean.setStrMsg("PDF������ �������� �ʽ��ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{

	 		//System.out.println(" [RegFileOpen] db��ȸ�� strPdfFilePath = " + strPdfFilePath);
			strHttpFilePath = "/reqsubmit/common/PDFView.jsp?PDF=" + strPdfFilePath;
		    //System.out.println(" [RegFileOpen] [ PDF ��������] strHttpFilePath =" + strHttpFilePath);
	%>
		<HTML>
		<HEAD>
		<TITLE> ȸ���ڷ� PDF���� </TITLE>
		</HEAD>
		<BODY leftmargin="0" topmargin="0"> <!--onLoad="javascript:open()">-->
		<iframe name="view" width=100% height=100% src="<%=strHttpFilePath%>"  frameborder=0>
		</iframe>
		<BODY>
		</HTML>
	<%
		}
    } else if( strDoc.compareTo("GDOC") == 0 ){ // ���������ڷ��� �ϰ���� ���� ���� ���� �ٿ�ε�

		String strYear =  request.getParameter("YEAR");
	    String strFileName =  request.getParameter("FName");

		//System.out.println(" ** [RegFileOpen] ���������ڷ� �������� �ٿ� ���� **");
		objHashtable =   PdfDelegate.getGovFileInfo(strAnsId); // ���������ڷ�  id  = 1 �� ����

		strDocFilePath = (String)objHashtable.get("APD_ORG_FILE_PATH");

		if(strDocFilePath == null || strDocFilePath.equals("")){

			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0041"); // ���� ������ �� �������� �ʴ´�.
			objMsgBean.setStrMsg("���������� �������� �ʽ��ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{

	 		//System.out.println(" [RegFileOpen] db��ȸ�� strDocFilePath = " + strDocFilePath);
		    //strHttpFilePath = "/reqsubmit/common/FileDownLoad.jsp?DOC=" + strDocFilePath;

		    strHttpFilePath = "/reqsubmit/common/FileDownLoad.jsp?GDOC=" + strDocFilePath + "&YEAR=" + strYear + "&FName=" + strFileName ;
		    //System.out.println(" [RegFileOpen] [ DOC ��������] strHttpFilePath =" + strHttpFilePath);
			response.sendRedirect(strHttpFilePath);
	     }

     } else if( strDoc.compareTo("GTOC") == 0 ){ // ���������ڷ��� �ϰ���� TOC ���� �ٿ�ε�

		String strYear =  request.getParameter("YEAR");
	    String strFileName =  request.getParameter("FName");

		//System.out.println(" ** [RegFileOpen] ���������ڷ� TOC ���� �ٿ� ���� **");
		objHashtable =   PdfDelegate.getGovFileInfo(strAnsId); // ���������ڷ�  id  = 1 �� ����
	    strTOCFilePath = (String)objHashtable.get("APD_TOC_FILE_PATH");

	    if(strTOCFilePath == null || strTOCFilePath.equals("")){

			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0042"); // TOC ������ �� �������� �ʴ´�.
			objMsgBean.setStrMsg("���� ����(*.TOC)�� �������� �ʽ��ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{
	 		//System.out.println(" [RegFileOpen] db��ȸ�� strTOCFilePath = " + strTOCFilePath);
			strHttpFilePath = "/reqsubmit/common/FileDownLoad.jsp?GDOC=" + strTOCFilePath + "&YEAR=" + strYear + "&FName=" + strFileName ;
		    //System.out.println(" [RegFileOpen] [ TOC ���� �ٿ�] strHttpFilePath =" + strHttpFilePath);
			response.sendRedirect(strHttpFilePath);
		}

    }  else if( strDoc.compareTo("LPDF") == 0 ){ // ��������ý��� ���� �ϰ���� PDF���� ����

		//System.out.println(" ** [RegFileOpen] ��������ý���  PDF ���� �ٿ� ���� **");
		objHashtable =   PdfDelegate.getBindingConnectFileInfo(strAnsId);
		strPdfFilePath = (String)objHashtable.get("PDF_FILE_PATH");

		if(strPdfFilePath == null || strPdfFilePath.equals("")){ // PDF������  ����
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0040"); //PDF ������ �� �������� �ʴ´�.
			objMsgBean.setStrMsg("PDF������ �������� �ʽ��ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		}else{

	 		//System.out.println(" [RegFileOpen] db��ȸ�� strPdfFilePath = " + strPdfFilePath);
			strHttpFilePath = "/reqsubmit/common/PDFView.jsp?PDF=" + strPdfFilePath;
		    //System.out.println(" [RegFileOpen] [ PDF ��������] strHttpFilePath =" + strHttpFilePath);
%>
			<HTML>
			<HEAD>
			<TITLE> ��������ý��� ���� PDF���� </TITLE>
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




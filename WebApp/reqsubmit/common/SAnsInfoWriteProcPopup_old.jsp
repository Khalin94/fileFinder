<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>

<%@ page import="nads.lib.reqsubmit.EnvConstants" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	System.out.println("ANSTIMECHEK(1) : "+this.getCurrentTime());

	String strClientIP = request.getHeader("WL-Proxy-Client-IP");

	System.out.println("strClientIP(1) : "+strClientIP);

	String strWebServerAddress = EnvConstants.getWebServerIP();

	System.out.println("strWebServerAddress(1) : "+strWebServerAddress);

	UserInfoDelegate objUserInfo =null; // �̿��� ����
	CDInfoDelegate objCdinfo =null; // �ý��� ����(���)

	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	SMemReqInfoDelegate objReqInfo = null;
	AnsInfoDelegate objSMAIDelegate = null;

	String strMsgDigest = "";
	String strOldPdfFile = "";
	String strOldDocFile = "";
	String strReqBoxID = "";
	String strPdfFileName = "";
	String strDocFileName = "";
	String strAnsFileID = "";
	String strUserDN = "";
	String strRsUserDN = "";
	String strCount = "";
	String PdfFilePath = "";
	String DocFilePath = "";
	// �������ϸ� �۾� 20170818
	String strOldDocReal = "";
	String strOldPdfReal = "";
	String strOrgRealFileName = "";
	String strPdfRealFileName = "";
	int count = -1;
	System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	// �Ķ���Ͱ� ���������� �Ѿ�°��� Ȯ���غ���
	boolean blnParamCheck = false;

	System.out.println("ANSTIMECHEK(2) : "+this.getCurrentTime());

	blnParamCheck = objParamForm.validateParams(request);

	System.out.println("ANSTIMECHEK(3) : "+this.getCurrentTime());

  	if(!blnParamCheck) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParamForm.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} // end if

	try {
		objReqInfo = new SMemReqInfoDelegate();
		objSMAIDelegate = new AnsInfoDelegate();

		// ���������� ���ε尡 �Ǿ����ϱ�? �׷� ������ temp �������� ���ϸ��� �������� �ش��ϴ�
		// ���� �������� �ñ��� ����! MSG Digest ����


		// 2004-06-04 �̿��� ������ USER DN
		strUserDN = (String)objParamForm.getParamValue("UserDN");
		strCount = (String)objParamForm.getParamValue("count");
		count = Integer.parseInt(strCount);
		System.out.println("objUserInfo.getUserID() : "+objUserInfo.getUserID());
		strRsUserDN = (String)objReqInfo.getUserDN(objUserInfo.getUserID());
		System.out.println("strRsUserDN : "+strRsUserDN);
		System.out.println("strUserDN : "+strUserDN);
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		out.println("<form  name=encForm>");
		out.println("<input type=hidden value='' name='passwd'>");
		out.println("<input type=hidden value='"+strUserDN+"' name='user_dn'>");
		out.println("<input type=hidden value='"+strUserDN+"' name='rec_dn'>");
		out.println("<input type=\"hidden\" value=\""+(String)objParamForm.getParamValue("MatType")+"\" name=\"MatType\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+(String)objParamForm.getParamValue("SendWay")+"\" name=\"SendWay\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+(String)objParamForm.getParamValue("AnsType")+"\" name=\"AnsType\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+(String)objParamForm.getParamValue("OpenCL")+"\" name=\"OpenCL\" size=\"0\">");
		boolean flagResult = true;
		for(int i=0;i<count;i++){
			boolean flag = false;
			strOldPdfFile = (String)objParamForm.getParamValue("PdfFile"+i);
			System.out.println("strOldPdfFile ::::::::::::::::::::::::::::::::::: " + strOldPdfFile);
			// �������ϸ� �۾� 20170818
			strOldDocReal = (String)objParamForm.getParamValue("realOriginFile"+i);
			strOldPdfReal = (String)objParamForm.getParamValue("realPdfFile"+i);
			// 2004-05-31 EncryptedPDF ------> DecryptedPDF
			// 2018-09-12 �ּ�ó��
/*
			if((FileUtil.getFileExtension(strOldPdfFile)).equals("pdf")||(FileUtil.getFileExtension(strOldPdfFile)).equals("PDF")){
				strOldPdfFile = objSMAIDelegate.getDecryptedPdfPath(strOldPdfFile);
			}
*/
			strOldDocFile = (String)objParamForm.getParamValue("OriginFile"+i);
			//System.out.println("strOldDocFile :"+strOldDocFile);
			strOldPdfFile = StringUtil.ReplaceString(strOldPdfFile, "\\", "/");
			strOldDocFile = StringUtil.ReplaceString(strOldDocFile, "\\", "/");

			if((FileUtil.getFileExtension(strOldPdfFile)).equals("pdf")||(FileUtil.getFileExtension(strOldPdfFile)).equals("PDF")){
				//strMsgDigest = objSMAIDelegate.getMsgDigest(strOldPdfFile);
				strMsgDigest = "";
			}

			System.out.println("PdfFile :"+strOldPdfFile);
			System.out.println("OriginFile :"+strOldDocFile);

			//String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);

			String strExtension1 = FileUtil.getFileExtension(strOldPdfFile);
			String strExtension2 = FileUtil.getFileExtension(strOldDocFile);

			strExtension1 = strExtension1.toLowerCase();
			strExtension2 = strExtension2.toLowerCase();

			String[] strEx = {"hwp", "pdf", "doc", "ppt", "xls", "txt","docx","pptx","xlsx"};

			for(int j = 0; j < strEx.length ; j++){
				if(strEx[j].equals(strExtension1)){
					flag = true;
				}
			}
			if(flag == false){
				flagResult = false;
				break;
			}

			flag = false;

			for(int k = 0; k < strEx.length ; k++){
				if(strEx[k].equals(strExtension2)){
					flag = true;
				}
			}


			out.println("<input type=\"hidden\" value=\""+strMsgDigest+"\" name=\"src"+i+"\">");
			// �亯 ���� SEQ�� ���⼭ �̸� ��������.
			if(i == count-1){
				 strAnsFileID = strAnsFileID+StringUtil.padl(objSMAIDelegate.getSeqNextVal("TBDS_ANS_FILE_INFO"), 10);
				 strPdfFileName = strPdfFileName+FileUtil.getFileName(strOldPdfFile);
				 strDocFileName = strDocFileName+FileUtil.getFileName(strOldDocFile);
				 // �������ϸ� �۾� 20170818
				 strOrgRealFileName = strOrgRealFileName+FileUtil.getFileName(strOldDocReal);
				 strPdfRealFileName = strPdfRealFileName+FileUtil.getFileName(strOldPdfReal);
				 PdfFilePath = PdfFilePath+FileUtil.getFileName(strOldPdfFile, "/");
				 DocFilePath = DocFilePath+FileUtil.getFileName(strOldDocFile, "/");
			}else{
				 strPdfFileName = strPdfFileName+FileUtil.getFileName(strOldPdfFile)+"��";
				 strDocFileName = strDocFileName+FileUtil.getFileName(strOldDocFile)+"��";
				 // �������ϸ� �۾� 20170818
				 strOrgRealFileName = strOrgRealFileName+FileUtil.getFileName(strOldDocReal)+"��";
				 strPdfRealFileName = strPdfRealFileName+FileUtil.getFileName(strOldPdfReal)+"��";
				 PdfFilePath = PdfFilePath+FileUtil.getFileName(strOldPdfFile, "/")+"��";
				 DocFilePath = DocFilePath+FileUtil.getFileName(strOldDocFile, "/")+"��";
				 strAnsFileID = strAnsFileID+StringUtil.padl(objSMAIDelegate.getSeqNextVal("TBDS_ANS_FILE_INFO"), 10)+"��";
			}
			if(flag == false){
				flagResult = false;
				break;
			}

		}

		if(flagResult == false){
			out.println("<script language=javascript>");
			out.println("alert('hwp,pdf,doc,ppt,xls,txt ������ ���ϸ� ���ε尡���մϴ�.');");
			//out.println("opener.close();");
			out.println("parent.close();");
			out.println("</script>");
			return;
		}

			System.out.println("strMsgDigest :"+strMsgDigest);
			System.out.println("PdfFilePath :"+PdfFilePath);
			System.out.println("DocFilePath :"+DocFilePath);
			System.out.println("strAnsFileID :"+strAnsFileID);
			System.out.println("strPdfFileName :"+strPdfFileName);
			System.out.println("strDocFileName :"+strDocFileName);


			out.println("<input type=\"hidden\" value=\""+PdfFilePath+"\" name=\"OldPdfFile\" size=\"0\">");
			out.println("<input type=\"hidden\" value=\""+DocFilePath+"\" name=\"OldDocFile\" size=\"0\">");
			out.println("<input type=\"hidden\" value=\""+strAnsFileID+"\" name=\"AnsFileID\" size=\"0\">");
			out.println("<input type=\"hidden\" value=\""+strPdfFileName+"\" name=\"PdfFileName\" size=\"0\">");
			out.println("<input type=\"hidden\" value=\""+strDocFileName+"\" name=\"DocFileName\" size=\"0\">");
			// �������ϸ� �۾� 20170818
			out.println("<input type=\"hidden\" value=\""+strOrgRealFileName+"\" name=\"OrgRealFileName\" size=\"0\">");
			out.println("<input type=\"hidden\" value=\""+strPdfRealFileName+"\" name=\"PdfRealFileName\" size=\"0\">");
			out.println("<input type=hidden value='' name='signed_data'>");

		out.println("</form>");
%>

<html>
<head>
<title>�亯��� - ���ڼ��� ���Դϴ�.</title>
<!-- script language="vbscript" src="/js/activex.vbs"></script -->
<!-- script language="javascript" src="/js/axkcase.js"></script-->
<script language="javascript">

	function SelectCert2(form) {
		var dn;

		if(!CheckAX()) {
			alert("Ŭ���̾�Ʈ ���α׷��� ��ġ���� �ʾ� ������ �� �����ϴ�.");
			return;
		}

		dn = document.AxNAROK.SelectCert();
		if ((dn == null) || (dn == "")) {
			if(document.AxNAROK.GetErrorCode() != -1) {
				alert(document.AxNAROK.GetErrorContent());
				return;
			}
		}
		return dn;
	}

	function NADSEncryptDigest(form) {
		var encdigetdata;
		var f = parent.document.returnSubmitForm;

		if(!CheckAX()) {
			alert("Ŭ���̾�Ʈ ���α׷��� ��ġ���� �ʾ� ������ �� �����ϴ�.");
			return;
		}
		var strRsUserDN = "<%= strRsUserDN %>";
		var user_dn = form.user_dn.value;
		for(var i=0; i < <%=count%>;i++){
			src = eval("form.src"+i);
			var strMsgDigest = src.value;
			//alert(strMsgDigest);
			if ((user_dn == null) || (user_dn == "")) {
				user_dn = SelectCert2(f);
				// 2004-06-17
				if (user_dn != strRsUserDN) {
					alert("�����Ͻ� �������� ������ �Ͱ� �������� Ȯ���� �ֽñ� �ٶ��ϴ�.");
					parent.document.all.loadingDiv.style.display = 'none';
					return;
				}
				if(user_dn == "")
				return;
			}

			//encdigetdata = document.AxNAROK.EncryptedDigest(user_dn, document.AxNAROK.GetPassword(user_dn), strMsgDigest);

			//alert("1st enc digest data : " + encdigetdata);

			if(i == <%=count%>){
				encdigetdata = encdigetdata+document.AxNAROK.SignedData(user_dn, '', strMsgDigest);
			}else{
				encdigetdata = encdigetdata+document.AxNAROK.SignedData(user_dn, '', strMsgDigest)+"��";
			}
			/*
			if((encdigetdata == null) || (encdigetdata == "")) {
				if(document.AxNAROK.GetErrorCode() != -1) alert(document.AxNAROK.GetErrorContent());
				return;
			} else {
				autoSubmit(encdigetdata, user_dn);
			}
			*/

		}
		//alert("password : " +document.AxNAROK.GetPassword(user_dn));
		//alert("2nd enc digest data : " + encdigetdata);
		form.signed_data.value = encdigetdata;
		form.user_dn.value = user_dn;
		autoSubmit(form);
		self.close();
	}

	function SignedData2(form) {
		var signeddata;
		if(!CheckAX()) {
			alert("Ŭ���̾�Ʈ ���α׷��� ��ġ���� �ʾ� ������ �� �����ϴ�.");
			return;
		}
		var user_dn = form.user_dn.value;
		if ((user_dn == null) || (user_dn == "")) {
			if(!SelectCert(form))
			return;
		}

		signeddata = document.AxNAROK.SignedData(user_dn, "", form.src.value);
		if((signeddata == null) || (signeddata == "")) {
			if(document.AxNAROK.GetErrorCode() != -1)
				alert(document.AxNAROK.GetErrorContent());
			return;
		}
		form.signed_data.value = signeddata;
		return;
	}

	function autoSubmit(form) {
		var f2 = parent.document.returnSubmitForm;

		f2.PdfFilePath.value = form.OldPdfFile.value;
		f2.DocFilePath.value = form.OldDocFile.value;
		f2.MatType.value = form.MatType.value;
		f2.SendWay.value = form.SendWay.value;
		f2.AnsType.value = form.AnsType.value;
		f2.OpenCL.value = form.OpenCL.value;
		f2.AnsFileID.value = form.AnsFileID.value;
		f2.PdfFileName.value = form.PdfFileName.value;
		f2.OriginFileName.value = form.DocFileName.value;
		// �������ϸ� 20170818
		f2.OrgRealFileName.value = form.OrgRealFileName.value;
		f2.PdfRealFileName.value = form.PdfRealFileName.value;
		//f2.MsgDigest.value = form.signed_data.value;
		f2.MsgDigest.value = "undefined��";
		f2.user_dn.value = form.user_dn.value;
		f2.count.value = "<%=count%>";
		f2.action = "/reqsubmit/common/SAnsInfoWriteProc_old.jsp";
		f2.submit();
		//self.close();
	}
</script>

</head>

<body onLoad="javascript:autoSubmit(document.encForm);">

<!-- OBJECT ID="AxNAROK" CLASSID="CLSID:1966B8D2-9779-4B05-BE2D-30D55C2586A1"
 codebase="<%= strWebServerAddress %>/cab/AxNAROK(2.0.0.8).cab#Version=2,0,0,8" height="1" width="1">
</OBJECT -->
<!-- script language="javascript" src="/js/AxNAROK3.js"></script-->

</body>
</html>
<%
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println(e.getMessage());
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("");
	  	objMsgBean.setStrMsg(e.getMessage());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} // end try.......... catch
%>
<%
	System.out.println("ANSTIMECHEK(4) : "+this.getCurrentTime());
%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>
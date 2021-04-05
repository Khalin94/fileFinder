<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoEditForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strWebServerAddress = EnvConstants.getWebServerIP();
	SMemAnsInfoEditForm objParamForm = new SMemAnsInfoEditForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();

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

	String strContentType = request.getContentType();
	if (strContentType != null) strContentType = StringUtil.substring(strContentType, 19);

	// 2004-06-07 kogaeng ADD
	String strReturnURL = String.valueOf(objParamForm.getParamValue("ReturnURL"));

	if (strContentType.equalsIgnoreCase("multipart/form-data...")) { // MultipartRequest�� �̿��ؾ��ϴ� ���
		// ���� ��� ��� �� ���� �𸥴�.. �׳� ������ ��Ƶΰڽ��ϴ�.
		String strReqBoxID = String.valueOf(objParamForm.getParamValue("ReqBoxID"));
		String strReqID = String.valueOf(objParamForm.getParamValue("ReqID"));
		String strAnsID = String.valueOf(objParamForm.getParamValue("AnsID"));
		String strAnsFileID = String.valueOf(objParamForm.getParamValue("AnsFileID"));
		String strAnsType = String.valueOf(objParamForm.getParamValue("AnsType"));
		String strOriginFile = String.valueOf(objParamForm.getParamValue("OriginFile"));
		strOriginFile = StringUtil.ReplaceString(strOriginFile, "\\", "/");
		String strPdfFile = String.valueOf(objParamForm.getParamValue("PdfFile"));
		strPdfFile = StringUtil.ReplaceString(strPdfFile, "\\", "/");

		// 2004-06-04 encrypt ---------> decrypt
		strPdfFile = objSMAIDelegate.getDecryptedPdfPath(strPdfFile);

		String strAnsOpin = String.valueOf(objParamForm.getParamValue("AnsOpin"));
		String strOpenCL = String.valueOf(objParamForm.getParamValue("OpenCL"));
		String strRegrID = String.valueOf(objParamForm.getParamValue("RegrID"));
		String strMsgDigest = null;

		// 2004-06-04 �̿��� ������ ����
		String strUserDN = (String)objParamForm.getParamValue("UserDN");

		// ���� ���� Msg Digest ����
		// PDF ���� ������ ���������� �۾��� �����ϰ� �׷��� ������ ���� ���� ��������
		if (!StringUtil.isAssigned(strPdfFile)) { // PDF ������ ���õ��� �ʾ����Ƿ�, �׳� ������ ������ ������Ʈ ����
			// ������ ������ ������Ʈ �Ѵ�
			int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo(objParamForm);
			if (intUpdateResult < 1) {
				throw new AppException("�亯 ���� ������Ʈ�� ���������� ó������ ���߽��ϴ�. Ȯ�ιٶ��ϴ�.");
			} else {
				out.println("<script language='javascript'>");
				out.println("alert('�亯 ������ ���������� �����Ͽ����ϴ�.');");
				out.println("opener.window.location.href='"+strReturnURL+"'");
				out.println("self.close();");
				out.println("</script>");
			}
		} else { // �ٽ� ���� ������ ���ŷο� �۾��� �����Ѵ�... -��-
			strMsgDigest = objSMAIDelegate.getMsgDigest((String)objParamForm.getParamValue("PdfFile"));
			if (!StringUtil.isAssigned(strMsgDigest)) throw new AppException("Msg Digest ������ ����");

			out.println("<form method='post' name='autoForm' action=''>\n");
			out.println("<input type='hidden' name='MsgDigest' value=''>\n");
			out.println("<input type=hidden value='"+strMsgDigest+"' name=src>");
			out.println("<input type=hidden value='' name=signed_data>");
			out.println("<input type=\"hidden\" name=\"ReqBoxID\" value=\""+strReqBoxID +"\">\n");
			out.println("<input type=\"hidden\" name=\"ReqID\" value=\""+strReqID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsID\" value=\""+strAnsID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsFileID\" value=\""+strAnsFileID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsType\" value=\""+strAnsType+"\">\n");
			out.println("<input type=\"hidden\" name=\"OriginFile\" value=\""+FileUtil.getFileName(strOriginFile, "/")+"\">\n");
			out.println("<input type=\"hidden\" name=\"PdfFile\" value=\""+FileUtil.getFileName(strPdfFile, "/")+"\">\n");
			out.println("<input type=\"hidden\" name=\"DocFilePath\" value=\""+FileUtil.getFileName(strOriginFile, "/")+"\">\n");
			out.println("<input type=\"hidden\" name=\"PdfFilePath\" value=\""+FileUtil.getFileName(strPdfFile, "/")+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsOpin\" value=\""+strAnsOpin+"\">\n");
			out.println("<input type=\"hidden\" name=\"OpenCL\" value=\""+strOpenCL+"\">\n");
			out.println("<input type=\"hidden\" name=\"RegrID\" value=\""+strRegrID+"\">\n");
			out.println("<input type=\"hidden\" name=\"ReturnURL\" value=\""+strReturnURL+"\">\n");
			out.println("<input type=\"hidden\" name=\"passwd\" value=\"\">\n");
			out.println("<input type=\"hidden\" name=\"user_dn\" value=\""+strUserDN+"\">\n");
			out.println("<input type=hidden value='"+strUserDN+"' name='rec_dn'>");

			out.println("</form>\n");
%>
<html>
<head>
<title></title>
<!-- script language="vbscript" src="/js/activex.vbs"></script-->
<!-- script language="javascript" src="/js/axkcase.js"></script-->
<script language="javascript">

	function SelectCert2(form) {
		var dn;
		if(!CheckAX()) {
			alert("Ŭ���̾�Ʈ ���α׷��� ��ġ���� �ʾ� ������ �� �����ϴ�.");
			return;
		}

		dn = document.AxKCASE.SelectCert();
		if ((dn == null) || (dn == "")) {
			if(document.AxKCASE.GetErrorCode() != -1)
				alert(document.AxKCASE.GetErrorContent());
			return false;
		}
		return dn;
	}

	function NADSEncryptDigest(form) {
		var encdigetdata;
		var f = opener.window.document.returnSubmitForm;
		if(!CheckAX()) {
			alert("Ŭ���̾�Ʈ ���α׷��� ��ġ���� �ʾ� ������ �� �����ϴ�.");
			return;
		}
		var user_dn = form.user_dn.value;
		var strMsgDigest = form.src.value;
		if ((user_dn == null) || (user_dn == "")) {
			user_dn = SelectCert2(f);
			if(user_dn == "")
	   		return;
		}
		//encdigetdata = document.AxKCASE.EncryptedDigest(user_dn, document.AxKCASE.GetPassword(user_dn), strMsgDigest);
		encdigetdata = document.AxKCASE.SignedData(user_dn, '', strMsgDigest);
		/*
		if((encdigetdata == null) || (encdigetdata == "")) {
			if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
			return;
		} else {
			autoSubmit();
		}
		*/
		form.signed_data.value = encdigetdata;
		form.MsgDigest.value = encdigetdata;
		form.user_dn.value = user_dn;
		autoSubmit(form);
	}

	function autoSubmit(f) {
		f.action = "/reqsubmit/common/SAnsInfoEditProc2.jsp";
		f.submit();
	}
</script>
</head>
<body onLoad="javascript:autoSubmit(document.autoForm);"><!--onLoad="javascript:InitConfig();NADSEncryptDigest(document.autoForm);"-->
<!--OBJECT ID="AxKCASE" CLASSID="CLSID:1966B8D2-9779-4B05-BE2D-30D55C2586A1"
 codebase="<%= strWebServerAddress %>/cab/AxKCASE(2.0.0.4).cab#Version=2,0,0,4" height="1" width="1">
</OBJECT-->
			</body>
			</html>
<%
		} // end if (PDF FILE NULL CHECK)

	} else { // �Ϲ� Normal Form�� ���

		// ������ ���� OR �ش����ƴ� �� ���
		int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo(objParamForm);
		if (intUpdateResult < 1) {
			throw new AppException("�亯 ���� ������Ʈ�� ���������� ó������ ���߽��ϴ�. Ȯ�ιٶ��ϴ�.");
		} else {
			out.println("<script language='javascript'>");
			out.println("alert('�亯 ������ ���������� �����Ͽ����ϴ�.');");
			out.println("opener.window.location.href='"+strReturnURL+"'");
			out.println("self.close();");
			out.println("</script>");
		}

	} // end if
%>
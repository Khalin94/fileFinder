<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.lib.reqsubmit.EnvConstants" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	out.println("-_-;;");
	if(1==1) return;
	UserInfoDelegate objUserInfo =null; // �̿��� ����
	CDInfoDelegate objCdinfo =null; // �ý��� ����(���)
	
	String strTmpSavePath = null; // ���� ���
	int intSizeLimit = 0;
	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
	FileUtil objFU = new FileUtil();
	String strMsgDigest = null;
	String strPdfFileName = null;
	String strOriginFileName = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	strTmpSavePath = EnvConstants.UNIX_TEMP_SAVE_PATH; // ���� ���� ���
	// ������ Ȥ�� ������� �ϳ� ����� �ְ�
	FileUtil.prepareFolder(strTmpSavePath);
	// ������ ���ϵ��� �̸� �����ϰ� �����Ѵ�.
	objFU.DeloldFile(strTmpSavePath);
	
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
	
	try {
		/*
		strTmpSavePath = EnvConstants.WIN_TEMP_SAVE_PATH; // ���� ���� ���
		System.out.println("Temp Path : " + strTmpSavePath);
		intSizeLimit = 50 * 1024 * 1024 ; // ���ε� ���� ũ��
		// ������ Ȥ�� ������� �ϳ� ����� �ְ�
		FileUtil.prepareFolder(strTmpSavePath);
		// ������ ���ϵ��� �̸� �����ϰ� �����Ѵ�.
		objFU.DeloldFile(strTmpSavePath);

		MultipartRequest multi = new MultipartRequest(request, strTmpSavePath, intSizeLimit, "EUC-KR");
		*/
		
		// ���������� ���ε尡 �Ǿ����ϱ�? �׷� ������ temp �������� ���ϸ��� �������� �ش��ϴ� 
		// ���� �������� �ñ��� ����! MSG Digest ����
		strMsgDigest = objSMAIDelegate.getMsgDigest((String)objParamForm.getParamValue("PdfFile"));
		strPdfFileName = FileUtil.getFileName((String)objParamForm.getParamValue("PdfFile"));
		strOriginFileName = FileUtil.getFileName((String)objParamForm.getParamValue("OriginFile"));
		
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
			alert("Ŭ���̾�Ʈ ���α׷��� ��ġ���� �ʾ� ������ �� �����ϴ�.");
			return;
		}
		var dn = document.AxKCASE.SelectCert();
		if ((dn == null) || (dn == "")) {
			if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
			return false;
		}
		encdigetdata = document.AxKCASE.EncryptedDigest(dn, "", '<%= strMsgDigest %>');
		
		if((encdigetdata == null) || (encdigetdata == "")) {
			if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
			return;
		} else {
			autoSubmit(encdigetdata);
		}
	}
	
	function autoSubmit(str) {
		var f2 = opener.window.document.returnSubmitForm;
		f2.PdfFile.value = "<%= (String)objParamForm.getParamValue("PdfFile") %>";
		f2.OriginFile.value = "<%= (String)objParamForm.getParamValue("OriginFile") %>";
		f2.MatType.value = "<%= (String)objParamForm.getParamValue("MatType") %>";
		f2.SendWay.value = "<%= (String)objParamForm.getParamValue("SendWay") %>";
		f2.AnsOpin.value = "<%= (String)objParamForm.getParamValue("AnsOpin") %>";
		f2.AnsType.value = "<%= (String)objParamForm.getParamValue("AnsType") %>";
		f2.OpenCL.value = "<%= (String)objParamForm.getParamValue("OpenCL") %>";
		f2.PdfFileName.value = "<%= strPdfFileName %>";
		f2.OriginFileName.value = "<%= strOriginFileName %>";
		f2.MsgDigest.value = str;
		f2.action = "SMakeAnsInfoWriteProc.jsp";
		f2.submit();
		self.close();
	}
</script>
</head>

<body onLoad="javascript:NADSEncryptDigest();">

<script language="javascript" src="/js/AxNAROK2.js"></script>

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
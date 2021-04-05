<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
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
		String strAnsOpin = String.valueOf(objParamForm.getParamValue("AnsOpin"));
		String strOpenCL = String.valueOf(objParamForm.getParamValue("OpenCL"));
		String strRegrID = String.valueOf(objParamForm.getParamValue("RegrID"));
		String msgDigest = null;
		
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
				out.println("opener.window.location.reload();");
				out.println("self.close();");
				out.println("</script>");
			}
		} else { // �ٽ� ���� ������ ���ŷο� �۾��� �����Ѵ�... -��-
			msgDigest = objSMAIDelegate.getMsgDigest((String)objParamForm.getParamValue("PdfFile"));
			if (!StringUtil.isAssigned(msgDigest)) throw new AppException("Msg Digest ������ ����");
			
			out.println("<form method='post' name='autoForm' action=''>\n");
			out.println("<input type='hidden' name='MsgDigest' value=''>\n");
			out.println("<input type=\"hidden\" name=\"ReqBoxID\" value=\""+strReqBoxID +"\">\n");
			out.println("<input type=\"hidden\" name=\"ReqID\" value=\""+strReqID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsID\" value=\""+strAnsID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsFileID\" value=\""+strAnsFileID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsType\" value=\""+strAnsType+"\">\n");
			out.println("<input type=\"hidden\" name=\"OriginFile\" value=\""+strOriginFile+"\">\n");
			out.println("<input type=\"hidden\" name=\"PdfFile\" value=\""+strPdfFile+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsOpin\" value=\""+strAnsOpin+"\">\n");
			out.println("<input type=\"hidden\" name=\"OpenCL\" value=\""+strOpenCL+"\">\n");
			out.println("<input type=\"hidden\" name=\"RegrID\" value=\""+strRegrID+"\">\n");
			out.println("</form>\n");
%>
			<html>
			<head>
			<title></title>
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
					encdigetdata = document.AxKCASE.EncryptedDigest(dn, "", '<%= msgDigest %>');
					
					if((encdigetdata == null) || (encdigetdata == "")) {
						if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
						return;
					}
					
					autoSubmit(encdigetdata);
				}
				
				function autoSubmit(str) {
					var f = document.autoForm;
					f.MsgDigest.value = str;
					f.OriginFile.value = "<%= strOriginFile %>";
					f.PdfFile.value = "<%= strPdfFile %>";
					f.action = "SMakeAnsInfoEditProc2.jsp";
					f.submit();		
				}
			</script>
			</head>
			<body onLoad="javascript:NADSEncryptDigest()">
				<script language="javascript" src="/js/AxNAROK2.js"></script>
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
			out.println("opener.window.location.reload();");
			out.println("self.close();");
			out.println("</script>");
		}
	
	} // end if
%>
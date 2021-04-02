<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoEditForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	// 2004-05-11 Added
	String strUserDN = StringUtil.getEmptyIfNull(request.getParameter("user_dn"));
	HttpSession objPrivateSession = request.getSession();
	objPrivateSession.setAttribute("UserDN", strUserDN);
	
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
	
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
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %> 

<%
	String str1 = request.getParameter("OriginFile");
	String str2 = request.getParameter("PdfFile");
	objParamForm.setParamValue("OriginFile", str1);
	objParamForm.setParamValue("PdfFile", str2);
	// ���� ��� ��� �� ���� �𸥴�.. �׳� ������ ��Ƶΰڽ��ϴ�.
	String strReqBoxID = String.valueOf(objParamForm.getParamValue("ReqBoxID"));
	String strReqID = String.valueOf(objParamForm.getParamValue("ReqID"));
	String strAnsID = String.valueOf(objParamForm.getParamValue("AnsID"));
	String strAnsFileID = String.valueOf(objParamForm.getParamValue("AnsFileID"));
	String strAnsType = String.valueOf(objParamForm.getParamValue("AnsType"));
	String strOriginFile = String.valueOf(objParamForm.getParamValue("OriginFile"));
	String strPdfFile = String.valueOf(objParamForm.getParamValue("PdfFile"));
	String strAnsOpin = String.valueOf(objParamForm.getParamValue("AnsOpin"));
	String strOpenCL = String.valueOf(objParamForm.getParamValue("OpenCL"));
	String strRegrID = String.valueOf(objParamForm.getParamValue("RegrID"));
	String strMsgDigest = String.valueOf(objParamForm.getParamValue("MsgDigest"));
	
	int intResult = objSMAIDelegate.setElcAnsInfoProc(objParamForm);
	
	if (intResult == 1)  {
		out.println("<script language='javascript'>");
		out.println("alert('�亯 ���� ������ ���������� �Ϸ��Ͽ����ϴ�.');");
		out.println("self.close();");
		out.println("opener.window.location.reload();");
		out.println("</script>");
	} else {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("");
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
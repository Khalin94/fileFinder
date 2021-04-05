<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemAnsDocSendForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemAnsDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commAnsDoc.CommAnsDocDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	CommAnsDocDelegate objBindDelegate = new CommAnsDocDelegate(); // �亯�� ���� ���� DELEGATE
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	MemAnsDocSendDelegate objADSDelegate = new MemAnsDocSendDelegate();
	SMemAnsDocSendForm objParamForm = new SMemAnsDocSendForm();
	UmsDelegate objUmsDelegate = new UmsDelegate();
	
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
	
	String strReqBoxID = (String)objParamForm.getParamValue("ReqBoxID"); // �䱸�� ID
	String strReqTp = (String)objParamForm.getParamValue("ReqTp"); // �䱸�� ����
	String strSndrID = (String)objParamForm.getParamValue("SndrID");
	String strRcvrID = (String)objParamForm.getParamValue("RcvrID");
	String strElcUse = (String)objParamForm.getParamValue("ElcUse");
	String strSmsUse = (String)objParamForm.getParamValue("SmsUse");
	String strAnsDocFilePath = null; // �亯�� ���� ���
	
	try {
		// ��¿������ ������ �亯�� ID Sequence�� �������Ѵ�
		String strAnsDocSeq = objRDSDelegate.getSeqNextVal("TBDS_ANS_DOC_INFO");
		strAnsDocSeq = StringUtil.padl(strAnsDocSeq, 10);
		strAnsDocFilePath = objBindDelegate.CreateAnsDoc(strReqBoxID, strAnsDocSeq);
		//strAnsDocFilePath = "C:\\temp\\2004\\0000000002\\0000000001.pdf";
		
		if (!StringUtil.isAssigned(strAnsDocFilePath)) {
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  		objMsgBean.setStrCode("�������.. �亯�� ���� ����µ� �ڲ� ���� ���ڳ�!!!!");
  			objMsgBean.setStrMsg("�亯�� ������ ������ �ϴµ� �ڲ� ������ ���ϴ�.. T_T");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		} else {
			
			// ������ �亯�� ���� ��δ� Form�� ��ƾ� �Ѵ�.
			objParamForm.setParamValue("AnsDocFilePath", strAnsDocFilePath);
			// �亯�� ID�� �̸� ���� FORM�� ��ƾ� �Ѵ�.
			objParamForm.setParamValue("AnsDocID", strAnsDocSeq);
			
			int intResult = objADSDelegate.setAnsDocSendProc(objParamForm);
			
			if (intResult < 1) {
				out.println("Error....................... Check the Log Contents....T_T");
			} else {
			
				// �߽��� ������ ���� ��~~~~~~~~~~~~~~~~��!!!!!!!!!!!!!!!!
				Hashtable hashSndrInfo = (Hashtable)objADSDelegate.getUserInfo(strSndrID);
				Hashtable hashRcvrInfo = (Hashtable)objADSDelegate.getUserInfo(strRcvrID);
				Hashtable hashSmsInfo = new Hashtable();
				Hashtable hashMailInfo = new Hashtable();
				
				String strSendPhoneNo = "";
				strSendPhoneNo = StringUtil.ReplaceString((String)hashSndrInfo.get("CPHONE"), "-", "");
				String strReturnPhoneNo = "";
				strReturnPhoneNo = StringUtil.ReplaceString((String)hashRcvrInfo.get("CPHONE"), "-", "");
				String strSendStatus = CodeConstants.ELC_SMS_SEND_REQ; // ���������� �׳� �߼� : 1
				String strSmsMsg = (String)objADSDelegate.getAnsDocSmsMsg();
				String strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ;
				String strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ;
				String strDeptGbn = CodeConstants.ELC_DEPT_CODE;
				String strUserID = strSndrID;
				String strOffiDocID = ""; // �亯�� �߼ۿ����� ������ ID ����!!!!!!!!!!
				String strInOutGbn = "2"; // ���� ----------> �䱸 : 2
				String strRcvrName = (String)hashRcvrInfo.get("USER_NM");
				String strRcvrMail = (String)hashRcvrInfo.get("EMAIL");;
				String strSndrName = (String)hashSndrInfo.get("USER_NM");;
				String strSndrMail = (String)hashSndrInfo.get("EMAIL");;;
				String strSubject = (String)objADSDelegate.getAnsDocMailSubject();
				String strContents = (String)objADSDelegate.getAnsDocMailContent();
				
				// SMS & e-mail �߼� ��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~��!!!!!!!!!!!!!!!!!
				// E-MAIL �߼� Hashtable ����
				hashMailInfo.put("RID", strRcvrID);
				hashMailInfo.put("RNAME", strRcvrName);
				hashMailInfo.put("RMAIL", strRcvrMail);
				hashMailInfo.put("SID", strSndrID);
				hashMailInfo.put("SNAME", strSndrName);
				hashMailInfo.put("SMAIL", strSndrMail);
				hashMailInfo.put("SUBJECT", strSubject);
				hashMailInfo.put("CONTENTS", strContents);
				hashMailInfo.put("SYSTEM_GBN", strSystemGbn);
				hashMailInfo.put("SERVICE_GBN", strServiceGbn);
				hashMailInfo.put("DEPT_GBN", strDeptGbn);
				hashMailInfo.put("USER_ID", strUserID);
				//hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
				hashMailInfo.put("IN_OUT_GBN", strInOutGbn);
				
				int intSendMailResult = objUmsDelegate.insertSMTP_REC(hashMailInfo);
				if (intSendMailResult < 1) {
					System.out.println("[���Ϲ߼�] �����δ� ���⼭ ������ �߻��߽�.... Ȯ�ιٶ�  ");
					intSendMailResult = 0;
				}
				int intSendSmsResult = 0;
				
				if (StringUtil.isAssigned(strSmsUse)) {
					// SMS �߼� Hashtable ����
					hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
					hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
					hashSmsInfo.put("SEND_STATUS", strSendStatus);
					hashSmsInfo.put("MSG", strSmsMsg);
					hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
					hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
					hashSmsInfo.put("DEPT_GBN", strDeptGbn);
					hashSmsInfo.put("USER_ID", strUserID);
					//hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
					hashSmsInfo.put("IN_OUT_GBN", strInOutGbn);
					intSendSmsResult = objUmsDelegate.insertSMS(hashSmsInfo);
					if (intSendSmsResult < 1) {
						System.out.println("[��������] �����δ� ���⼭ ������ �߻��߽�.... Ȯ�ιٶ�  ");
						intSendSmsResult = 0;
					}
				}
								
				// �߼����� ���̺� �Է�
				objParamForm.setParamValue("MsgSeq", String.valueOf(intSendSmsResult));
				objParamForm.setParamValue("MailID", String.valueOf(intSendMailResult));
				int intSendInfoResult = objADSDelegate.setNewRecordToSendInfo(objParamForm);
				if (intSendInfoResult < 1) System.out.println("[SMakeAnsDocSendProc.jsp] �߼����� ���̺� �Է� ���� �߻� Ȯ�� ���!!!!!!!");
				else System.out.println("[SMakeAnsDocSendProc.jsp] �߼����� ���̺� �Է� ����~~~ Success~~~~~~~!!!!!!!");
						
				out.println("<script language='javascript'>");
				out.println("alert('�亯�� �߼��� ���������� �Ϸ��Ͽ����ϴ�.');");
				out.println("self.close();");
				out.println("window.opener.location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp';");
				out.println("</script>");
				//out.println("<meta http-equiv='refresh' content='0; url=/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp'>");
			}
			
			
		} // ���� �䱸�� ���� ������.. ¼��¼��
		
	} catch(AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		
  		//out.println("Error Message : " + objAppEx.getMessage());
  		objAppEx.printStackTrace();
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
	  	return;
 	} // end try
%>
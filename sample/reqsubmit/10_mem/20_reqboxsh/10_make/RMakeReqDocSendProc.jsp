<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqDocSendForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commReqDoc.CommReqDocDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	CommReqDocDelegate objBindDelegate = new CommReqDocDelegate(); // �䱸�� ���� DELEGATE
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	RMemReqDocSendForm objParamForm = new RMemReqDocSendForm();
	UmsDelegate objUmsDelegate = new UmsDelegate();
	
	// ��� �۾��� ���� ����� ���� ��ü
	Hashtable hashResult = null;
	
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
	String strReqDocType = (String)objParamForm.getParamValue("ReqDocType"); // �䱸�� ���� 
	String strReqTp = (String)objParamForm.getParamValue("ReqTp"); // �䱸�� or ������
	String strSmsUse =  (String)objParamForm.getParamValue("SmsUse"); // SMS ��� ����
	String strReqDocFilePath = null; // �䱸�� ���� ���
	String strLegacyout = null;
	String strAttach = null;
	String strElcUse = null;
	
	String strElcEventCode = null; // ���ڰ��� ���� �̺�Ʈ �ڵ�
	String strSendPhoneNo = null; //���۹�ȣ
	String strReturnPhoneNo = null; //ȸ�Ź�ȣ
	String strSendStatus = null; // ���ۻ���
	String strSmsMsg = null; //�޽���
	String strSystemGbn = null; //�ý��۱���
	String strServiceGbn = null; //���񽺱���
	String strDeptGbn = null; //�μ�����
	String strUserID = null; //�����ID
	String strOffiDocID = null; //����ID
	String strInOutGbn = null; //���ܱ���
	
	String strRcvrID = null; // ������ID
	String strRcvrName = null; // �����ڸ�
	String strRcvrMail = null; // �����ڸ����ּ�
	String strSndrID = null; // �߽���ID
	String strSndrName = null; // �߽��ڸ�
	String strSndrMail = null; // �߽��ڸ����ּ�
	String strSubject = null; // ����
	String strContents  = null; // ����
	
	/*
	 ********************** ó���ؾ� �� ����� ���� ������ ���� **********************
	 1. ��������+email
	 2. ��������+email+SMS
	 3. ��������+���ڰ���+email
	 4. ��������+���ڰ���+email+SMS
	
	 ********************** ó���ؾ� �� �׸���� ������ ���� **********************
	 1. �䱸�� ���� �ִ��� ���� Ȯ�� �� ���� ���� ���� ��� �޾ƿ���
	 2. �䱸�� ���̺� ��� ���� ����
	 3. SMS���̺� ��� ���� ����
	 4. e-mail �߼� ���� ���̺� ��� ���� ����
	 5. �߽����� ���̺� ��� ���� ����
	 6. ���ڰ����ʿ� �ѱ� �䱸�� ������ Base64�� ���ڵ� �Ѵ�.
	 7. �䱸�� ���� �� �䱸 ���� ���̺��� ���� ������ '������' �� ����
	 8. ���ڰ����ʿ� �ʿ��� �Ķ���͸� ������ ������ �ش� �������� ȣ��
	 9. ���� ������ ���� �� �۾� ����� �޾� �䱸�� ���� �� �䱸 ������ ���¸� �ش� ��ȯ ���� ���� ���� 
	    (���� �߻� �� 
	     1. SMS���̺� �� e-mail �߼� ���� ���̺�, �׸��� �߽� ���� ���̺��� ������ DELETE
	     2. �䱸�� ���� �� �䱸 ���� ���̺��� ���� ������ �ش��ϴ� �ڵ尪���� ������Ʈ)
	*/
	
	try {
		// ��¿������ ������ �䱸�� ID Sequence�� �������Ѵ�
		String strReqDocSeq = objRDSDelegate.getSeqNextVal("TBDS_REQ_DOC_INFO");
		
		strReqDocFilePath  = objBindDelegate.CreateReqDoc(strReqBoxID, strReqTp, strReqDocSeq);
		//strReqDocFilePath = "D:\\temp\\2004\\0000000180\\0000000001.pdf";
		System.out.println("[RMakeReqDocSendProc.jsp] �䱸�� �ӽ� ���� ���� ��� : " + strReqDocFilePath);
		
		// ������ �Ѵٰ�� �ߴµ� ������ ������� ������ �ٽ� ���� �߻�
		if (!StringUtil.isAssigned(strReqDocFilePath)) {
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  		objMsgBean.setStrCode("�������.. �䱸�� ���� ����µ� �ڲ� ���� ���ڳ�!!!!");
  			objMsgBean.setStrMsg("�䱸�� ������ ������ �ϴµ� �ڲ� ������ ���ϴ�.. T_T");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		} else { // �䱸�� ���� ������ �����ߴٸ�

			// ������ �䱸�� ���� ��δ� Form�� ��ƾ� �Ѵ�.
			objParamForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
			// �䱸�� ID�� �̸� ���� FORM�� ��ƾ� �Ѵ�.
			objParamForm.setParamValue("ReqDocID", strReqDocSeq);
			
			// �����Ѵٸ� �Ʒ��� Hashtable�� ���� ������ ����� ���̴�.
			System.out.println("[RMakeReqDocSendProc.jsp] setSendReqDocProc START!!!!!!!!!!!!!");
			hashResult = objRDSDelegate.setSendReqDocProc(objParamForm);
			System.out.println("[RMakeReqDocSendProc.jsp] setSendReqDocProc END!!!!!!!!!!!!!");
			
			// �߽��� ���� OBJECT
			Hashtable hashSndr = objRDSDelegate.getRecordListFromUserInfo(strReqBoxID, CodeConstants.REQ_ORGAN_PERSON);
			// ������ ���� OBJECT
			Hashtable hashRcvr = objRDSDelegate.getRecordListFromUserInfo(strReqBoxID, CodeConstants.SUBMIT_ORGAN_PERSON);
			// SMS �Է� ȣ�� �Լ��� ����� Hashtable
			Hashtable hashSmsInfo = new Hashtable();
			// Mail �Է� ȣ�� �Լ��� ����� Hashtable
			Hashtable hashMailInfo = new Hashtable();
			
			strElcUse = (String)hashResult.get("ElcUse");
			if (StringUtil.isAssigned((String)hashResult.get("OffiDocID"))) strOffiDocID = (String)hashResult.get("OffiDocID");
			else strOffiDocID = "";
			strLegacyout = StringUtil.getEmptyIfNull((String)hashResult.get("Legacyout"));
			strAttach = StringUtil.getEmptyIfNull((String)hashResult.get("Attach"));
			
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // ���ڰ��� : ELC_EVENT_0X08
				strElcEventCode = CodeConstants.ELC_EVENT_0X08;
			} else {
				strElcEventCode = CodeConstants.ELC_EVENT_NONE;
			}
			strSendPhoneNo = StringUtil.ReplaceString((String)hashSndr.get("CPHONE"), "-", "");
			strReturnPhoneNo = StringUtil.ReplaceString((String)hashRcvr.get("CPHONE"), "-", "");
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // ���ڰ��� : 9
				strSendStatus = CodeConstants.ELC_SMS_SEND_WAIT;
			} else { // �������⸸ : 1
				strSendStatus = CodeConstants.ELC_SMS_SEND_REQ;
			}
			strSmsMsg = objRDSDelegate.getSmsMsg(strElcEventCode);
			strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ;
			strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ;
			strDeptGbn = CodeConstants.ELC_DEPT_CODE;
			strUserID = (String)hashSndr.get("USER_ID");
			strInOutGbn = "1";
	
			strRcvrID = (String)hashRcvr.get("USER_ID");
			strRcvrName = (String)hashRcvr.get("USER_NM");
			strRcvrMail = (String)hashRcvr.get("EMAIL");
			strSndrID = (String)hashSndr.get("USER_ID");
			strSndrName = (String)hashSndr.get("USER_NM");
			strSndrMail = (String)hashSndr.get("EMAIL");
			strSubject = objRDSDelegate.getMailSubject(strElcEventCode);
			strContents  = objRDSDelegate.getMailContent(strElcEventCode);
			
			// SMS �߼� Hashtable ���� ����
			System.out.println("[RMakeReqDocSendProc.jsp] hashSmsInfo Size : " + hashSmsInfo.size());
			System.out.println("[RMakeReqDocSendProc.jsp] SEND_PHONE_NO : "+strSendPhoneNo);
			System.out.println("[RMakeReqDocSendProc.jsp] RETURN_NO : "+strReturnPhoneNo);
			System.out.println("[RMakeReqDocSendProc.jsp] SEND_STATUS : "+strSendStatus);
			System.out.println("[RMakeReqDocSendProc.jsp] MSG : "+strSmsMsg);
			System.out.println("[RMakeReqDocSendProc.jsp] SYSTEM_GBN : "+strSystemGbn);
			System.out.println("[RMakeReqDocSendProc.jsp] SERVICE_GBN : "+strServiceGbn);
			System.out.println("[RMakeReqDocSendProc.jsp] DEPT_GBN : "+strDeptGbn);
			System.out.println("[RMakeReqDocSendProc.jsp] USER_ID : "+strUserID);
			System.out.println("[RMakeReqDocSendProc.jsp] OFFI_DOC_ID : "+strOffiDocID);
			System.out.println("[RMakeReqDocSendProc.jsp] IN_OUT_GBN : "+strInOutGbn);
			System.out.println("[RMakeReqDocSendProc.jsp] hashMailInfo Size : " + hashMailInfo.size());
			System.out.println("[RMakeReqDocSendProc.jsp] RID : " + strRcvrID);
			System.out.println("[RMakeReqDocSendProc.jsp] RNAME : " + strRcvrName);
			System.out.println("[RMakeReqDocSendProc.jsp] RMAIL : " + strRcvrMail);
			System.out.println("[RMakeReqDocSendProc.jsp] SID : " + strSndrID);
			System.out.println("[RMakeReqDocSendProc.jsp] SNAME : " + strSndrName);
			System.out.println("[RMakeReqDocSendProc.jsp] SMAIL : " + strSndrMail);
			System.out.println("[RMakeReqDocSendProc.jsp] SUBJECT : " + strSubject);
			System.out.println("[RMakeReqDocSendProc.jsp] CONTENTS : " + strContents);
			System.out.println("[RMakeReqDocSendProc.jsp] SYSTEM_GBN : " + strSystemGbn);
			System.out.println("[RMakeReqDocSendProc.jsp] SERVICE_GBN : " + strServiceGbn);
			System.out.println("[RMakeReqDocSendProc.jsp] DEPT_GBN : " + strDeptGbn);
			System.out.println("[RMakeReqDocSendProc.jsp] USER_ID : " + strUserID);
			System.out.println("[RMakeReqDocSendProc.jsp] OFFI_DOC_ID : " + strOffiDocID);
			System.out.println("[RMakeReqDocSendProc.jsp] IN_OUT_GBN : " + strInOutGbn);
			
			// SMS �߼� Hashtable ����
			hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
			hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
			hashSmsInfo.put("SEND_STATUS", strSendStatus);
			hashSmsInfo.put("MSG", strSmsMsg);
			hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
			hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
			hashSmsInfo.put("DEPT_GBN", strDeptGbn);
			hashSmsInfo.put("USER_ID", strUserID);
			if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
			hashSmsInfo.put("IN_OUT_GBN", strInOutGbn);
			
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
			if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
			hashMailInfo.put("IN_OUT_GBN", strInOutGbn);
			
			int intMailSendResult = objUmsDelegate.insertSMTP_REC(hashMailInfo);	
			int intSmsSendResult = 0;
			if (StringUtil.isAssigned(strSmsUse)) {
				intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);	
				if (intSmsSendResult < 1) System.out.println("[RMakeReqDocSendProc.jsp] SMS �߼� ��� ����� ���⼭ ������ �߻��߽��ϴ�. T_T");
			} else {
				intSmsSendResult = 1;
			}
			
			if (intSmsSendResult > 0 && intMailSendResult > 0) {
				System.out.println("[RMakeReqDocSendProc.jsp] SMS �߼� ��� Sequence ID : " + intSmsSendResult);
				System.out.println("[RMakeReqDocSendProc.jsp] Mail �߼� ��� Sequence ID : " + intMailSendResult);
			} else {
				System.out.println("[RMakeReqDocSendProc.jsp] SMS & mail �߼� ����... ���� �м� ���");
			}
			
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // ������� ����
				System.out.println("[RMakeReqDocSendProc.jsp] systemID : "+strOffiDocID);
				System.out.println("[RMakeReqDocSendProc.jsp] businessID : "+strOffiDocID);
				System.out.println("[RMakeReqDocSendProc.jsp] cssvertion : 2.0");
				System.out.println("[RMakeReqDocSendProc.jsp] formversion : 1.0");
				System.out.println("[RMakeReqDocSendProc.jsp] title : ���ڰ���");
				System.out.println("[RMakeReqDocSendProc.jsp] method : file");
				System.out.println("[RMakeReqDocSendProc.jsp] �䱸�� ID : "+strReqBoxID);
				System.out.println("[RMakeReqDocSendProc.jsp] ���ڰ��翩�� : "+strElcUse);
				System.out.println("[RMakeReqDocSendProc.jsp] ���� ID : "+strOffiDocID);
				//System.out.println("[RMakeReqDocSendProc.jsp] ������ XML ���ڿ�(Legacyout) : "+strLegacyout);
				//System.out.println("[RMakeReqDocSendProc.jsp] ������ XML ���ڿ� 2(Attach) : "+strAttach);
				
				out.println("<FORM method='post' action='http://docs.assembly.go.kr/acubecn/legacy/ACN_LegacyBridge.jsp' name='elcForm'>");
				out.println("<input type='hidden' name='systemid' value="+CodeConstants.ELC_SYSTEM_ID+"><BR>");
				out.println("<input type='hidden' name='businessid' value="+strReqDocType+"><BR>");
				out.println("<input type='hidden' name='cssversion' value='2.0'><BR>");
				out.println("<input type='hidden' name='formversion' value='1.0'><BR>");
				out.println("<input type='hidden' name='title' value='���ڰ���'><BR>");
				out.println("<input type='hidden' name='method' value='file'><BR>");
				//out.println("<input type='hidden' name='legacyout' value="+strLegacyout+"><BR>");
				//out.println("<input type='hidden' name='attaches' value="+strAttach+"><BR>");
				out.println("<textarea cols='50' rows='5' name='legacyout' style='border:1px solid #ffffff; color:#ffffff;'>"+strLegacyout+"</textarea>");
				out.println("<textarea cols='50' rows='5' name='attaches' style='border:1px solid #ffffff; color:#ffffff;'>"+strAttach+"</textarea>");
				out.println("<input type='hidden' name='deptcode' value='"+strDeptGbn+"'><BR>");
				out.println("</FORM>");
			
			} else { // �������⸸ ó��
				int intResultOfUpdateSendInfo = 0;
				if (intSmsSendResult > 0 && intMailSendResult > 0) {
					intResultOfUpdateSendInfo = objRDSDelegate.setRecordToSendInfo(strReqBoxID, String.valueOf(intSmsSendResult), String.valueOf(intMailSendResult));
					if (intResultOfUpdateSendInfo > 0) {
						System.out.println("[RMakeReqDocSendProc.jsp] �߼����� ������Ʈ���� ����");
					}
				}
				out.println("<script language='javascript'>");
				out.println("alert('���������� ó���Ǿ����ϴ�.');");
				out.println("self.close();");
				out.println("window.opener.location.href='RMakeReqBoxList.jsp'");
				out.println("</script>");
			} // end if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // ������� ����
			
		} // end if (!StringUtil.isAssigned(strReqDocFilePath)) {
		
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

<% if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // ������� ���� %>
	<script language="javascript">
		function autoSubmit() {
			document.elcForm.submit();
		}
	</script>
	<meta http-equiv='refresh' content='1; url=javascript:autoSubmit()'>
	<!-- input type="button" name="" value="SUBMIT" onClick="javascript:autoSubmit()" -->
<% } %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemAnsDocSendForm" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemAnsDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commAnsDoc.CommAnsDocDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commReqDoc.CommReqDocDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.OrganInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqDocSendForm" %>

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
	CommReqDocDelegate objDocBean = new CommReqDocDelegate(); // �䱸�� ���� DELEGATE
	OrganInfoDelegate objOrganDelegate = new OrganInfoDelegate();
	SMemAnsDocSendForm objParamForm = new SMemAnsDocSendForm();
	RMemReqDocSendForm objForm = new RMemReqDocSendForm();
	UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();

	// �� �ʸ� Ȧ�� �̷��� ���ƾ� �ϴ���... CVS���� �������....
	String strReturnURL = request.getParameter("ReturnURL");

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
	String strReqOrganNm = (String)objParamForm.getParamValue("ReqOrganNm"); // �䱸�����
	String strReqOrganID = (String)objParamForm.getParamValue("ReqOrganID"); // �䱸 ��� ID
	String strSubmtOrganNm = (String)objParamForm.getParamValue("SubmtOrganNm"); // ��������.
	String strAnsDocFilePath = null; // �亯�� ���� ���
	//strReturnURL = strReturnURL+"?ReqBoxID="+strReqBoxID;
	System.out.println("strReturnURL ::"+strReturnURL);
	String strReqDocFilePath = null;

	try {
		// ��¿������ ������ �亯�� ID Sequence�� �������Ѵ�
		String strAnsDocSeq = objRDSDelegate.getSeqNextVal("TBDS_ANS_DOC_INFO");
		strAnsDocSeq = StringUtil.padl(strAnsDocSeq, 10);
		strAnsDocFilePath = objBindDelegate.CreateAnsDoc(strReqBoxID, strAnsDocSeq);
		String strReqDocSeq = objRDSDelegate.getSeqNextVal("TBDS_REQ_DOC_INFO");
		strReqDocFilePath  = objDocBean.CreateReqDoc(strReqBoxID, "001", StringUtil.padl(strReqDocSeq, 10));

		if (!StringUtil.isAssigned(strAnsDocFilePath)) {
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  		objMsgBean.setStrCode("�������.. �亯�� ���� ����µ� �ڲ� ���� ���ڳ�!!!!");
  			objMsgBean.setStrMsg("�亯�� ���� ���� ���� : �亯�� ���� ���� ���� ���� �ٶ��ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {  // �亯�� ������ ���������� ����Ǿ���.

			// ������ �亯�� ���� ��δ� Form�� ��ƾ� �Ѵ�.
			objParamForm.setParamValue("AnsDocFilePath", strAnsDocFilePath);
			// �亯�� ID�� �̸� ���� FORM�� ��ƾ� �Ѵ�.
			objParamForm.setParamValue("AnsDocID", strAnsDocSeq);

			// �亯�� �߼� ���õ� DB IO �۾��� �����Ѵ�.
			int intResult = objADSDelegate.setAnsDocSendProc(objParamForm);

			objForm.setParamValue("ReqBoxID", strReqBoxID);
			objForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
			objForm.setParamValue("ReqDocID", strReqDocSeq);
			int intResult00 = objRDSDelegate.setNewRecordToReqDocInfo(objForm);

			if (intResult < 1) {
				out.println("Error....................... Check the Log Contents....T_T");
			} else {

				// �߽��� ������ ���� ��~~~~~~~~~~~~~~~~��!!!!!!!!!!!!!!!!
				//Hashtable hashSndrInfo = (Hashtable)objRDSDelegate.getRecordListFromUserInfo(strSndrID, CodeConstants.REQ_ORGAN_PERSON, objUserInfo.getOrganID());
				//Hashtable hashRcvrInfo = (Hashtable)objRDSDelegate.getRecordListFromUserInfo(strRcvrID, CodeConstants.SUBMIT_ORGAN_PERSON, strSubmtOrganID);
				Hashtable hashSndrInfo = (Hashtable)objRDSDelegate.getUserInfoByUserID(strSndrID);
				Hashtable hashRcvrInfo = (Hashtable)objRDSDelegate.getUserInfoByUserID(strRcvrID);
				Hashtable hashOrganInfo = (Hashtable)objOrganDelegate.getOrganInfo((String)objUserInfo.getOrganID());
				Hashtable hashSmsInfo = new Hashtable();
				Hashtable hashMailInfo = new Hashtable();

				String strSendPhoneNo = "";
				String strReturnPhoneNo = "";
				String strSendPhoneNo1 = "";
				String strReturnPhoneNo1 = "";
				String strSubmtOrganNm2 = StringUtil.getEmptyIfNull((String)hashOrganInfo.get("ORGAN_NM"));

				strSendPhoneNo = StringUtil.getEmptyIfNull((String)hashRcvrInfo.get("CPHONE"));
				strReturnPhoneNo = StringUtil.getEmptyIfNull((String)hashSndrInfo.get("CPHONE"));
				strSendPhoneNo1 = StringUtil.getEmptyIfNull((String)hashRcvrInfo.get("CPHONE"));
				strReturnPhoneNo1 = StringUtil.getEmptyIfNull((String)hashSndrInfo.get("CPHONE"));
				if (StringUtil.isAssigned(strSendPhoneNo)) {
					strSendPhoneNo = StringUtil.ReplaceString((String)hashRcvrInfo.get("CPHONE"), "-", ""); 	// ���� ��� �ڵ��� ��ȣ
				}
				if (StringUtil.isAssigned(strReturnPhoneNo)) {
					strReturnPhoneNo = StringUtil.ReplaceString((String)hashSndrInfo.get("CPHONE"), "-", "");	// ������ ��� �ڵ��� ��ȣ
				}

				String strSendStatus = CodeConstants.ELC_SMS_SEND_REQ; // ���������� �׳� �߼� : 1


				// 2004-06-04 ������ ���ڰ��� ���� �Լ�������, ��û�� ���� ����Ǿ���.
				//String strSmsMsg = (String)objADSDelegate.getAnsDocSmsMsg(strSubmtOrganNm2);
				String strSmsMsg = "�����ڷ���������ý��ۿ� �亯���� ����Ǿ����ϴ�["+strSubmtOrganNm2+"]";

				System.out.println("�亯�޽��� : "+strReqBoxID +"-"+ strSmsMsg);

				String strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ;
				String strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ;
				String strDeptGbn = StringUtil.getEmptyIfNull((String)hashSndrInfo.get("GOV_STD_CD"));
				String strUserID = strSndrID;
				String strOffiDocID = ""; // �亯�� �߼ۿ����� ������ ID ����!!!!!!!!!!
				String strInOutGbn = "2"; // ���� ----------> �䱸 : 2
				String strRcvrName = (String)hashRcvrInfo.get("USER_NM");
				String strRcvrMail = (String)hashRcvrInfo.get("EMAIL");
				String strSndrName = (String)hashSndrInfo.get("USER_NM");
				String strSndrMail = (String)hashSndrInfo.get("EMAIL");
				String strSubject = (String)objADSDelegate.getAnsDocMailSubject();

				// 2004-07-28
				// �䱸�ڴ� ������
				// �����ڴ� �߽���
				// �����ڸ��� �����ϰ�� �߽��� ������ ��� �Է��ؾ� ��.
				//String strContents = (String)objADSDelegate.getAnsDocMailContent(strSndrName, strReqOrganNm, strSendPhoneNo, strSndrMail);
				String strContents = (String)objADSDelegate.getAnsDocMailContent(strRcvrName, strSubmtOrganNm+" "+(String)objUserInfo.getUserName(), strReturnPhoneNo1, strSndrMail);

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
				hashMailInfo.put("STATUS", "0"); // �ٷ� ����
				hashMailInfo.put("DEPT_GBN", strReqOrganID);
				hashMailInfo.put("DEPT_NM", strReqOrganNm); // �䱸�����
				//hashMailInfo.put("USER_ID", strUserID);
				//hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
				//hashMailInfo.put("IN_OUT_GBN", strInOutGbn);

				int intSendMailResult = objUmsDelegate.insertSMTP_WEB_REC(hashMailInfo);
				//int intSendMailResult = 1;
				if (intSendMailResult < 1) {
					System.out.println("[���Ϲ߼�] �����δ� ���⼭ ������ �߻��߽�.... Ȯ�ιٶ�  ");
					intSendMailResult = 0;
				}
				int intSendSmsResult = 0;

				if (CodeConstants.NTC_MTD_BOTH.equalsIgnoreCase(strSmsUse) && StringUtil.isAssigned(strSendPhoneNo)) {
					// SMS �߼� Hashtable ����
					hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
					hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
					hashSmsInfo.put("SEND_STATUS", "1");
					hashSmsInfo.put("MSG", strSmsMsg);
					hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
					hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
					hashSmsInfo.put("DEPT_GBN", strReqOrganID);
					hashSmsInfo.put("USER_ID", strUserID);
					hashSmsInfo.put("DEPT_NM", objUserInfo.getOrganID()); // 2004-04-13 �߰� 1
					hashSmsInfo.put("USER_NM", strSndrName); // 2004-04-13 �߰� 2
					//hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
					//hashSmsInfo.put("IN_OUT_GBN", strInOutGbn);
					intSendSmsResult = objUmsDelegate.insertSMS(hashSmsInfo);
					//intSendSmsResult = 1;
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
				else System.out.println("[AnsDocSendProc.jsp] �߼����� ���̺� �Է� ����~~~ Success~~~~~~~!!!!!!!");

				out.println("<script language='javascript'>");
				out.println("alert('�亯�� �߼��� �Ϸ��Ͽ����ϴ�.\\n�߼��Ͻ� �亯�ڷ�� [����Ϸ� �䱸��]���� Ȯ�� �����մϴ�.');");
				out.println("self.close();");
                System.out.println("�ռ���strReturnURL"+strReturnURL);
				if (strReturnURL.indexOf("10_mem")>0){
				out.println("window.opener.location.href='/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp';");
                } else {
				out.println("window.opener.location.href='/reqsubmit/20_comm/20_reqboxsh/40_subend/SSubEndBoxList.jsp';");
                }
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
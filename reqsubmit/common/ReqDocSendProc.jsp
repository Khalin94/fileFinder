<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqDocSendForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
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
	UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();
	
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
	String strReqDocType = (String)objParamForm.getParamValue("ReqDocType"); // ���ڰ��縦 ���� �䱸�� ����
	String strReqTp = (String)objParamForm.getParamValue("ReqTp"); // �䱸�� ������ ���� �䱸�� �� ����
	String strReturnURL = (String)objParamForm.getParamValue("ReturnURL");
	
	String strElcUse =  (String)objParamForm.getParamValue("ElcUse"); // ���� ���� ��� ����
	String strSmsUse =  (String)objParamForm.getParamValue("SmsUse"); // SMS ��� ����
	String strSubmtOrganID = (String)objParamForm.getParamValue("SubmtOrgID"); // ������ ID

	String strReqOrganID = (String)objParamForm.getParamValue("ReqOrganID"); // �䱸���ID
	String strReqOrganNm = (String)objParamForm.getParamValue("ReqOrganNm"); // �䱸�����

	// 2004-09-18
	String strReqOrgGbnCode = objUserInfo.getOrganGBNCode();
	
	// 2004-07-28
	String strSelectedRcvrID = (String)objParamForm.getParamValue("RcvrID"); // ȭ�鿡�� ���õ� ������ ID
	String[] arrRcvrID = StringUtil.split("^", strSelectedRcvrID);
	objParamForm.setParamValue("RcvrID", arrRcvrID[1]);
	String strRealSubmtOrganID = (String)arrRcvrID[0];
	String strReqDocFilePath = null; // �䱸�� ���� ���
	String strLegacyout = null;
	String strAttach = null;
	String strSubmtGccCode = null;
	String strSubmtOrganNm = null;
	
	String strElcEventCode = null; // ���ڰ��� ���� �̺�Ʈ �ڵ�
	String strSendPhoneNo = null; //���۹�ȣ
	String strReturnPhoneNo = null; //ȸ�Ź�ȣ
	String strSendPhoneNo1 = null; //���۹�ȣ
	String strReturnPhoneNo1 = null; //ȸ�Ź�ȣ
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
	String strUserKind  = null; // ��������
		
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
		
		strReqDocFilePath  = objBindDelegate.CreateReqDoc(strReqBoxID, strReqTp, StringUtil.padl(strReqDocSeq, 10));
		//strReqDocFilePath = "sfd";
	
		// ������ �Ѵٰ�� �ߴµ� ������ ������� ������ �ٽ� ���� �߻�
		if (!StringUtil.isAssigned(strReqDocFilePath)) {
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  		objMsgBean.setStrCode("�䱸�� ���� ���� ���� : ����� ���� ���");
  			objMsgBean.setStrMsg("�䱸�� ���� ���� ���� : ����� ���� ���");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		} else { // �䱸�� ���� ������ �����ߴٸ�
			// ������ �䱸�� ���� ��δ� Form�� ��ƾ� �Ѵ�.
			// ������ �䱸���� /2004/~/*.pdf ���·� ��ȯ�Ѵ�. �״�� FORM�� SET �� ��!!!
			// objParamForm.setParamValue("ReqDocFilePath", EnvConstants.UNIX_SAVE_PATH+strReqDocFilePath);
			objParamForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
			// �䱸�� ID�� �̸� ���� FORM�� ��ƾ� �Ѵ�.
			objParamForm.setParamValue("ReqDocID", strReqDocSeq);
			
			// �����Ѵٸ� �Ʒ��� Hashtable�� ���� ������ ����� ���̴�.
			hashResult = objRDSDelegate.setSendReqDocProc(objParamForm);
			
			// �߽��� ���� OBJECT
			Hashtable hashSndr = objRDSDelegate.getRecordListFromUserInfo(strReqBoxID, CodeConstants.REQ_ORGAN_PERSON, strReqOrganID); 
			// ������ ���� OBJECT
			Hashtable hashRcvr = objRDSDelegate.getRecordListFromUserInfo(strReqBoxID, CodeConstants.SUBMIT_ORGAN_PERSON, strRealSubmtOrganID);
			
			/*
			out.println("�˼��մϴ�. �׽�Ʈ ���Դϴ�.<BR>��� �Ŀ� �ٽ� �̿��� �ֽñ� �ٶ��ϴ�.<BR>");
			out.println("�䱸�� ID : " +strReqBoxID+"<BR>");
			out.println("�䱸���ID : " +strReqOrganID+"<BR>");
			out.println("������ID : " + arrRcvrID[0]+"<BR>");
			out.println("�䱸��� �䱸�� ID : " +objUserInfo.getUserID()+"<BR>");
			out.println("������ ����� ID : " + arrRcvrID[1]+"<BR>");
			out.println("������ ID : "+(String)hashRcvr.get("EMAIL")+"<BR>");
			out.println("�߽��� ID : "+(String)hashSndr.get("USER_ID")+"<BR>");
			out.println("������ �̸� : "+(String)hashRcvr.get("EMAIL")+"<BR>");
			out.println("�߽��� �̸� : "+(String)hashSndr.get("USER_NM")+"<BR>");
			out.println("������ ���� : "+(String)hashRcvr.get("EMAIL")+"<BR>");
			out.println("�߽��� ���� : "+(String)hashSndr.get("EMAIL")+"<BR>");
			out.println("������ �ڵ��� ��ȣ : "+(String)hashRcvr.get("CPHONE")+"<BR>");
			out.println("�߽��� �ڵ��� ��ȣ : "+(String)hashSndr.get("CPHONE")+"<BR>");
			if (1==1) return;
			*/
			// SMS �Է� ȣ�� �Լ��� ����� Hashtable
			Hashtable hashSmsInfo = new Hashtable();
			// Mail �Է� ȣ�� �Լ��� ����� Hashtable
			Hashtable hashMailInfo = new Hashtable();
						
			// 2004-08-02 �� �̷��� �ߴ���???
			// strElcUse = (String)hashResult.get("ElcUse");

			if (StringUtil.isAssigned((String)hashResult.get("OffiDocID"))) strOffiDocID = (String)hashResult.get("OffiDocID");
			else strOffiDocID = "";
			strLegacyout = StringUtil.getEmptyIfNull((String)hashResult.get("Legacyout"));
			strAttach = StringUtil.getEmptyIfNull((String)hashResult.get("Attach"));
			strAttach = StringUtil.ReplaceString(strAttach, "KB", "");
			strSubmtGccCode = StringUtil.getEmptyIfNull((String)hashResult.get("SubmtGccCode"));
			strSubmtOrganNm = StringUtil.getEmptyIfNull((String)hashResult.get("SubmtOrganNm"));
			
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // ���ڰ��� : ELC_EVENT_0X08
				strElcEventCode = CodeConstants.ELC_EVENT_0X08;
			} else {
				strElcEventCode = CodeConstants.ELC_EVENT_NONE;
			}
			
			strSendPhoneNo = StringUtil.getEmptyIfNull((String)hashRcvr.get("CPHONE"));
			strReturnPhoneNo = StringUtil.getEmptyIfNull((String)hashSndr.get("CPHONE"));

			strSendPhoneNo1 = StringUtil.getEmptyIfNull((String)hashRcvr.get("CPHONE"));
			strReturnPhoneNo1 = StringUtil.getEmptyIfNull((String)hashSndr.get("CPHONE"));
			strUserKind = StringUtil.getEmptyIfNull((String)hashSndr.get("USER_KIND"));
			
			System.out.println("kangthis log SMS => strSendPhoneNo : " + strSendPhoneNo);
			System.out.println("kangthis log SMS => strReturnPhoneNo : " + strReturnPhoneNo);
			System.out.println("kangthis log SMS => strSendPhoneNo1 : " + strSendPhoneNo1);
			System.out.println("kangthis log SMS => strReturnPhoneNo1 : " + strReturnPhoneNo1);
			System.out.println("kangthis log SMS => strUserKind : " + strUserKind);

			if (StringUtil.isAssigned(strSendPhoneNo)) {
				strSendPhoneNo = StringUtil.ReplaceString((String)hashRcvr.get("CPHONE"), "-", ""); 	// ���� ��� �ڵ��� ��ȣ
			}
			if (StringUtil.isAssigned(strReturnPhoneNo)) {
				strReturnPhoneNo = StringUtil.ReplaceString((String)hashSndr.get("CPHONE"), "-", "");	// ������ ��� �ڵ��� ��ȣ
			}
			
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // ���ڰ��� : 9
				strSendStatus = CodeConstants.ELC_SMS_SEND_WAIT;
			} else { // �������⸸ : 1
				strSendStatus = CodeConstants.ELC_SMS_SEND_REQ;
			}
			
			// 2004-06-04 ���� �̺�Ʈ �ڵ尡 ���ڰ����� ������, �䱸������� �ֱ�� �Ѵ�.
			strSmsMsg = objRDSDelegate.getSmsMsg(strReqOrganNm);
			
			strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ;
			strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ;

			// 2004-09-18 
			// ���ڹ����ý����� ������ �μ� �ڵ尡 ����ȸ �߼��� ���
			//  970002�� ��� C70002�� ���� ù�ڸ��� 'C'�� ġȯ�ؼ� �����ؾ� ��
			strDeptGbn = (String)hashSndr.get("GOV_STD_CD");
			if("004".equalsIgnoreCase(strReqOrgGbnCode)) {
				strDeptGbn = "C"+strDeptGbn.substring(1, strDeptGbn.length());
			}

			strUserID = (String)hashSndr.get("USER_ID");
			strInOutGbn = "1";
	
			strRcvrID = (String)hashRcvr.get("USER_ID");
			strRcvrName = (String)hashRcvr.get("USER_NM");
			strRcvrMail = StringUtil.getEmptyIfNull((String)hashRcvr.get("EMAIL"), "none");
			strSndrID = (String)hashSndr.get("USER_ID");
			strSndrName = (String)hashSndr.get("USER_NM");
			strSndrMail = StringUtil.getEmptyIfNull((String)hashSndr.get("EMAIL"), "none");
			strSubject = objRDSDelegate.getMailSubject(strElcEventCode);
			// strContents  = objRDSDelegate.getMailContent(strElcEventCode);
			strContents  = objRDSDelegate.getMailContentURL(strRcvrName, strReqOrganNm+" "+(String)objUserInfo.getUserName(), strReturnPhoneNo1, strSndrMail);

			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // ������� ����
				out.println("<FORM method='post' action='"+EnvConstants.ELC_ACTION_URL+"' name='elcForm'>");
				out.println("<input type='hidden' name='systemid' value="+CodeConstants.ELC_SYSTEM_ID+"><BR>");
				out.println("<input type='hidden' name='businessid' value="+strReqDocType+"><BR>");
				out.println("<input type='hidden' name='cssversion' value='2.0'><BR>");
				out.println("<input type='hidden' name='formversion' value='1.0'><BR>");
				out.println("<input type='hidden' name='title' value='"+strSubmtOrganNm+" �䱸�� �߼�'><BR>");
				out.println("<input type='hidden' name='method' value='file'><BR>");
				out.println("<DIV id='textareaDIV' style='display:none;'>");
				out.println("<textarea cols='50' rows='5' name='legacyout' style='border:1px solid #ffffff; color:#ffffff;'>"+strLegacyout+"</textarea>");
				out.println("<textarea cols='50' rows='5' name='attaches' style='border:1px solid #ffffff; color:#ffffff;'>"+strAttach+"</textarea>");
				out.println("</DIV>");
				out.println("<input type='hidden' name='deptcode' value='"+strDeptGbn+"'><BR>");
				//out.println("<input type='hidden' name='recipients' value='"+strSubmtGccCode+"'><BR>"); // ����ó�ڵ�(������ GCC Code)
				//out.println("<input type='hidden' name='recipnames' value='"+strSubmtOrganNm+"'><BR>"); // ����ó��(��������)
				out.println("<input type='hidden' name='bounds' value='O'><BR>"); // I : ����, O: �ܺ�
				out.println("</FORM>");
			
			} else { // �������⸸ ó��
			
				// E-MAIL �߼� Hashtable ����
				hashMailInfo.put("RID", strRcvrID);
				hashMailInfo.put("RNAME", strRcvrName);
				hashMailInfo.put("RMAIL", strRcvrMail);
				hashMailInfo.put("SID", strSndrID);
				hashMailInfo.put("SNAME", strSndrName);
				hashMailInfo.put("SMAIL", strSndrMail);
				hashMailInfo.put("SUBJECT", strSubject);
				hashMailInfo.put("CONTENTS", strContents); // ������ CONTENTS �������� URL LINK�� ��ȯ
				hashMailInfo.put("SYSTEM_GBN", strSystemGbn);
				hashMailInfo.put("SERVICE_GBN", strServiceGbn);
				//hashMailInfo.put("STATUS", strSendStatus);
				hashMailInfo.put("STATUS", "0"); // ��ù߼� : 0, ��� : 9
				hashMailInfo.put("DEPT_GBN", strReqOrganID);
				hashMailInfo.put("DEPT_NM", strReqOrganNm); // �䱸�����
				//hashMailInfo.put("USER_ID", strUserID);
				//if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
				//hashMailInfo.put("IN_OUT_GBN", strInOutGbn);
					
				int intMailSendResult = objUmsDelegate.insertSMTP_WEB_REC(hashMailInfo);
				//int intMailSendResult = 1;
				int intSmsSendResult = 0;
				if (StringUtil.isAssigned(strSmsUse) && StringUtil.isAssigned(strSendPhoneNo)) {
					// ���������� ��츸 SMS & email ����Ѵ�.
					// SMS �߼� Hashtable ����
					hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
					hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
					//hashSmsInfo.put("SEND_STATUS", strSendStatus);
					hashSmsInfo.put("SEND_STATUS", "1"); // ��ù߼� : 1, ��� : 9
					hashSmsInfo.put("MSG", strSmsMsg);
					hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
					hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
					hashSmsInfo.put("DEPT_GBN", strReqOrganID);
					hashSmsInfo.put("USER_ID", strUserID);
					hashSmsInfo.put("DEPT_NM", strReqOrganNm); // 2004-04-13 �߰� 1
					hashSmsInfo.put("USER_NM", strSndrName); // 2004-04-13 �߰� 2
					hashSmsInfo.put("USER_KIND", strUserKind); // 2015-10-21 �߰�
					//if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID); // 2004-04-13 ���� 1
					//hashSmsInfo.put("IN_OUT_GBN", strInOutGbn); // 2004-04-13 ���� 2
					
					intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);	
					//intSmsSendResult = 1;
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
				out.println("window.opener.location.href='"+strReturnURL+"'");
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
			var f = document.elcForm;
			f.action = "<%= EnvConstants.ELC_ACTION_URL %>";
			//f.target = "popwin2";
			//window.open("about:blank", "popwin2", 'width=1000,height=600, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
			f.submit();
			opener.window.location.href='<%= strReturnURL %>';
			//self.close();
		}
	</script>
	<meta http-equiv='refresh' content='1; url=javascript:autoSubmit()'>
	<!-- input type="button" name="" value="SUBMIT" onClick="javascript:autoSubmit()" -->
<% } %>

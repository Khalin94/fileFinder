<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commReqDoc.CommReqDocDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqDocSendForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String[] arrReqBoxIDs = request.getParameterValues("ReqBoxID");
	if(arrReqBoxIDs == null || arrReqBoxIDs.length < 1) {
		out.println("<script language=javascript>");
		out.println("alert('�䱸�� ID�� ���޵��� �ʾҽ��ϴ�. Ȯ�� �ٶ��ϴ�.');");
		out.println("history.go(-1);");
		out.println("</script>");
		return;
	}
	
	// ���õ� �䱸���� ���� ��ŭ �۾��� �����Ѵ�.
	RMemReqDocSendForm objForm = new RMemReqDocSendForm();
	MemReqDocSendDelegate objBean = new MemReqDocSendDelegate();
	MemRequestBoxDelegate objBean2  = new MemRequestBoxDelegate();
	CommReqDocDelegate objDocBean = new CommReqDocDelegate(); // �䱸�� ���� DELEGATE
	UmsInfoDelegate objUmsBean = new UmsInfoDelegate();
	ResultSetHelper objRS = null;
	
	// �Ķ���Ͱ� ���������� �Ѿ�°��� Ȯ���غ���
	boolean blnParamCheck = false;
	blnParamCheck = objForm.validateParams(request);
  	if(!blnParamCheck) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objForm.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} // end if 
	
	try {
	
		String strReturnURL = "";
		String strReqDocType = (String)objForm.getParamValue("ReqDocType"); // ���ڰ��縦 ���� �䱸�� ����
		String strReqTp = (String)objForm.getParamValue("ReqTp"); // �䱸�� ������ ���� �䱸�� �� ����		
		if(CodeConstants.REQ_DOC_FORM_001.equalsIgnoreCase(strReqTp)) strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/20_sendend/RSendBoxList.jsp";
		else strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxList.jsp";
		String strSmsUse =  (String)objForm.getParamValue("SmsUse"); // SMS ��� ����
		String strReqOrganID = (String)objForm.getParamValue("ReqOrganID"); // �䱸���ID		
		
		int intResultCount = 0;
		
		for(int i=0; i<arrReqBoxIDs.length; i++) {
			String strReqBoxID = arrReqBoxIDs[i];
			String strReqOrganNm = "";
			
			objRS = new ResultSetHelper(objBean.getRepUserList(strReqBoxID));

			if(objRS.getRecordSize() == 0){
				 objRS = new ResultSetHelper(objBean.getRepUserList2(strReqBoxID));
			}
			int intReqCnt = objBean2.getReqInfoCount(strReqBoxID);
			int Rscount = 0;
			// ��ϵ� ����ڰ� �ִٸ�... �׸��� 1�� �̻��� �䱸�� ����� �Ǿ��� �ִٸ�
			System.out.println("objRS.getRecordSize() : "+objRS.getRecordSize());
			if(objRS.getRecordSize() > 0 && intReqCnt > 0) {
				while(objRS.next()){
					String strSubmtOrganID = (String)objRS.getObject("ORGAN_ID");
					String strRcvrUserID = (String)objRS.getObject("USER_ID");
					String strRcvrName = (String)objRS.getObject("USER_NM");
					String strRcvrPhoneNo = (String)objRS.getObject("CPHONE");
					String strRcvrMail = (String)objRS.getObject("EMAIL");
                                        System.out.println("kangthis logs sms���� strSubmtOrganID => " + strSubmtOrganID);
					System.out.println("kangthis logs sms���� strRcvrUserID => " + strRcvrUserID);
					System.out.println("kangthis logs sms���� strRcvrName => " + strRcvrName);
					System.out.println("kangthis logs sms���� strRcvrPhoneNo => " + strRcvrPhoneNo);
					System.out.println("kangthis logs sms���� strRcvrMail => " + strRcvrMail);
					
					String strReqDocFilePath = null; // �䱸�� ���� ���
					
					String strSndrPhoneNo = null; // �߼��� �޴��� ��ȣ
					String strSndrPhoneNo1 = null; // �߼��� �޴��� ��ȣ
					String strSendStatus = null; // ���ۻ���
					String strSmsMsg = null; //�޽���
					String strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ; //�ý��۱���
					String strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ; //���񽺱���
					String strUserID = null; //�����ID
					String strElcEventCode = CodeConstants.ELC_EVENT_NONE;				
					String strSndrID = null; // �߽���ID
					String strSndrName = null; // �߽��ڸ�
					String strSndrMail = null; // �߽��ڸ����ּ�
					String strSubject = null; // ����
					String strContents  = null; // ����
					if(Rscount == 0){
						String strReqDocSeq = objBean.getSeqNextVal("TBDS_REQ_DOC_INFO");
						strReqDocFilePath  = objDocBean.CreateReqDoc(strReqBoxID, strReqTp, StringUtil.padl(strReqDocSeq, 10));				
						// ������ �Ѵٰ�� �ߴµ� ������ ������� ������ �ٽ� ���� �߻�
						if (!StringUtil.isAssigned(strReqDocFilePath)) {
							objMsgBean.setMsgType(MessageBean.TYPE_ERR);
							objMsgBean.setStrCode("�䱸�� ���� ���� ���� : ����� ���� ���");
							objMsgBean.setStrMsg("�䱸�� ���� ���� ���� : ����� ���� ���");
		%>
							<jsp:forward page="/common/message/ViewMsg.jsp"/>		
		<%
							return;
						}
						
						// ��� �۾��� ���� ����� ���� ��ü
						objForm.setParamValue("RcvrID", strRcvrUserID);
						objForm.setParamValue("ReqBoxID", strReqBoxID);
						objForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
						objForm.setParamValue("ReqDocID", strReqDocSeq);
						Hashtable hashResult = objBean.setSendReqDocProc(objForm);
					
					}
					
					// �߽��� ���� OBJECT
					Hashtable hashSndr = objBean.getRecordListFromUserInfo(strReqBoxID, CodeConstants.REQ_ORGAN_PERSON, strReqOrganID); 
					
					strReqOrganNm = (String)hashSndr.get("ORGAN_NM");
					
					// SMS �Է� ȣ�� �Լ��� ����� Hashtable
					Hashtable hashSmsInfo = new Hashtable();
					// Mail �Է� ȣ�� �Լ��� ����� Hashtable
					Hashtable hashMailInfo = new Hashtable();
					
					strSndrPhoneNo = StringUtil.getEmptyIfNull((String)hashSndr.get("CPHONE"));
					strSndrPhoneNo1 = StringUtil.getEmptyIfNull((String)hashSndr.get("CPHONE"));
					if (StringUtil.isAssigned(strRcvrPhoneNo)) strRcvrPhoneNo = StringUtil.ReplaceString(strRcvrPhoneNo, "-", ""); 	// ���� ��� �ڵ��� ��ȣ
					if (StringUtil.isAssigned(strSndrPhoneNo)) strSndrPhoneNo = StringUtil.ReplaceString(strSndrPhoneNo, "-", "");	// ������ ��� �ڵ��� ��ȣ
					strSendStatus = CodeConstants.ELC_SMS_SEND_REQ;
					strSmsMsg = objBean.getSmsMsg(strReqOrganNm);
					strUserID = (String)hashSndr.get("USER_ID");
					strSndrID = (String)hashSndr.get("USER_ID");
					strSndrName = (String)hashSndr.get("USER_NM");
					strSndrMail = StringUtil.getEmptyIfNull((String)hashSndr.get("EMAIL"), "none");
					strSubject = objBean.getMailSubject(strElcEventCode);
					strContents  = objBean.getMailContentURL(strRcvrName, strReqOrganNm+" "+(String)objUserInfo.getUserName(), strSndrPhoneNo1, strSndrMail);
					// E-MAIL �߼� Hashtable ����
					hashMailInfo.put("RID", strRcvrUserID);
					hashMailInfo.put("RNAME", strRcvrName);
					hashMailInfo.put("RMAIL", strRcvrMail);
					hashMailInfo.put("SID", strSndrID);
					hashMailInfo.put("SNAME", strSndrName);
					hashMailInfo.put("SMAIL", strSndrMail);
					hashMailInfo.put("SUBJECT", strSubject);
					hashMailInfo.put("CONTENTS", strContents); // ������ CONTENTS �������� URL LINK�� ��ȯ
					hashMailInfo.put("SYSTEM_GBN", strSystemGbn);
					hashMailInfo.put("SERVICE_GBN", strServiceGbn);
					hashMailInfo.put("STATUS", "0"); // ��ù߼� : 0, ��� : 9
					hashMailInfo.put("DEPT_GBN", strReqOrganID);
					hashMailInfo.put("DEPT_NM", strReqOrganNm); // �䱸�����
					
					// 2005-07-27 kogaeng EDIT
					// �׽�Ʈ�� ���ؼ� �ӽ÷� ���Ƶд�.
					int intMailSendResult = objUmsBean.insertSMTP_WEB_REC(hashMailInfo);	
					//int intMailSendResult = 1;

					int intSmsSendResult = 0;
					// SMS �߼� Hashtable ����
					hashSmsInfo.put("SEND_PHONE_NO", strRcvrPhoneNo);
					hashSmsInfo.put("RETURN_NO", strSndrPhoneNo);
					hashSmsInfo.put("SEND_STATUS", "1"); // ��ù߼� : 1, ��� : 9
					hashSmsInfo.put("MSG", strSmsMsg);
					hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
					hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
					hashSmsInfo.put("DEPT_GBN", strReqOrganID);
					hashSmsInfo.put("USER_ID", strUserID);
					hashSmsInfo.put("DEPT_NM", strReqOrganNm); // 2004-04-13 �߰� 1
					hashSmsInfo.put("USER_NM", strSndrName); // 2004-04-13 �߰� 2

					// 2005-07-27 kogaeng EDIT
					// �׽�Ʈ�� ���ؼ� �ӽ÷� ���Ƶд�.
					intSmsSendResult = objUmsBean.insertSMS(hashSmsInfo);	
					
					//intSmsSendResult = 1;

					if (intSmsSendResult < 1) System.out.println("[RMakeReqDocSendProc.jsp] SMS �߼� ��� ����� ���⼭ ������ �߻��߽��ϴ�. T_T");
					
					int intResultOfUpdateSendInfo = 0;
					if (intSmsSendResult > 0 && intMailSendResult > 0) {
						intResultOfUpdateSendInfo = objBean.setRecordToSendInfo(strReqBoxID, String.valueOf(intSmsSendResult), String.valueOf(intMailSendResult));
						if (intResultOfUpdateSendInfo > 0) {
							System.out.println("[RMakeReqDocSendProc.jsp] �߼����� ������Ʈ���� ����");
						}
					}
					Rscount++;
				}												
				intResultCount++;
			} else {
				System.out.println("ReqBoxID : " + strReqBoxID+",  ��ǥ ����ڰ� �������� �����Ƿ�, �۾��� �������� �ʽ��ϴ�.");
			}
			
		
		} // end for
		
		// 2005-07-27 kogaeng ADD
		// 2018-09-19 hgyoo
		// �䱸�� �߼� ó�� ����� �޼����� �˷��ش�.
		
		String strAlertMsg = "[�䱸�� �߼� �۾� ���]\\r\\n"
		+"- ��ü ���� : "+arrReqBoxIDs.length+" ��\\r\\n"
		+"- �߼� ���� : "+intResultCount+" ��\\r\\n"
		+"- ��ó�� ���� : "+(arrReqBoxIDs.length - intResultCount)+" ��\\r\\n\\r\\n"
		+"�߼۵��� ���� �䱸���� �ۼ��߿䱸�Կ��� Ȯ�� �ٶ��ϴ�.";
				
		out.println("<script language='javascript'>");
		//out.println("parent.notProcessing();");
		
		out.println("var elem = parent.document.getElementById('loading_layer');");
		out.println("elem.parentNode.removeChild(elem);");
		
		out.println("alert('"+strAlertMsg+"')");		
		out.println("parent.location.href='"+strReturnURL+"';");
		//out.println("self.close();");
		out.println("</script>");
		
		

		
%>



<%				
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

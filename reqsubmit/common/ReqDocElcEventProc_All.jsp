<%@ page language="java" contentType="text/xml; charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>

<%!
	public String getOffiDocID(String strXML) throws Exception {
		String strReturnOffiDocID = StringUtil.getCutString(strXML, "<SUID>", "</SUID>");
		int intLastP1 = strReturnOffiDocID.lastIndexOf('[');
		int intLastP2 = strReturnOffiDocID.indexOf(']');
		strReturnOffiDocID = strReturnOffiDocID.substring(intLastP1+1, intLastP2);
		return strReturnOffiDocID;
	}
%>

<%
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();
	
	StringBuffer strBufReturnXml = new StringBuffer();
	int intResult = 0;
		
	String strSystemID = request.getParameter("systemid");
	String strBusinessID = StringUtil.getEmptyIfNull(request.getParameter("businessid"));
	String strDocID = StringUtil.getEmptyIfNull(request.getParameter("docid"));
	String strLegacyIn = StringUtil.getEmptyIfNull(request.getParameter("legacyin"));
	String strEventCode = StringUtil.getEmptyIfNull(request.getParameter("event"));
	//String strOffiDocID = StringUtil.getCutString(strLegacyIn, "<SUID>", "</SUID>");
	String strOffiDocID = getOffiDocID(strLegacyIn);
	
	//if ("1".equalsIgnoreCase(strEvencCode)) {
	//	System.out.println("���-��������");
	//} else {
	//	System.out.println("����");
	//}

	String strReqBoxID = objRDSDelegate.getReqBoxIDFromOffiDocInfo(strOffiDocID);
	
	if (!StringUtil.isAssigned(strReqBoxID)) {
		strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>");
		strBufReturnXml.append("<REPLY>");
		strBufReturnXml.append("<REPLY_CODE>0</REPLY_CODE>");
		strBufReturnXml.append("<DESCRIPTION>FAIL</DESCRIPTION>");
		strBufReturnXml.append("</REPLY>");
	}
	
	// ���ڰ����� �̺�Ʈ �ڵ忡 ���� �۾��� �ٸ��� �����Ѵ�.
	if (CodeConstants.ELC_EVENT_0X01.equalsIgnoreCase(strEventCode)) {		 			// ELC_EVENT_0X01 : ���
		
		// �䱸�� ���� ������Ʈ
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
		
	} else if (CodeConstants.ELC_EVENT_02.equalsIgnoreCase(strEventCode)) {			// ELC_EVENT_02 : ���ȸ�� 
		
		// �䱸�� ���� ������Ʈ
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
	
	} else if (CodeConstants.ELC_EVENT_0X02.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X02 : ��Ⱥ���
		
		// �䱸�� ���� ������Ʈ
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
	
	} else if (CodeConstants.ELC_EVENT_0X08.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X08 : ����Ϸ�
		
		// 1. REQ BOX INFO UPDATE
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
		
		// 2. SMS & EMAIL SEND
		Hashtable hashUserInfo = (Hashtable)objRDSDelegate.getUserIDFromSendInfoByReqBoxID(strReqBoxID);
		
		String strRcvrID = (String)hashUserInfo.get("RCVR_ID");
		String strSndrID = (String)hashUserInfo.get("SNDR_ID");
		String strRcvrName = (String)hashUserInfo.get("RCVR_NM");
		String strSndrName = (String)hashUserInfo.get("SNDR_NM");
		String strRcvrMail = (String)hashUserInfo.get("RCVR_EMAIL");
		String strSndrMail= (String)hashUserInfo.get("SNDR_EMAIL");
		String strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ;
		String strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ;
		String strDeptGbn = StringUtil.getEmptyIfNull((String)hashUserInfo.get("SNDR_GOV_STD_CD"), CodeConstants.ELC_DEPT_CODE);
		String strReqOrganNm = (String)hashUserInfo.get("SNDR_ORGAN_NM");
		String strSendPhoneNo = (String)hashUserInfo.get("RCVR_CPHONE");
		String strReturnPhoneNo = (String)hashUserInfo.get("SNDR_CPHONE");
		String strSmsMsg = objRDSDelegate.getSmsMsg(strReqOrganNm);
		String strSubject = objRDSDelegate.getMailSubject(strEventCode);
		String strContents  = objRDSDelegate.getMailContentURL(strSndrName, "", strReturnPhoneNo, strSndrMail);

		Hashtable hashMailInfo = new Hashtable();
		Hashtable hashSmsInfo = new Hashtable();
		
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
		//hashMailInfo.put("STATUS", strSendStatus);
		hashMailInfo.put("STATUS", "0");
		hashMailInfo.put("DEPT_GBN", strDeptGbn);
		hashMailInfo.put("DEPT_NM", strReqOrganNm); // �䱸�����
		//hashMailInfo.put("USER_ID", strUserID);
		//if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
		//hashMailInfo.put("IN_OUT_GBN", strInOutGbn);
			
		int intMailSendResult = objUmsDelegate.insertSMTP_WEB_REC(hashMailInfo);	
		int intSmsSendResult = 0;
		// ���������� ��츸 SMS & email ����Ѵ�.
		// SMS �߼� Hashtable ����
		hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
		hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
		//hashSmsInfo.put("SEND_STATUS", strSendStatus);
		hashSmsInfo.put("SEND_STATUS", "1");
		hashSmsInfo.put("MSG", strSmsMsg);
		hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
		hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
		hashSmsInfo.put("DEPT_GBN", strDeptGbn);
		hashSmsInfo.put("USER_ID", strSndrID);
		hashSmsInfo.put("DEPT_NM", strReqOrganNm); // 2004-04-13 �߰� 1
		hashSmsInfo.put("USER_NM", strSndrName); // 2004-04-13 �߰� 2
		//if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID); // 2004-04-13 ���� 1
		//hashSmsInfo.put("IN_OUT_GBN", strInOutGbn); // 2004-04-13 ���� 2
			
		intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);	
		if (intSmsSendResult < 1) System.out.println("[RMakeReqDocSendProc.jsp] SMS �߼� ��� ����� ���⼭ ������ �߻��߽��ϴ�. T_T");
					
		if (intSmsSendResult > 0 && intMailSendResult > 0) {
			System.out.println("[RMakeReqDocSendProc.jsp] SMS �߼� ��� Sequence ID : " + intSmsSendResult);
			System.out.println("[RMakeReqDocSendProc.jsp] Mail �߼� ��� Sequence ID : " + intMailSendResult);
		} else {
			System.out.println("[RMakeReqDocSendProc.jsp] SMS & mail �߼� ����... ���� �м� ���");
		}

		// 3. SEND INFO UPDATE					
		int intResultOfUpdateSendInfo = 0;
		if (intSmsSendResult > 0 && intMailSendResult > 0) {
			intResultOfUpdateSendInfo = objRDSDelegate.setRecordToSendInfo(strReqBoxID, String.valueOf(intSmsSendResult), String.valueOf(intMailSendResult));
			if (intResultOfUpdateSendInfo > 0) {
				System.out.println("[RMakeReqDocSendProc.jsp] �߼����� ������Ʈ���� ����");
			}
		}
		
		intResult = objRDSDelegate.setRecordToOffiDocInfo(strOffiDocID, strDocID.substring(0, 20));
		if (intResult > 0) {
			System.out.println("�����ȣ ������Ʈ ����");
		} else {
			throw new AppException("���繮����ȣ ������Ʈ���� ���� �߻�");
		}
	
	} else if (CodeConstants.ELC_EVENT_0X16.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X16 : �ݷ�
	
		// 1. REQ BOX INFO UPDATE
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
			
	} else {																												// ELC_EVENT_9999: ��Ŵ��(�ۼ���)
		
		// 1. REQ BOX INFO UPDATE
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, CodeConstants.ELC_EVENT_9999);
	}
%>
<%
	if (intResult > 0) { 
		strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>");
		strBufReturnXml.append("<REPLY>\n");
		strBufReturnXml.append("<REPLY_CODE>1</REPLY_CODE>\n");
		strBufReturnXml.append("<DESCRIPTION>SUCCESS</DESCRIPTION>\n");
		strBufReturnXml.append("</REPLY>");
	} else {
		strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>");
		strBufReturnXml.append("<REPLY>\n");
		strBufReturnXml.append("<REPLY_CODE>0</REPLY_CODE>\n");
		strBufReturnXml.append("<DESCRIPTION>FAIL</DESCRIPTION>\n");
		strBufReturnXml.append("</REPLY>");
	}
	
	try {
		response.reset();
		out.println(strBufReturnXml.toString());
		System.out.println(strBufReturnXml.toString());
	} catch(Exception e) {}
	
%>
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
	//	System.out.println("상신-결재대기중");
	//} else {
	//	System.out.println("보류");
	//}

	String strReqBoxID = objRDSDelegate.getReqBoxIDFromOffiDocInfo(strOffiDocID);
	
	if (!StringUtil.isAssigned(strReqBoxID)) {
		strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>");
		strBufReturnXml.append("<REPLY>");
		strBufReturnXml.append("<REPLY_CODE>0</REPLY_CODE>");
		strBufReturnXml.append("<DESCRIPTION>FAIL</DESCRIPTION>");
		strBufReturnXml.append("</REPLY>");
	}
	
	// 전자결재쪽 이벤트 코드에 따라서 작업을 다르게 진행한다.
	if (CodeConstants.ELC_EVENT_0X01.equalsIgnoreCase(strEventCode)) {		 			// ELC_EVENT_0X01 : 상신
		
		// 요구함 정보 업데이트
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
		
	} else if (CodeConstants.ELC_EVENT_02.equalsIgnoreCase(strEventCode)) {			// ELC_EVENT_02 : 기안회수 
		
		// 요구함 정보 업데이트
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
	
	} else if (CodeConstants.ELC_EVENT_0X02.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X02 : 기안보류
		
		// 요구함 정보 업데이트
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
	
	} else if (CodeConstants.ELC_EVENT_0X08.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X08 : 결재완료
		
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
		
		// E-MAIL 발송 Hashtable 담자
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
		hashMailInfo.put("DEPT_NM", strReqOrganNm); // 요구기관명
		//hashMailInfo.put("USER_ID", strUserID);
		//if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
		//hashMailInfo.put("IN_OUT_GBN", strInOutGbn);
			
		int intMailSendResult = objUmsDelegate.insertSMTP_WEB_REC(hashMailInfo);	
		int intSmsSendResult = 0;
		// 서류제출의 경우만 SMS & email 등록한다.
		// SMS 발송 Hashtable 담자
		hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
		hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
		//hashSmsInfo.put("SEND_STATUS", strSendStatus);
		hashSmsInfo.put("SEND_STATUS", "1");
		hashSmsInfo.put("MSG", strSmsMsg);
		hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
		hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
		hashSmsInfo.put("DEPT_GBN", strDeptGbn);
		hashSmsInfo.put("USER_ID", strSndrID);
		hashSmsInfo.put("DEPT_NM", strReqOrganNm); // 2004-04-13 추가 1
		hashSmsInfo.put("USER_NM", strSndrName); // 2004-04-13 추가 2
		//if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID); // 2004-04-13 제외 1
		//hashSmsInfo.put("IN_OUT_GBN", strInOutGbn); // 2004-04-13 제외 2
			
		intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);	
		if (intSmsSendResult < 1) System.out.println("[RMakeReqDocSendProc.jsp] SMS 발송 결과 사실은 여기서 에러가 발생했습니다. T_T");
					
		if (intSmsSendResult > 0 && intMailSendResult > 0) {
			System.out.println("[RMakeReqDocSendProc.jsp] SMS 발송 결과 Sequence ID : " + intSmsSendResult);
			System.out.println("[RMakeReqDocSendProc.jsp] Mail 발송 결과 Sequence ID : " + intMailSendResult);
		} else {
			System.out.println("[RMakeReqDocSendProc.jsp] SMS & mail 발송 실패... 원인 분석 요망");
		}

		// 3. SEND INFO UPDATE					
		int intResultOfUpdateSendInfo = 0;
		if (intSmsSendResult > 0 && intMailSendResult > 0) {
			intResultOfUpdateSendInfo = objRDSDelegate.setRecordToSendInfo(strReqBoxID, String.valueOf(intSmsSendResult), String.valueOf(intMailSendResult));
			if (intResultOfUpdateSendInfo > 0) {
				System.out.println("[RMakeReqDocSendProc.jsp] 발송정보 업데이트까지 성공");
			}
		}
		
		intResult = objRDSDelegate.setRecordToOffiDocInfo(strOffiDocID, strDocID.substring(0, 20));
		if (intResult > 0) {
			System.out.println("결재번호 업데이트 성공");
		} else {
			throw new AppException("결재문서번호 업데이트에서 에러 발생");
		}
	
	} else if (CodeConstants.ELC_EVENT_0X16.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X16 : 반려
	
		// 1. REQ BOX INFO UPDATE
		intResult = objRDSDelegate.setRecordToReqBoxStt(strReqBoxID, strEventCode);
			
	} else {																												// ELC_EVENT_9999: 상신대기(작성중)
		
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
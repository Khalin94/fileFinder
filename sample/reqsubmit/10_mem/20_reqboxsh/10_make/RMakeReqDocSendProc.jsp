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
	CommReqDocDelegate objBindDelegate = new CommReqDocDelegate(); // 요구서 관련 DELEGATE
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	RMemReqDocSendForm objParamForm = new RMemReqDocSendForm();
	UmsDelegate objUmsDelegate = new UmsDelegate();
	
	// 모든 작업이 끝난 결과를 담은 객체
	Hashtable hashResult = null;
	
	// 파라미터가 정상적으로 넘어온건지 확인해보자
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
	
	String strReqBoxID = (String)objParamForm.getParamValue("ReqBoxID"); // 요구함 ID
	String strReqDocType = (String)objParamForm.getParamValue("ReqDocType"); // 요구서 유형 
	String strReqTp = (String)objParamForm.getParamValue("ReqTp"); // 요구자 or 제출자
	String strSmsUse =  (String)objParamForm.getParamValue("SmsUse"); // SMS 사용 여부
	String strReqDocFilePath = null; // 요구서 파일 경로
	String strLegacyout = null;
	String strAttach = null;
	String strElcUse = null;
	
	String strElcEventCode = null; // 전자결재 관련 이벤트 코드
	String strSendPhoneNo = null; //전송번호
	String strReturnPhoneNo = null; //회신번호
	String strSendStatus = null; // 전송상태
	String strSmsMsg = null; //메시지
	String strSystemGbn = null; //시스템구분
	String strServiceGbn = null; //서비스구분
	String strDeptGbn = null; //부서구분
	String strUserID = null; //사용자ID
	String strOffiDocID = null; //공문ID
	String strInOutGbn = null; //내외구분
	
	String strRcvrID = null; // 수신자ID
	String strRcvrName = null; // 수신자명
	String strRcvrMail = null; // 수신자메일주소
	String strSndrID = null; // 발신자ID
	String strSndrName = null; // 발신자명
	String strSndrMail = null; // 발신자메일주소
	String strSubject = null; // 제목
	String strContents  = null; // 내용
	
	/*
	 ********************** 처리해야 할 경우의 수를 조합해 보자 **********************
	 1. 서류제출+email
	 2. 서류제출+email+SMS
	 3. 서류제출+전자결재+email
	 4. 서류제출+전자결재+email+SMS
	
	 ********************** 처리해야 할 항목들을 열거해 보자 **********************
	 1. 요구서 파일 있는지 여부 확인 후 없음 생성 있음 경로 받아오기
	 2. 요구서 테이블에 등록 정보 저장
	 3. SMS테이블 등록 정보 저장
	 4. e-mail 발송 관련 테이블에 등록 정보 저장
	 5. 발신정보 테이블에 등록 정보 저장
	 6. 전자결재쪽에 넘길 요구서 파일을 Base64로 인코딩 한다.
	 7. 요구함 정보 및 요구 정보 테이블의 상태 정보를 '결재대기' 로 변경
	 8. 전자결재쪽에 필요한 파라미터를 정리한 다음에 해당 페이지를 호출
	 9. 전자 결재쪽 진행 후 작업 결과를 받아 요구함 정보 및 요구 정보의 상태를 해당 반환 값에 따라서 변경 
	    (에러 발생 시 
	     1. SMS테이블 및 e-mail 발송 관련 테이블, 그리고 발신 정보 테이블의 데이터 DELETE
	     2. 요구함 정보 및 요구 정보 테이블의 상태 정보를 해당하는 코드값으로 업데이트)
	*/
	
	try {
		// 어쩔수없이 무조건 요구서 ID Sequence를 만들어야한다
		String strReqDocSeq = objRDSDelegate.getSeqNextVal("TBDS_REQ_DOC_INFO");
		
		strReqDocFilePath  = objBindDelegate.CreateReqDoc(strReqBoxID, strReqTp, strReqDocSeq);
		//strReqDocFilePath = "D:\\temp\\2004\\0000000180\\0000000001.pdf";
		System.out.println("[RMakeReqDocSendProc.jsp] 요구서 임시 생성 파일 경로 : " + strReqDocFilePath);
		
		// 생성을 한다고는 했는데 실제로 결과값이 없으면 다시 에러 발생
		if (!StringUtil.isAssigned(strReqDocFilePath)) {
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  		objMsgBean.setStrCode("몰라몰라.. 요구서 파일 만드는데 자꾸 에러 나자나!!!!");
  			objMsgBean.setStrMsg("요구서 파일을 만들어야 하는데 자꾸 에러가 납니다.. T_T");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		} else { // 요구서 파일 생성에 성공했다면

			// 생성된 요구서 파일 경로는 Form에 담아야 한다.
			objParamForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
			// 요구서 ID도 미리 만들어서 FORM에 담아야 한다.
			objParamForm.setParamValue("ReqDocID", strReqDocSeq);
			
			// 성공한다면 아래의 Hashtable에 멋진 값들이 담겨질 것이다.
			System.out.println("[RMakeReqDocSendProc.jsp] setSendReqDocProc START!!!!!!!!!!!!!");
			hashResult = objRDSDelegate.setSendReqDocProc(objParamForm);
			System.out.println("[RMakeReqDocSendProc.jsp] setSendReqDocProc END!!!!!!!!!!!!!");
			
			// 발신자 정보 OBJECT
			Hashtable hashSndr = objRDSDelegate.getRecordListFromUserInfo(strReqBoxID, CodeConstants.REQ_ORGAN_PERSON);
			// 수신자 정보 OBJECT
			Hashtable hashRcvr = objRDSDelegate.getRecordListFromUserInfo(strReqBoxID, CodeConstants.SUBMIT_ORGAN_PERSON);
			// SMS 입력 호출 함수에 사용할 Hashtable
			Hashtable hashSmsInfo = new Hashtable();
			// Mail 입력 호출 함수에 사용할 Hashtable
			Hashtable hashMailInfo = new Hashtable();
			
			strElcUse = (String)hashResult.get("ElcUse");
			if (StringUtil.isAssigned((String)hashResult.get("OffiDocID"))) strOffiDocID = (String)hashResult.get("OffiDocID");
			else strOffiDocID = "";
			strLegacyout = StringUtil.getEmptyIfNull((String)hashResult.get("Legacyout"));
			strAttach = StringUtil.getEmptyIfNull((String)hashResult.get("Attach"));
			
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // 전자결재 : ELC_EVENT_0X08
				strElcEventCode = CodeConstants.ELC_EVENT_0X08;
			} else {
				strElcEventCode = CodeConstants.ELC_EVENT_NONE;
			}
			strSendPhoneNo = StringUtil.ReplaceString((String)hashSndr.get("CPHONE"), "-", "");
			strReturnPhoneNo = StringUtil.ReplaceString((String)hashRcvr.get("CPHONE"), "-", "");
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // 전자결재 : 9
				strSendStatus = CodeConstants.ELC_SMS_SEND_WAIT;
			} else { // 서류제출만 : 1
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
			
			// SMS 발송 Hashtable 저장 내용
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
			
			// SMS 발송 Hashtable 담자
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
			hashMailInfo.put("DEPT_GBN", strDeptGbn);
			hashMailInfo.put("USER_ID", strUserID);
			if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
			hashMailInfo.put("IN_OUT_GBN", strInOutGbn);
			
			int intMailSendResult = objUmsDelegate.insertSMTP_REC(hashMailInfo);	
			int intSmsSendResult = 0;
			if (StringUtil.isAssigned(strSmsUse)) {
				intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);	
				if (intSmsSendResult < 1) System.out.println("[RMakeReqDocSendProc.jsp] SMS 발송 결과 사실은 여기서 에러가 발생했습니다. T_T");
			} else {
				intSmsSendResult = 1;
			}
			
			if (intSmsSendResult > 0 && intMailSendResult > 0) {
				System.out.println("[RMakeReqDocSendProc.jsp] SMS 발송 결과 Sequence ID : " + intSmsSendResult);
				System.out.println("[RMakeReqDocSendProc.jsp] Mail 발송 결과 Sequence ID : " + intMailSendResult);
			} else {
				System.out.println("[RMakeReqDocSendProc.jsp] SMS & mail 발송 실패... 원인 분석 요망");
			}
			
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // 전재결재 연동
				System.out.println("[RMakeReqDocSendProc.jsp] systemID : "+strOffiDocID);
				System.out.println("[RMakeReqDocSendProc.jsp] businessID : "+strOffiDocID);
				System.out.println("[RMakeReqDocSendProc.jsp] cssvertion : 2.0");
				System.out.println("[RMakeReqDocSendProc.jsp] formversion : 1.0");
				System.out.println("[RMakeReqDocSendProc.jsp] title : 전자결재");
				System.out.println("[RMakeReqDocSendProc.jsp] method : file");
				System.out.println("[RMakeReqDocSendProc.jsp] 요구함 ID : "+strReqBoxID);
				System.out.println("[RMakeReqDocSendProc.jsp] 전자결재여부 : "+strElcUse);
				System.out.println("[RMakeReqDocSendProc.jsp] 공문 ID : "+strOffiDocID);
				//System.out.println("[RMakeReqDocSendProc.jsp] 전달할 XML 문자열(Legacyout) : "+strLegacyout);
				//System.out.println("[RMakeReqDocSendProc.jsp] 전달할 XML 문자열 2(Attach) : "+strAttach);
				
				out.println("<FORM method='post' action='http://docs.assembly.go.kr/acubecn/legacy/ACN_LegacyBridge.jsp' name='elcForm'>");
				out.println("<input type='hidden' name='systemid' value="+CodeConstants.ELC_SYSTEM_ID+"><BR>");
				out.println("<input type='hidden' name='businessid' value="+strReqDocType+"><BR>");
				out.println("<input type='hidden' name='cssversion' value='2.0'><BR>");
				out.println("<input type='hidden' name='formversion' value='1.0'><BR>");
				out.println("<input type='hidden' name='title' value='전자결재'><BR>");
				out.println("<input type='hidden' name='method' value='file'><BR>");
				//out.println("<input type='hidden' name='legacyout' value="+strLegacyout+"><BR>");
				//out.println("<input type='hidden' name='attaches' value="+strAttach+"><BR>");
				out.println("<textarea cols='50' rows='5' name='legacyout' style='border:1px solid #ffffff; color:#ffffff;'>"+strLegacyout+"</textarea>");
				out.println("<textarea cols='50' rows='5' name='attaches' style='border:1px solid #ffffff; color:#ffffff;'>"+strAttach+"</textarea>");
				out.println("<input type='hidden' name='deptcode' value='"+strDeptGbn+"'><BR>");
				out.println("</FORM>");
			
			} else { // 서류제출만 처리
				int intResultOfUpdateSendInfo = 0;
				if (intSmsSendResult > 0 && intMailSendResult > 0) {
					intResultOfUpdateSendInfo = objRDSDelegate.setRecordToSendInfo(strReqBoxID, String.valueOf(intSmsSendResult), String.valueOf(intMailSendResult));
					if (intResultOfUpdateSendInfo > 0) {
						System.out.println("[RMakeReqDocSendProc.jsp] 발송정보 업데이트까지 성공");
					}
				}
				out.println("<script language='javascript'>");
				out.println("alert('정상적으로 처리되었습니다.');");
				out.println("self.close();");
				out.println("window.opener.location.href='RMakeReqBoxList.jsp'");
				out.println("</script>");
			} // end if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // 전재결재 연동
			
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

<% if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // 전재결재 연동 %>
	<script language="javascript">
		function autoSubmit() {
			document.elcForm.submit();
		}
	</script>
	<meta http-equiv='refresh' content='1; url=javascript:autoSubmit()'>
	<!-- input type="button" name="" value="SUBMIT" onClick="javascript:autoSubmit()" -->
<% } %>
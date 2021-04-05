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
	CommReqDocDelegate objBindDelegate = new CommReqDocDelegate(); // 요구서 관련 DELEGATE
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	RMemReqDocSendForm objParamForm = new RMemReqDocSendForm();
	UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();
	
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
	String strReqDocType = (String)objParamForm.getParamValue("ReqDocType"); // 전자결재를 위한 요구서 유형
	String strReqTp = (String)objParamForm.getParamValue("ReqTp"); // 요구서 생성을 위한 요구서 폼 유형
	String strReturnURL = (String)objParamForm.getParamValue("ReturnURL");
	
	String strElcUse =  (String)objParamForm.getParamValue("ElcUse"); // 전자 결재 사용 여부
	String strSmsUse =  (String)objParamForm.getParamValue("SmsUse"); // SMS 사용 여부
	String strSubmtOrganID = (String)objParamForm.getParamValue("SubmtOrgID"); // 제출기관 ID

	String strReqOrganID = (String)objParamForm.getParamValue("ReqOrganID"); // 요구기관ID
	String strReqOrganNm = (String)objParamForm.getParamValue("ReqOrganNm"); // 요구기관명

	// 2004-09-18
	String strReqOrgGbnCode = objUserInfo.getOrganGBNCode();
	
	// 2004-07-28
	String strSelectedRcvrID = (String)objParamForm.getParamValue("RcvrID"); // 화면에서 선택된 수신자 ID
	String[] arrRcvrID = StringUtil.split("^", strSelectedRcvrID);
	objParamForm.setParamValue("RcvrID", arrRcvrID[1]);
	String strRealSubmtOrganID = (String)arrRcvrID[0];
	String strReqDocFilePath = null; // 요구서 파일 경로
	String strLegacyout = null;
	String strAttach = null;
	String strSubmtGccCode = null;
	String strSubmtOrganNm = null;
	
	String strElcEventCode = null; // 전자결재 관련 이벤트 코드
	String strSendPhoneNo = null; //전송번호
	String strReturnPhoneNo = null; //회신번호
	String strSendPhoneNo1 = null; //전송번호
	String strReturnPhoneNo1 = null; //회신번호
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
	String strUserKind  = null; // 직원구분
		
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
		
		strReqDocFilePath  = objBindDelegate.CreateReqDoc(strReqBoxID, strReqTp, StringUtil.padl(strReqDocSeq, 10));
		//strReqDocFilePath = "sfd";
	
		// 생성을 한다고는 했는데 실제로 결과값이 없으면 다시 에러 발생
		if (!StringUtil.isAssigned(strReqDocFilePath)) {
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  		objMsgBean.setStrCode("요구서 파일 생성 에러 : 담당자 문의 요망");
  			objMsgBean.setStrMsg("요구서 파일 생성 에러 : 담당자 문의 요망");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		} else { // 요구서 파일 생성에 성공했다면
			// 생성된 요구서 파일 경로는 Form에 담아야 한다.
			// 생성된 요구서는 /2004/~/*.pdf 형태로 반환한다. 그대로 FORM에 SET 할 것!!!
			// objParamForm.setParamValue("ReqDocFilePath", EnvConstants.UNIX_SAVE_PATH+strReqDocFilePath);
			objParamForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
			// 요구서 ID도 미리 만들어서 FORM에 담아야 한다.
			objParamForm.setParamValue("ReqDocID", strReqDocSeq);
			
			// 성공한다면 아래의 Hashtable에 멋진 값들이 담겨질 것이다.
			hashResult = objRDSDelegate.setSendReqDocProc(objParamForm);
			
			// 발신자 정보 OBJECT
			Hashtable hashSndr = objRDSDelegate.getRecordListFromUserInfo(strReqBoxID, CodeConstants.REQ_ORGAN_PERSON, strReqOrganID); 
			// 수신자 정보 OBJECT
			Hashtable hashRcvr = objRDSDelegate.getRecordListFromUserInfo(strReqBoxID, CodeConstants.SUBMIT_ORGAN_PERSON, strRealSubmtOrganID);
			
			/*
			out.println("죄송합니다. 테스트 중입니다.<BR>잠시 후에 다시 이용해 주시기 바랍니다.<BR>");
			out.println("요구함 ID : " +strReqBoxID+"<BR>");
			out.println("요구기관ID : " +strReqOrganID+"<BR>");
			out.println("제출기관ID : " + arrRcvrID[0]+"<BR>");
			out.println("요구기관 요구자 ID : " +objUserInfo.getUserID()+"<BR>");
			out.println("제출기관 담당자 ID : " + arrRcvrID[1]+"<BR>");
			out.println("수신자 ID : "+(String)hashRcvr.get("EMAIL")+"<BR>");
			out.println("발신자 ID : "+(String)hashSndr.get("USER_ID")+"<BR>");
			out.println("수신자 이름 : "+(String)hashRcvr.get("EMAIL")+"<BR>");
			out.println("발신자 이름 : "+(String)hashSndr.get("USER_NM")+"<BR>");
			out.println("수신자 메일 : "+(String)hashRcvr.get("EMAIL")+"<BR>");
			out.println("발신자 메일 : "+(String)hashSndr.get("EMAIL")+"<BR>");
			out.println("수신자 핸드폰 번호 : "+(String)hashRcvr.get("CPHONE")+"<BR>");
			out.println("발신자 핸드폰 번호 : "+(String)hashSndr.get("CPHONE")+"<BR>");
			if (1==1) return;
			*/
			// SMS 입력 호출 함수에 사용할 Hashtable
			Hashtable hashSmsInfo = new Hashtable();
			// Mail 입력 호출 함수에 사용할 Hashtable
			Hashtable hashMailInfo = new Hashtable();
						
			// 2004-08-02 왜 이렇게 했던가???
			// strElcUse = (String)hashResult.get("ElcUse");

			if (StringUtil.isAssigned((String)hashResult.get("OffiDocID"))) strOffiDocID = (String)hashResult.get("OffiDocID");
			else strOffiDocID = "";
			strLegacyout = StringUtil.getEmptyIfNull((String)hashResult.get("Legacyout"));
			strAttach = StringUtil.getEmptyIfNull((String)hashResult.get("Attach"));
			strAttach = StringUtil.ReplaceString(strAttach, "KB", "");
			strSubmtGccCode = StringUtil.getEmptyIfNull((String)hashResult.get("SubmtGccCode"));
			strSubmtOrganNm = StringUtil.getEmptyIfNull((String)hashResult.get("SubmtOrganNm"));
			
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // 전자결재 : ELC_EVENT_0X08
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
				strSendPhoneNo = StringUtil.ReplaceString((String)hashRcvr.get("CPHONE"), "-", ""); 	// 받을 사람 핸드폰 번호
			}
			if (StringUtil.isAssigned(strReturnPhoneNo)) {
				strReturnPhoneNo = StringUtil.ReplaceString((String)hashSndr.get("CPHONE"), "-", "");	// 보내는 사람 핸드폰 번호
			}
			
			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // 전자결재 : 9
				strSendStatus = CodeConstants.ELC_SMS_SEND_WAIT;
			} else { // 서류제출만 : 1
				strSendStatus = CodeConstants.ELC_SMS_SEND_REQ;
			}
			
			// 2004-06-04 원래 이벤트 코드가 인자값으로 들어갔으나, 요구기관명을 넣기로 한다.
			strSmsMsg = objRDSDelegate.getSmsMsg(strReqOrganNm);
			
			strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ;
			strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ;

			// 2004-09-18 
			// 전자문서시스템의 조직도 부서 코드가 위원회 발송의 경우
			//  970002의 경우 C70002와 같이 첫자리를 'C'로 치환해서 전송해야 함
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

			if (CodeConstants.SND_MTD_ELEC.equalsIgnoreCase(strElcUse)) { // 전재결재 연동
				out.println("<FORM method='post' action='"+EnvConstants.ELC_ACTION_URL+"' name='elcForm'>");
				out.println("<input type='hidden' name='systemid' value="+CodeConstants.ELC_SYSTEM_ID+"><BR>");
				out.println("<input type='hidden' name='businessid' value="+strReqDocType+"><BR>");
				out.println("<input type='hidden' name='cssversion' value='2.0'><BR>");
				out.println("<input type='hidden' name='formversion' value='1.0'><BR>");
				out.println("<input type='hidden' name='title' value='"+strSubmtOrganNm+" 요구서 발송'><BR>");
				out.println("<input type='hidden' name='method' value='file'><BR>");
				out.println("<DIV id='textareaDIV' style='display:none;'>");
				out.println("<textarea cols='50' rows='5' name='legacyout' style='border:1px solid #ffffff; color:#ffffff;'>"+strLegacyout+"</textarea>");
				out.println("<textarea cols='50' rows='5' name='attaches' style='border:1px solid #ffffff; color:#ffffff;'>"+strAttach+"</textarea>");
				out.println("</DIV>");
				out.println("<input type='hidden' name='deptcode' value='"+strDeptGbn+"'><BR>");
				//out.println("<input type='hidden' name='recipients' value='"+strSubmtGccCode+"'><BR>"); // 수신처코드(제출기관 GCC Code)
				//out.println("<input type='hidden' name='recipnames' value='"+strSubmtOrganNm+"'><BR>"); // 수신처명(제출기관명)
				out.println("<input type='hidden' name='bounds' value='O'><BR>"); // I : 내부, O: 외부
				out.println("</FORM>");
			
			} else { // 서류제출만 처리
			
				// E-MAIL 발송 Hashtable 담자
				hashMailInfo.put("RID", strRcvrID);
				hashMailInfo.put("RNAME", strRcvrName);
				hashMailInfo.put("RMAIL", strRcvrMail);
				hashMailInfo.put("SID", strSndrID);
				hashMailInfo.put("SNAME", strSndrName);
				hashMailInfo.put("SMAIL", strSndrMail);
				hashMailInfo.put("SUBJECT", strSubject);
				hashMailInfo.put("CONTENTS", strContents); // 기존의 CONTENTS 생성에서 URL LINK로 전환
				hashMailInfo.put("SYSTEM_GBN", strSystemGbn);
				hashMailInfo.put("SERVICE_GBN", strServiceGbn);
				//hashMailInfo.put("STATUS", strSendStatus);
				hashMailInfo.put("STATUS", "0"); // 즉시발송 : 0, 대기 : 9
				hashMailInfo.put("DEPT_GBN", strReqOrganID);
				hashMailInfo.put("DEPT_NM", strReqOrganNm); // 요구기관명
				//hashMailInfo.put("USER_ID", strUserID);
				//if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
				//hashMailInfo.put("IN_OUT_GBN", strInOutGbn);
					
				int intMailSendResult = objUmsDelegate.insertSMTP_WEB_REC(hashMailInfo);
				//int intMailSendResult = 1;
				int intSmsSendResult = 0;
				if (StringUtil.isAssigned(strSmsUse) && StringUtil.isAssigned(strSendPhoneNo)) {
					// 서류제출의 경우만 SMS & email 등록한다.
					// SMS 발송 Hashtable 담자
					hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
					hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
					//hashSmsInfo.put("SEND_STATUS", strSendStatus);
					hashSmsInfo.put("SEND_STATUS", "1"); // 즉시발송 : 1, 대기 : 9
					hashSmsInfo.put("MSG", strSmsMsg);
					hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
					hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
					hashSmsInfo.put("DEPT_GBN", strReqOrganID);
					hashSmsInfo.put("USER_ID", strUserID);
					hashSmsInfo.put("DEPT_NM", strReqOrganNm); // 2004-04-13 추가 1
					hashSmsInfo.put("USER_NM", strSndrName); // 2004-04-13 추가 2
					hashSmsInfo.put("USER_KIND", strUserKind); // 2015-10-21 추가
					//if (StringUtil.isAssigned(strOffiDocID)) hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID); // 2004-04-13 제외 1
					//hashSmsInfo.put("IN_OUT_GBN", strInOutGbn); // 2004-04-13 제외 2
					
					intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);	
					//intSmsSendResult = 1;
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
				out.println("window.opener.location.href='"+strReturnURL+"'");
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

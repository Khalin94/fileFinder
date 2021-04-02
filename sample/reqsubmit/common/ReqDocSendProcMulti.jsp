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
		out.println("alert('요구함 ID가 전달되지 않았습니다. 확인 바랍니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
		return;
	}
	
	// 선택된 요구함의 개수 만큼 작업을 진행한다.
	RMemReqDocSendForm objForm = new RMemReqDocSendForm();
	MemReqDocSendDelegate objBean = new MemReqDocSendDelegate();
	MemRequestBoxDelegate objBean2  = new MemRequestBoxDelegate();
	CommReqDocDelegate objDocBean = new CommReqDocDelegate(); // 요구서 관련 DELEGATE
	UmsInfoDelegate objUmsBean = new UmsInfoDelegate();
	ResultSetHelper objRS = null;
	
	// 파라미터가 정상적으로 넘어온건지 확인해보자
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
		String strReqDocType = (String)objForm.getParamValue("ReqDocType"); // 전자결재를 위한 요구서 유형
		String strReqTp = (String)objForm.getParamValue("ReqTp"); // 요구서 생성을 위한 요구서 폼 유형		
		if(CodeConstants.REQ_DOC_FORM_001.equalsIgnoreCase(strReqTp)) strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/20_sendend/RSendBoxList.jsp";
		else strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxList.jsp";
		String strSmsUse =  (String)objForm.getParamValue("SmsUse"); // SMS 사용 여부
		String strReqOrganID = (String)objForm.getParamValue("ReqOrganID"); // 요구기관ID		
		
		int intResultCount = 0;
		
		for(int i=0; i<arrReqBoxIDs.length; i++) {
			String strReqBoxID = arrReqBoxIDs[i];
			String strReqOrganNm = "";
			ArrayList objListdata = (ArrayList)objBean.getRepUserList(strReqBoxID);
			objRS = new ResultSetHelper(objListdata);

			if(objRS.getRecordSize() == 0){
				 objRS = new ResultSetHelper(objBean.getRepUserList2(strReqBoxID));
			}
			int intReqCnt = objBean2.getReqInfoCount(strReqBoxID);
			
			// 등록된 사용자가 있다면... 그리고 1개 이상의 요구가 등록이 되어져 있다면
			System.out.println("objListdata.size() :"+objListdata.size());
			if(objListdata.size() > 0 && intReqCnt > 0) {
				while(objRS.next()){
					String strSubmtOrganID = (String)objRS.getObject("ORGAN_ID");
					String strRcvrUserID = (String)objRS.getObject("USER_ID");
					String strRcvrName = (String)objRS.getObject("USER_NM");
					String strRcvrPhoneNo = (String)objRS.getObject("CPHONE");
					String strRcvrMail = (String)objRS.getObject("EMAIL");
					
					String strReqDocFilePath = null; // 요구서 파일 경로
					
					String strSndrPhoneNo = null; // 발송자 휴대폰 번호
					String strSndrPhoneNo1 = null; // 발송자 휴대폰 번호
					String strSendStatus = null; // 전송상태
					String strSmsMsg = null; //메시지
					String strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ; //시스템구분
					String strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ; //서비스구분
					String strUserID = null; //사용자ID
					String strElcEventCode = CodeConstants.ELC_EVENT_NONE;				
					String strSndrID = null; // 발신자ID
					String strSndrName = null; // 발신자명
					String strSndrMail = null; // 발신자메일주소
					String strSubject = null; // 제목
					String strContents  = null; // 내용
									
					
					// 발신자 정보 OBJECT
					Hashtable hashSndr = objBean.getRecordListFromUserInfo(strReqBoxID, CodeConstants.REQ_ORGAN_PERSON, strReqOrganID); 
					
					strReqOrganNm = (String)hashSndr.get("ORGAN_NM");
					
					// SMS 입력 호출 함수에 사용할 Hashtable
					Hashtable hashSmsInfo = new Hashtable();
					// Mail 입력 호출 함수에 사용할 Hashtable
					Hashtable hashMailInfo = new Hashtable();
					
					strSndrPhoneNo = StringUtil.getEmptyIfNull((String)hashSndr.get("CPHONE"));
					strSndrPhoneNo1 = StringUtil.getEmptyIfNull((String)hashSndr.get("CPHONE"));
					if (StringUtil.isAssigned(strRcvrPhoneNo)) strRcvrPhoneNo = StringUtil.ReplaceString(strRcvrPhoneNo, "-", ""); 	// 받을 사람 핸드폰 번호
					if (StringUtil.isAssigned(strSndrPhoneNo)) strSndrPhoneNo = StringUtil.ReplaceString(strSndrPhoneNo, "-", "");	// 보내는 사람 핸드폰 번호
					strSendStatus = CodeConstants.ELC_SMS_SEND_REQ;
					strSmsMsg = objBean.getSmsMsg(strReqOrganNm);
					strUserID = (String)hashSndr.get("USER_ID");
					strSndrID = (String)hashSndr.get("USER_ID");
					strSndrName = (String)hashSndr.get("USER_NM");
					strSndrMail = StringUtil.getEmptyIfNull((String)hashSndr.get("EMAIL"), "none");
					strSubject = objBean.getMailSubject(strElcEventCode);
					strContents  = objBean.getMailContentURL(strRcvrName, strReqOrganNm+" "+(String)objUserInfo.getUserName(), strSndrPhoneNo1, strSndrMail);
					// E-MAIL 발송 Hashtable 담자
					hashMailInfo.put("RID", strRcvrUserID);
					hashMailInfo.put("RNAME", strRcvrName);
					hashMailInfo.put("RMAIL", strRcvrMail);
					hashMailInfo.put("SID", strSndrID);
					hashMailInfo.put("SNAME", strSndrName);
					hashMailInfo.put("SMAIL", strSndrMail);
					hashMailInfo.put("SUBJECT", strSubject);
					hashMailInfo.put("CONTENTS", strContents); // 기존의 CONTENTS 생성에서 URL LINK로 전환
					hashMailInfo.put("SYSTEM_GBN", strSystemGbn);
					hashMailInfo.put("SERVICE_GBN", strServiceGbn);
					hashMailInfo.put("STATUS", "0"); // 즉시발송 : 0, 대기 : 9
					hashMailInfo.put("DEPT_GBN", strReqOrganID);
					hashMailInfo.put("DEPT_NM", strReqOrganNm); // 요구기관명
					
					// 2005-07-27 kogaeng EDIT
					// 테스트를 위해서 임시로 막아둔다.
					int intMailSendResult = objUmsBean.insertSMTP_WEB_REC(hashMailInfo);	
					//int intMailSendResult = 1;

					int intSmsSendResult = 0;
					// SMS 발송 Hashtable 담자
					hashSmsInfo.put("SEND_PHONE_NO", strRcvrPhoneNo);
					hashSmsInfo.put("RETURN_NO", strSndrPhoneNo);
					hashSmsInfo.put("SEND_STATUS", "1"); // 즉시발송 : 1, 대기 : 9
					hashSmsInfo.put("MSG", strSmsMsg);
					hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
					hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
					hashSmsInfo.put("DEPT_GBN", strReqOrganID);
					hashSmsInfo.put("USER_ID", strUserID);
					hashSmsInfo.put("DEPT_NM", strReqOrganNm); // 2004-04-13 추가 1
					hashSmsInfo.put("USER_NM", strSndrName); // 2004-04-13 추가 2

					// 2005-07-27 kogaeng EDIT
					// 테스트를 위해서 임시로 막아둔다.
					intSmsSendResult = objUmsBean.insertSMS(hashSmsInfo);	
					
					//intSmsSendResult = 1;
					if (intSmsSendResult < 1) System.out.println("[RMakeReqDocSendProc.jsp] SMS 발송 결과 사실은 여기서 에러가 발생했습니다. T_T");
					
					int intResultOfUpdateSendInfo = 0;
					if (intSmsSendResult > 0 && intMailSendResult > 0) {
						intResultOfUpdateSendInfo = objBean.setRecordToSendInfo(strReqBoxID, String.valueOf(intSmsSendResult), String.valueOf(intMailSendResult));
						if (intResultOfUpdateSendInfo > 0) {
							System.out.println("[RMakeReqDocSendProc.jsp] 발송정보 업데이트까지 성공");
						}
					}
				}												
			} else {
				System.out.println("ReqBoxID : " + strReqBoxID+",  대표 담당자가 존재하지 않으므로, 작업을 진행하지 않습니다.");
			}

			intResultCount++;
			
			String strReqDocSeq = objBean.getSeqNextVal("TBDS_REQ_DOC_INFO");
			strReqDocFilePath  = objDocBean.CreateReqDoc(strReqBoxID, strReqTp, StringUtil.padl(strReqDocSeq, 10));				
			// 생성을 한다고는 했는데 실제로 결과값이 없으면 다시 에러 발생
			if (!StringUtil.isAssigned(strReqDocFilePath)) {
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode("요구서 파일 생성 에러 : 담당자 문의 요망");
				objMsgBean.setStrMsg("요구서 파일 생성 에러 : 담당자 문의 요망");
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>		
<%
				return;
			}
			
			// 모든 작업이 끝난 결과를 담은 객체
			objForm.setParamValue("RcvrID", strRcvrUserID);
			objForm.setParamValue("ReqBoxID", strReqBoxID);
			objForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
			objForm.setParamValue("ReqDocID", strReqDocSeq);
			Hashtable hashResult = objBean.setSendReqDocProc(objForm);
		
		} // end for
		
		// 2005-07-27 kogaeng ADD
		// 요구서 발송 처리 결과를 메세지로 알려준다.
		/*
		String strAlertMsg = "[요구서 발송 작업 결과]\r\n"
		+"- 전체 개수 : "+arrReqBoxIDs.length+" 개\r\n"
		+"- 발송 개수 : "+intResultCount+" 개\r\n"
		+"- 미처리 개수 : "+(arrReqBoxIDs.length - intResultCount)+" 개\r\n\r\n"
		+"발송되지 못한 요구함은 작성중요구함에서 확인 바랍니다.";
				
		out.println("<script language='javascript'>");
		out.println("alert('[요구서 발송 작업 결과]\r\n- 전체 개수 : "+arrReqBoxIDs.length+" 개\r\n- 발송 개수 : "+intResultCount+" 개\r\n- 미처리 개수 : "+(arrReqBoxIDs.length - intResultCount)+" 개\r\n\r\n발송되지 못한 요구함은 작성중요구함에서 확인 바랍니다.');");
		out.println("opener.window.location.href='"+strReturnURL+"';");
		out.println("self.close();");
		out.println("</script>");
		*/
%>

<SCRIPT LANGUAGE=JAVASCRIPT> 
    var oLastBtn=0; 
    bIsMenu = false; 

    //No RIGHT CLICK************************ 
    // **************************** 
    if (window.Event) document.captureEvents(Event.MOUSEUP); 
    function nocontextmenu() { 
        event.cancelBubble = true 
        event.returnValue = false; 
        return false; 
    } 

    function norightclick(e) { 
        if (window.Event) { 
            if (e.which !=1) return false; 
        } else { 
            if (event.button !=1) { 
                event.cancelBubble = true 
                event.returnValue = false; 
                return false; 
            } 
        } 
    } 

    document.oncontextmenu = nocontextmenu; 
    document.onmousedown = norightclick; 

    // Block backspace onKeyDown************ 
    function onKeyDown() { 
        if ( (event.altKey) || ((event.keyCode == 8) && 
            (event.srcElement.type != "text" && 
            event.srcElement.type != "textarea" && 
            event.srcElement.type != "password")) || 
            ((event.ctrlKey) && ((event.keyCode == 78) || (event.keyCode == 82)) ) || 
            (event.keyCode == 116) ) { 
            event.keyCode = 0; 
            event.returnValue = false; 
        } 
    } 
</SCRIPT>

<script language="javascript">
	function doEndJob() {
		opener.window.location.href='<%= strReturnURL %>';
		self.close();
	}
</script>

<style>
	body, table, tr, td {	 font-size:11px; font-family:verdana,돋움; }
	.title { font-size:11px; font-family:verdana,돋움; color:darkblue; font-weight:bold; }
</style>
<body leftmargin="0" topmargin="0" onKeyDown="onKeyDown();">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr><td height="5" class="td_reqsubmit"></td></tr>
		<tr>
			<td width="280" align="center" height="30"><img src="/image/title/title_sendReqDocResult.jpg" border="0"></td>
		</tr>
		<tr>
			<td height="1" bgcolor="#c0c0c0"></td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td height="23" style="padding-left:10px">
			<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" border="0"> 전체 작업 개수 : <%= arrReqBoxIDs.length %> 개
		</td></tr>
		<tr><td height="23" style="padding-left:10px">
			<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" border="0"> 발송된 개수 : <%= intResultCount %> 개
		</td></tr>
		<tr><td height="23" style="padding-left:10px">
			<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" border="0"> 미처리 개수 : <%= (arrReqBoxIDs.length - intResultCount) %> 개
		</td></tr>
		<tr><td height="40" style="padding-left:10px">
			<img src="/image/common/icon_exclam_mark.gif" border="0"> 발송되지 못한 요구함은<BR>&nbsp;&nbsp;&nbsp;<B><%= ("001".equals(strReqTp))?"작성중":"접수완료" %></B> 요구함에서 확인 바랍니다.
		</td></tr>
		<tr><td height="40" align="center"><img src="/image/button/bt_ok.gif" border="0" style="cursor:hand" onClick="javascript:doEndJob()"></td></tr>
	</table>
</body>

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

<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemAnsDocSendForm" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemAnsDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commAnsDoc.CommAnsDocDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.OrganInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	CommAnsDocDelegate objBindDelegate = new CommAnsDocDelegate(); // 답변서 파일 관련 DELEGATE
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	MemAnsDocSendDelegate objADSDelegate = new MemAnsDocSendDelegate();
	OrganInfoDelegate objOrganDelegate = new OrganInfoDelegate();

	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
	RequestInfoDelegate objReqInfoDelegate = new RequestInfoDelegate();
	ResultSetHelper objRs = null;


	SMemAnsDocSendForm objParamForm = new SMemAnsDocSendForm();
	SMemAnsInfoWriteForm objParamForm2 = new SMemAnsInfoWriteForm();
	UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();
	
	// 왜 너만 홀로 이렇게 남아야 하는지... CVS한테 물어봐바....		 ReturnURLFLAG
	System.out.println("1111111111111111111111111111111111111");
	// 파라미터가 정상적으로 넘어온건지 확인해보자
	boolean blnParamCheck = false;
	boolean blnParamCheck2 = false;
	blnParamCheck = objParamForm.validateParams(request);
	blnParamCheck2 = objParamForm2.validateParams(request);

  	if(!blnParamCheck || !blnParamCheck2) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParamForm.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} // end if 
	
	String strReqBoxID = (String)objParamForm.getParamValue("ReqBoxID"); // 요구함 ID
	String strReqID = null;
	String strReqTp = (String)objParamForm.getParamValue("ReqTp"); // 요구자 유형
	String strSndrID = (String)objParamForm.getParamValue("SndrID");
	String strRcvrID = (String)objParamForm.getParamValue("RcvrID");
	String strElcUse = (String)objParamForm.getParamValue("ElcUse");
	String strSmsUse = (String)objParamForm.getParamValue("SmsUse");
	String strReqOrganNm = (String)objParamForm.getParamValue("ReqOrganNm"); // 요구기관명
	String strReqOrganID = (String)objParamForm.getParamValue("ReqOrganID"); // 요구 기관 ID
	String strSubmtOrganNm = (String)objParamForm.getParamValue("SubmtOrganNm"); // 제출기관명.
	String strAnsDocFilePath = null; // 답변서 파일 경로
	//strReturnURL = strReturnURL+"?ReqBoxID="+strReqBoxID;
	//
	String strReturnFlag = request.getParameter("ReturnURLFLAG")==null?"":request.getParameter("ReturnURLFLAG");
	
	String strReturnURL = null;

	System.out.println("strReturnFlag ::"+strReturnFlag);

	if(strReturnFlag.equals("CMT")){
		strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxList.jsp";
	}else{
		strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp";
	}
	

	
	try {
		// 어쩔수없이 무조건 답변서 ID Sequence를 만들어야한다

		int intInsertAnsInfoResult = -1;

		System.out.println("strReqBoxID  : "+strReqBoxID);

		String strAnsID = "";		

		objRs = new ResultSetHelper((ArrayList)objReqInfoDelegate.getReqId(strReqBoxID));

		if(objRs.getRecordSize() == 0){
			throw new AppException("등록된 요구가 없습니다. 확인요망");
		}
		//요구에대한 답변작성 일괄처리 해버린다.
	    while(objRs.next()){
		   strReqID = (String)objRs.getObject("REQ_ID");;
		   objParamForm2.setParamValue("ReqID",strReqID);
		   strAnsID = objSMAIDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
		   objParamForm2.setParamValue("AnsID", StringUtil.padl(strAnsID, 10));
		   intInsertAnsInfoResult = objSMAIDelegate.setNewRecordToAnsInfo(objParamForm2);			
		}


		if(intInsertAnsInfoResult > 0){
			
			String strAnsDocSeq = objRDSDelegate.getSeqNextVal("TBDS_ANS_DOC_INFO");
			strAnsDocSeq = StringUtil.padl(strAnsDocSeq, 10);
			strAnsDocFilePath = objBindDelegate.CreateAnsDoc(strReqBoxID, strAnsDocSeq);
			
			if (!StringUtil.isAssigned(strAnsDocFilePath)) {
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode("몰라몰라.. 답변서 파일 만드는데 자꾸 에러 나자나!!!!");
				objMsgBean.setStrMsg("답변서 파일 생성 에러 : 답변서 파일 생성 과정 점검 바랍니다.");
	%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
				return;
			} else {  // 답변서 생성이 정상적으로 진행되었다.
			
				// 생성된 답변서 파일 경로는 Form에 담아야 한다.
				objParamForm.setParamValue("AnsDocFilePath", strAnsDocFilePath);
				// 답변서 ID도 미리 만들어서 FORM에 담아야 한다.
				objParamForm.setParamValue("AnsDocID", strAnsDocSeq);
				
				// 답변서 발송 관련된 DB IO 작업을 시작한다.
				int intResult = objADSDelegate.setAnsDocSendProc(objParamForm);
				
				if (intResult < 1) {
					out.println("Error....................... Check the Log Contents....T_T");
				} else {
				
					// 발신자 수신자 정보 쒜~~~~~~~~~~~~~~~~팅!!!!!!!!!!!!!!!!
					//Hashtable hashSndrInfo = (Hashtable)objRDSDelegate.getRecordListFromUserInfo(strSndrID, CodeConstants.REQ_ORGAN_PERSON, objUserInfo.getOrganID()); 
					//Hashtable hashRcvrInfo = (Hashtable)objRDSDelegate.getRecordListFromUserInfo(strRcvrID, CodeConstants.SUBMIT_ORGAN_PERSON, strSubmtOrganID);
					System.out.println("strRcvrID : "+strRcvrID);
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
						strSendPhoneNo = StringUtil.ReplaceString((String)hashRcvrInfo.get("CPHONE"), "-", ""); 	// 받을 사람 핸드폰 번호
					}
					if (StringUtil.isAssigned(strReturnPhoneNo)) {
						strReturnPhoneNo = StringUtil.ReplaceString((String)hashSndrInfo.get("CPHONE"), "-", "");	// 보내는 사람 핸드폰 번호
					}
					
					String strSendStatus = CodeConstants.ELC_SMS_SEND_REQ; // 서류제출은 그냥 발송 : 1
					
					// 2004-06-04 원래는 인자값이 없는 함수였으나, 요청에 의해 변경되었다.
					//String strSmsMsg = (String)objADSDelegate.getAnsDocSmsMsg(strSubmtOrganNm);
					String strSmsMsg = "의정자료전자유통시스템에 답변서가 제출되었습니다["+strSubmtOrganNm2+"]";

					System.out.println("답변메시지 : "+strReqBoxID +"-"+ strSmsMsg);
					
					String strSystemGbn = CodeConstants.ELC_SMS_SYSTEM_REQ;
					String strServiceGbn = CodeConstants.ELC_SMS_SERVICE_REQ;
					String strDeptGbn = StringUtil.getEmptyIfNull((String)hashSndrInfo.get("GOV_STD_CD"));
					String strUserID = strSndrID;
					String strOffiDocID = ""; // 답변서 발송에서는 공문서 ID 없음!!!!!!!!!!
					String strInOutGbn = "2"; // 제출 ----------> 요구 : 2
					String strRcvrName = (String)hashRcvrInfo.get("USER_NM");
					String strRcvrMail = (String)hashRcvrInfo.get("EMAIL");
					String strSndrName = (String)hashSndrInfo.get("USER_NM");
					String strSndrMail = (String)hashSndrInfo.get("EMAIL");
					String strSubject = (String)objADSDelegate.getAnsDocMailSubject(); 
					
					// 2004-07-28
					// 요구자는 수신자
					// 제출자는 발신자
					// 수신자명을 제외하고는 발신자 정보를 모두 입력해야 함.
					//String strContents = (String)objADSDelegate.getAnsDocMailContent(strSndrName, strReqOrganNm, strSendPhoneNo, strSndrMail);
					String strContents = (String)objADSDelegate.getAnsDocMailContent(strRcvrName, strSubmtOrganNm+" "+(String)objUserInfo.getUserName(), strReturnPhoneNo1, strSndrMail);
					
					// SMS & e-mail 발송 시~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~작!!!!!!!!!!!!!!!!!
					// E-MAIL 발송 Hashtable 담자
					System.out.println("시작");

					System.out.println(strRcvrID);
					System.out.println(strRcvrName);
					System.out.println(strRcvrMail);
					System.out.println(strSndrID);
					System.out.println(strSndrName);
					System.out.println(strSndrMail);
					System.out.println(strSubject);
					System.out.println(strContents);
					System.out.println(strSystemGbn);
					System.out.println(strServiceGbn);
					System.out.println(strReqOrganID);
					System.out.println(strReqOrganNm);
					
					

					hashMailInfo.put("RID", strRcvrID);
					if(strRcvrName == null || strRcvrName.equals("")){
						hashMailInfo.put("RNAME", "");
						hashMailInfo.put("RMAIL", "");
					}else{
						hashMailInfo.put("RNAME", strRcvrName);
						hashMailInfo.put("RMAIL", strRcvrMail);
					}
					
					hashMailInfo.put("SID", strSndrID);
					hashMailInfo.put("SNAME", strSndrName);
					hashMailInfo.put("SMAIL", strSndrMail);
					hashMailInfo.put("SUBJECT", strSubject);
					hashMailInfo.put("CONTENTS", strContents);
					hashMailInfo.put("SYSTEM_GBN", strSystemGbn);
					hashMailInfo.put("SERVICE_GBN", strServiceGbn);
					hashMailInfo.put("STATUS", "0"); // 바로 전송
					hashMailInfo.put("DEPT_GBN", strReqOrganID);
					hashMailInfo.put("DEPT_NM", strReqOrganNm); // 요구기관명
					System.out.println("333333333333");
					//hashMailInfo.put("USER_ID", strUserID);
					//hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
					//hashMailInfo.put("IN_OUT_GBN", strInOutGbn);
					
					//int intSendMailResult = objUmsDelegate.insertSMTP_WEB_REC(hashMailInfo);
					int intSendMailResult = 1;
					if (intSendMailResult < 1) {
						System.out.println("[메일발송] 실제로는 여기서 에러가 발생했슴.... 확인바람  ");
						intSendMailResult = 0;
					}
					int intSendSmsResult = 0;
					
					if (CodeConstants.NTC_MTD_BOTH.equalsIgnoreCase(strSmsUse) && StringUtil.isAssigned(strSendPhoneNo)) {
						// SMS 발송 Hashtable 담자
						System.out.println("4444444444444444");
						hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
						hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
						hashSmsInfo.put("SEND_STATUS", "1");
						hashSmsInfo.put("MSG", strSmsMsg);
						hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
						hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
						hashSmsInfo.put("DEPT_GBN", strReqOrganID);
						hashSmsInfo.put("USER_ID", strUserID);
						hashSmsInfo.put("DEPT_NM", objUserInfo.getOrganID()); // 2004-04-13 추가 1
						hashSmsInfo.put("USER_NM", strSndrName); // 2004-04-13 추가 2
						System.out.println("5555555555555555");
						//hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
						//hashSmsInfo.put("IN_OUT_GBN", strInOutGbn);
						//intSendSmsResult = objUmsDelegate.insertSMS(hashSmsInfo);
						intSendSmsResult = 1;
						if (intSendSmsResult < 1) {
							System.out.println("[문자전송] 실제로는 여기서 에러가 발생했슴.... 확인바람  ");
							intSendSmsResult = 0;
						}
					}
									
					// 발송정보 테이블 입력
					objParamForm.setParamValue("MsgSeq", String.valueOf(intSendSmsResult));
					objParamForm.setParamValue("MailID", String.valueOf(intSendMailResult));
					int intSendInfoResult = objADSDelegate.setNewRecordToSendInfo(objParamForm);
					if (intSendInfoResult < 1) System.out.println("[SMakeAnsDocSendProc.jsp] 발송정보 테이블 입력 에러 발생 확인 요망!!!!!!!");
					else System.out.println("[AnsDocSendProc.jsp] 발송정보 테이블 입력 성공~~~ Success~~~~~~~!!!!!!!");
							
					out.println("<script language='javascript'>");
					out.println("alert('답변서 발송을 정상적으로 완료하였습니다.');");
					out.println("self.close();");
					out.println("window.opener.location.href='"+strReturnURL+"';");
					out.println("</script>");
					//out.println("<meta http-equiv='refresh' content='0; url=/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp'>");
				}
				
				
			} // 만약 요구서 파일 생성이.. 쩌비쩌비

		}		
		
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
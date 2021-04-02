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
	CommAnsDocDelegate objBindDelegate = new CommAnsDocDelegate(); // 답변서 파일 관련 DELEGATE
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	MemAnsDocSendDelegate objADSDelegate = new MemAnsDocSendDelegate();
	CommReqDocDelegate objDocBean = new CommReqDocDelegate(); // 요구서 관련 DELEGATE
	OrganInfoDelegate objOrganDelegate = new OrganInfoDelegate();
	SMemAnsDocSendForm objParamForm = new SMemAnsDocSendForm();
	RMemReqDocSendForm objForm = new RMemReqDocSendForm();
	UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();

	// 왜 너만 홀로 이렇게 남아야 하는지... CVS한테 물어봐바....
	String strReturnURL = request.getParameter("ReturnURL");

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
	System.out.println("strReturnURL ::"+strReturnURL);
	String strReqDocFilePath = null;

	try {
		// 어쩔수없이 무조건 답변서 ID Sequence를 만들어야한다
		String strAnsDocSeq = objRDSDelegate.getSeqNextVal("TBDS_ANS_DOC_INFO");
		strAnsDocSeq = StringUtil.padl(strAnsDocSeq, 10);
		strAnsDocFilePath = objBindDelegate.CreateAnsDoc(strReqBoxID, strAnsDocSeq);
		String strReqDocSeq = objRDSDelegate.getSeqNextVal("TBDS_REQ_DOC_INFO");
		strReqDocFilePath  = objDocBean.CreateReqDoc(strReqBoxID, "001", StringUtil.padl(strReqDocSeq, 10));

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

			objForm.setParamValue("ReqBoxID", strReqBoxID);
			objForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
			objForm.setParamValue("ReqDocID", strReqDocSeq);
			int intResult00 = objRDSDelegate.setNewRecordToReqDocInfo(objForm);

			if (intResult < 1) {
				out.println("Error....................... Check the Log Contents....T_T");
			} else {

				// 발신자 수신자 정보 쒜~~~~~~~~~~~~~~~~팅!!!!!!!!!!!!!!!!
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
					strSendPhoneNo = StringUtil.ReplaceString((String)hashRcvrInfo.get("CPHONE"), "-", ""); 	// 받을 사람 핸드폰 번호
				}
				if (StringUtil.isAssigned(strReturnPhoneNo)) {
					strReturnPhoneNo = StringUtil.ReplaceString((String)hashSndrInfo.get("CPHONE"), "-", "");	// 보내는 사람 핸드폰 번호
				}

				String strSendStatus = CodeConstants.ELC_SMS_SEND_REQ; // 서류제출은 그냥 발송 : 1


				// 2004-06-04 원래는 인자값이 없는 함수였으나, 요청에 의해 변경되었다.
				//String strSmsMsg = (String)objADSDelegate.getAnsDocSmsMsg(strSubmtOrganNm2);
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
				hashMailInfo.put("STATUS", "0"); // 바로 전송
				hashMailInfo.put("DEPT_GBN", strReqOrganID);
				hashMailInfo.put("DEPT_NM", strReqOrganNm); // 요구기관명
				//hashMailInfo.put("USER_ID", strUserID);
				//hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
				//hashMailInfo.put("IN_OUT_GBN", strInOutGbn);

				int intSendMailResult = objUmsDelegate.insertSMTP_WEB_REC(hashMailInfo);
				//int intSendMailResult = 1;
				if (intSendMailResult < 1) {
					System.out.println("[메일발송] 실제로는 여기서 에러가 발생했슴.... 확인바람  ");
					intSendMailResult = 0;
				}
				int intSendSmsResult = 0;

				if (CodeConstants.NTC_MTD_BOTH.equalsIgnoreCase(strSmsUse) && StringUtil.isAssigned(strSendPhoneNo)) {
					// SMS 발송 Hashtable 담자
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
					//hashSmsInfo.put("OFFI_DOC_ID", strOffiDocID);
					//hashSmsInfo.put("IN_OUT_GBN", strInOutGbn);
					intSendSmsResult = objUmsDelegate.insertSMS(hashSmsInfo);
					//intSendSmsResult = 1;
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
				out.println("alert('답변서 발송을 완료하였습니다.\\n발송하신 답변자료는 [제출완료 요구함]에서 확인 가능합니다.');");
				out.println("self.close();");
                System.out.println("손성제strReturnURL"+strReturnURL);
				if (strReturnURL.indexOf("10_mem")>0){
				out.println("window.opener.location.href='/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp';");
                } else {
				out.println("window.opener.location.href='/reqsubmit/20_comm/20_reqboxsh/40_subend/SSubEndBoxList.jsp';");
                }
				out.println("</script>");
				//out.println("<meta http-equiv='refresh' content='0; url=/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp'>");
			}


		} // 만약 요구서 파일 생성이.. 쩌비쩌비

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
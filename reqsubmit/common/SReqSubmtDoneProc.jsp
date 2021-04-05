<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strReturnURL = request.getParameter("ReturnURL");
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID = request.getParameter("ReqID");
	String strReqStt = request.getParameter("ReqStt");

	String strURL[] =StringUtil.split("?",strReturnURL)	;
	if(strURL[0] == null ||strURL[0].equals("")){
		strURL[0] = 	strReturnURL;
	}
	String strReturnURL2 = strURL[0];

	System.out.println("strReqBoxID :"+strReqBoxID);
	System.out.println("strReqID :"+strReqID);
	System.out.println("strReqStt :"+strReqStt);
	System.out.println("strReturnURL :"+strReturnURL);
	System.out.println("objUserInfo.getOrganID() :"+objUserInfo.getOrganID());
	System.out.println("objUserInfo.getUserID() :"+objUserInfo.getUserID());

	if (!StringUtil.isAssigned(strReqID)) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg("요구 ID가 없습니다.");
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}

	SMemReqBoxDelegate objReqBox = new SMemReqBoxDelegate();
	AnsInfoDelegate objAnsDelegate = new AnsInfoDelegate();
	int intResult = 0;
	String strMsg = "";

	if(objReqBox.getReqCntNotSubmit(strReqBoxID) == 1) {							// 마지막 제출완료 이므로 제출완료 처리 후 답변서 자동 발송 과정을 진행한다.
		intResult = 0;

		if (strReturnURL2.indexOf("10_mem")>0){
            strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp";
        } else {
            strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/40_subend/SSubEndBoxList.jsp";
        }
		strMsg = "모든 요구에 대한 답변 제출을 완료하였으므로, 자동 답변서 발송 처리하였습니다.";
		objAnsDelegate.setLastReqSubmtDone(strReqBoxID, strReqID, strReqStt, objUserInfo.getOrganID(), objUserInfo.getUserID());

	} else {

		// 마지막 제출완료가 아니기 때문에 그냥 해당 요구만 제출완료 업데이트 하고 마무리 한다.
		intResult = objAnsDelegate.setReqSubmtDone2(strReqID, strReqStt);
		if(strReturnURL2.equals("/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqInfo.jsp")){
			strReturnURL = "/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqList.jsp";
		}else if(strReturnURL2.equals("/reqsubmit/10_mem/30_reqlistsh/20_nonsub/SNonReqVList.jsp")){
			 strReturnURL = "/reqsubmit/10_mem/30_reqlistsh/20_nonsub/SNonReqList.jsp";
		}else{
			strReturnURL = strReturnURL;
		}
		strMsg = "해당 요구에 대한 답변 제출을 완료하였습니다.";
		if (intResult < 1) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  		objMsgBean.setStrCode("");
		  	objMsgBean.setStrMsg("제출완료 DB작업에서 에러 발생");
%>
		  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}

	}


	out.println("<script language='javascript'>");
	out.println("alert('"+strMsg+"');");
	out.println("</script>");
	out.println("<meta http-equiv='refresh' content='0; url="+strReturnURL+"'>");
%>
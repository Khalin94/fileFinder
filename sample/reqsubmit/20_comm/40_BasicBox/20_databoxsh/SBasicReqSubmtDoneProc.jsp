<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strReturnURL = null;
	strReturnURL = request.getParameter("ReturnURL");
	//String strRedirectURL = "/reqsubmit/20_comm/40_BasicBox/20_databoxsh/SBasicReqInfoVList.jsp";
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID = request.getParameter("ReqID");

	if (!StringUtil.isAssigned(strReturnURL)) strReturnURL = "/reqsubmit/20_comm/40_BasicBox/20_databoxsh/SBasicReqInfoVList.jsp"+"?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID;
	
	if (!StringUtil.isAssigned(strReqID)) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg("요구 ID가 없습니다.");
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}
	
	AnsInfoDelegate objAnsDelegate = new AnsInfoDelegate();
	int intResult = objAnsDelegate.setReqSubmtDone(strReqID);
	if (intResult < 1) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("");
	  	objMsgBean.setStrMsg("제출완료 DB작업에서 에러 발생");
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%		
	} else {
		out.println("<script language='javascript'>");
		out.println("alert('해당 요구에 대한 답변 제출을 완료하였습니다.');");
		out.println("</script>");
		out.println("<meta http-equiv='refresh' content='0; url="+strReturnURL+"'>");
	}
%>
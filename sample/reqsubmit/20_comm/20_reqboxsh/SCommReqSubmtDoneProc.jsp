<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strRedirectURL = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp";
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID = request.getParameter("ReqID");
	
	if (!StringUtil.isAssigned(strReqID)) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg("요구 ID가 없습니다.");
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}
	
	CommAnsInfoDelegate objAns = new CommAnsInfoDelegate();
	int intResult = objAns.setReqSubmtDone(strReqID);
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
		out.println("<meta http-equiv='refresh' content='0; url="+strRedirectURL+"?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID+"'>");
	}
%>
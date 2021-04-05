<%@ page language="java" contentType="text/html; charset=euc-kr" session="true" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strReturnURL = null;
	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	AnsInfoDelegate objAnsD = new AnsInfoDelegate();

	// 파라미터가 정상적으로 넘어온건지 확인해보자
	boolean blnParamCheck = false;
	blnParamCheck = objParamForm.validateParams(request);
  	if(!blnParamCheck) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg("Param Error : " + objParamForm.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>	
<%
		return;
	}
	
	try {
		// 2004-06-09 ReturnURL Setting
		strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"));
		strReturnURL = StringUtil.ReplaceString(strReturnURL, "\n", "");
		strReturnURL = StringUtil.ReplaceString(strReturnURL, "\t", "");
		strReturnURL = StringUtil.ReplaceString(strReturnURL, "\r", "");
		strReturnURL = StringUtil.ReplaceString(strReturnURL, "<BR>", "");
		strReturnURL = StringUtil.ReplaceString(strReturnURL, " ", "");
		
		// 이용자 ID를 쒜팅한다.
		objParamForm.setParamValue("RegrID", objUserInfo.getUserID());
		
		int intResult = objAnsD.setNewRecordFromOverlapReq(objParamForm);
		if (intResult < 1) {
			System.out.println("[SReqOverlapCheckProc.jsp] Result < 1 Error!!!!!!!!!!!");
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  		objMsgBean.setStrCode("");
  			objMsgBean.setStrMsg("답변 등록이 정상적으로 완료되지 못했습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			out.println("<script language='javascript'>");
			out.println("alert('중복 조회를 통한 답변 등록이 정상적으로 완료되었습니다.');");
			if (StringUtil.isAssigned(strReturnURL)) {
				out.println("opener.window.location.href='"+strReturnURL+"';");
			} else {
				out.println("opener.window.location.reload();");
			}
			out.println("self.close();");
			out.println("</script>");
		}
	} catch(Exception e) {
		System.out.println("[SReqOverlapCheckProc.jsp] Exception "+e.getMessage());
		e.printStackTrace();
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode("");
  		objMsgBean.setStrMsg(e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
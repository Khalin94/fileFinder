<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;	
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %> 

<%
	String strUserID = (String)session.getAttribute("USER_ID");
	String ansrID = request.getParameter("AnsrId");
	System.out.println("kangthis logs 세션값 strUserID => " + strUserID);
	System.out.println("kangthis logs 넘겨준값 ansrID => " + ansrID);
    /*if (strUserID == null || strUserID.equals("") || !strUserID.equals(ansrID)) {
        out.println("<script language=javascript>");
        out.println("alert('등록한 사용자만이 삭제할수 있습니다.')");
        out.println("history.back();");
        out.println("</script>");
        return;
	}*/
	
	String ansID2 = request.getParameter("AnsID2");
	String[] ansIDs = new String[1];
	ansIDs[0] = ansID2;
	String strWinType = request.getParameter("WinType");
	String strReturnURL = request.getParameter("ReturnURL");	 

	AnsInfoDelegate selfDelegate = new AnsInfoDelegate();
	int result1 = selfDelegate.getAnsrId(ansIDs, strUserID);
    System.out.println("kangthis logs result1 => " +result1);
    
    if (result1 > 0) {
     out.println("<script language=javascript>");
     out.println("alert('등록한 사용자만이 삭제할수 있습니다.')");
     out.println("history.back();");
     out.println("</script>");
     return;
    }
	
	try {
		int result = selfDelegate.deleteRecord(ansIDs, CodeConstants.REQ_BOX_STT_006);
		if (result > 0) {
			if ("SELF".equalsIgnoreCase(strWinType)) {
				out.println("<script language='javascript'>alert('선택하신 답변 삭제에 성공하였습니다.');</script>");
				out.println("<meta http-equiv='refresh' content='0;url="+strReturnURL+"'>");
			} else {
				out.println("<script language='javascript'>alert('선택하신 답변 삭제에 성공하였습니다.');");
				out.println("self.close();");
				out.println("opener.window.location.href='"+strReturnURL+"';");
				out.println("</script>");
			}
		} else {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("");
	  		objMsgBean.setStrMsg("해당 파일이 정상적으로 삭제되지 못했습니다. 처리내용을 확인해 주세요");
%>
	  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}
	} catch(Exception e) {
		System.out.println("[SAnsInfoDelProc.jsp] Exception : " + e.getMessage());
		e.printStackTrace();
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("");
		objMsgBean.setStrMsg("Exception : "+e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

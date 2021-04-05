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
	System.out.println("kangthis logs ���ǰ� strUserID => " + strUserID);
	System.out.println("kangthis logs �Ѱ��ذ� ansrID => " + ansrID);
    /*if (strUserID == null || strUserID.equals("") || !strUserID.equals(ansrID)) {
        out.println("<script language=javascript>");
        out.println("alert('����� ����ڸ��� �����Ҽ� �ֽ��ϴ�.')");
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
     out.println("alert('����� ����ڸ��� �����Ҽ� �ֽ��ϴ�.')");
     out.println("history.back();");
     out.println("</script>");
     return;
    }
	
	try {
		int result = selfDelegate.deleteRecord(ansIDs, CodeConstants.REQ_BOX_STT_006);
		if (result > 0) {
			if ("SELF".equalsIgnoreCase(strWinType)) {
				out.println("<script language='javascript'>alert('�����Ͻ� �亯 ������ �����Ͽ����ϴ�.');</script>");
				out.println("<meta http-equiv='refresh' content='0;url="+strReturnURL+"'>");
			} else {
				out.println("<script language='javascript'>alert('�����Ͻ� �亯 ������ �����Ͽ����ϴ�.');");
				out.println("self.close();");
				out.println("opener.window.location.href='"+strReturnURL+"';");
				out.println("</script>");
			}
		} else {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("");
	  		objMsgBean.setStrMsg("�ش� ������ ���������� �������� ���߽��ϴ�. ó�������� Ȯ���� �ּ���");
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

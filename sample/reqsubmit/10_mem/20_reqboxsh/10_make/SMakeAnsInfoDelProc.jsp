<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemAnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %> 

<%
	String[] ansIDs = request.getParameterValues("AnsID");
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID = request.getParameter("ReqID");
	String returnURL = request.getParameter("returnURL");
	 
	if (ansIDs.length < 1) throw new AppException("[SMakeAnsInfoDelete.jsp] 답변ID(AnsID)가 하나도 입력되지 않았습니다.");
	SMemAnsInfoDelegate selfDelegate = new SMemAnsInfoDelegate();
	
	try {
		int result = selfDelegate.deleteRecord(ansIDs, CodeConstants.REQ_BOX_STT_006);
		if (result > 0) {
			if ("SELF".equalsIgnoreCase(returnURL)) {
				out.println("<script language='javascript'>alert('선택하신 답변 삭제에 성공하였습니다.');</script>");
				out.println("<meta http-equiv='refresh' content='0;url=SMakeReqInfoVList.jsp?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID+"'>");
			} else {
				out.println("<script language='javascript'>alert('선택하신 답변 삭제에 성공하였습니다.');");
				out.println("self.close();");
				out.println("opener.window.location.reload();");
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
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("");
		objMsgBean.setStrMsg("Exception : "+e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
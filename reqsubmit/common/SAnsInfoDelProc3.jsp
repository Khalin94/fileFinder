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
	String[] delIDs = request.getParameterValues("AnsID2");
	String strWinType = request.getParameter("WinType");
	String strReturnURL = request.getParameter("ReturnURL");
	String[] arrAnsr_id = request.getParameterValues("AnsID");
        
        /*for(int a=0; a<arrAnsr_id.length; a++){
            String ansrId[] = arrAnsr_id[a].split("\\$\\$");
            if (strUserID == null || strUserID.equals("") || !strUserID.equals(ansrId[1])) {    
                out.println("<script language=javascript>");
                out.println("alert('등록한 사용자만이 삭제할수 있습니다.')");
                out.println("history.back();");
                out.println("</script>");
                return;
            }  
        }*/

    System.out.println("delIDs[0]"+delIDs[0]);

	String[] ansIDs = delIDs[0].split(",");
	for(int a=0; a<ansIDs.length; a++){
        System.out.println("ansIDs[a]"+ansIDs[a]);
	}
	if (ansIDs.length < 1) throw new AppException("[SMakeAnsInfoDelete.jsp] 답변ID(AnsID)가 하나도 입력되지 않았습니다.");
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
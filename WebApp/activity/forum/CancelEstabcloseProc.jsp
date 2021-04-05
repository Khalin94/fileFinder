<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	
	try
	{	
		nads.dsdm.app.activity.forum.UserForumDelegate objUserForumDelegate = new nads.dsdm.app.activity.forum.UserForumDelegate();
		
		String strForumStt   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("forum_stt"));
		String strForumId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("forum_id"));
		
		Vector objForumVt = new Vector();
		int iResult = 0;
		if(strForumStt.equals("001") || strForumStt.equals("002")){  
			//포럼상태가 개설신청이면 개설신청거부가 되므로 포럼테이블에서 해당 데이터를 삭제한다.
			objForumVt.add(strForumId);
			iResult = objUserForumDelegate.deleteForum(objForumVt);
			strMessage = strMessage + String.valueOf(iResult) + "건 삭제 되었습니다.";
		}else if(strForumStt.equals("004") || strForumStt.equals("005")){
			//포럼상태가 폐쇄신청이면 폐쇄신청거부가 되므로 포럼상태를 운영(003)으로 수정한다.
			objForumVt.add("003");
			objForumVt.add(strForumId);
			iResult = objUserForumDelegate.updateForumStt(objForumVt);
			strMessage = strMessage + String.valueOf(iResult) + "건 확인(정상) 되었습니다.";
		}
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<script language="javascript">
<!--
	alert("<%=strMessage%>");
		
	<%if(strError.equals("no")){%>
	location.href="./../MyForum_ApplyJoin.jsp";
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>

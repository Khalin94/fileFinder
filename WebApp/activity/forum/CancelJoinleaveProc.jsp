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
		String strUserId = (String)session.getAttribute("USER_ID");
		
		nads.dsdm.app.activity.forum.UserForumDelegate objUserForumDelegate = new nads.dsdm.app.activity.forum.UserForumDelegate();
		
		String strUserStt   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("user_stt"));
		String strForumId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("forum_id"));
		
		Vector objForumUserVt = new Vector();
		int iResult = 0;
		if(strUserStt.equals("001") || strUserStt.equals("002")){  
			//유저상태가 가입신청이면 가입신청거부가 되므로 포럼회원테이블에서 해당 데이터를 삭제한다.
			objForumUserVt.add(strForumId);
			objForumUserVt.add(strUserId);
			iResult = objUserForumDelegate.deleteForumUser(objForumUserVt);
			strMessage = strMessage + String.valueOf(iResult) + "건 삭제 되었습니다.";
		}else if(strUserStt.equals("004") || strUserStt.equals("005")){
			//유저상태가 탈퇴신청이면 탈퇴신청거부가 되므로 유저상태를 운영(003)으로 수정한다.
			objForumUserVt.add("003");
			objForumUserVt.add(strForumId);
			objForumUserVt.add(strUserId);
			iResult = objUserForumDelegate.updateUserStt(objForumUserVt);
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

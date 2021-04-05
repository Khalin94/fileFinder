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
			//�������°� ������û�̸� ������û�źΰ� �ǹǷ� �������̺��� �ش� �����͸� �����Ѵ�.
			objForumVt.add(strForumId);
			iResult = objUserForumDelegate.deleteForum(objForumVt);
			strMessage = strMessage + String.valueOf(iResult) + "�� ���� �Ǿ����ϴ�.";
		}else if(strForumStt.equals("004") || strForumStt.equals("005")){
			//�������°� ����û�̸� ����û�źΰ� �ǹǷ� �������¸� �(003)���� �����Ѵ�.
			objForumVt.add("003");
			objForumVt.add(strForumId);
			iResult = objUserForumDelegate.updateForumStt(objForumVt);
			strMessage = strMessage + String.valueOf(iResult) + "�� Ȯ��(����) �Ǿ����ϴ�.";
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

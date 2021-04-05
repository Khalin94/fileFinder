<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.session.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strForumID =nads.lib.reqsubmit.util.StringUtil.getNoTagStr( StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //ȸ������
	String strCloseRsn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("closeRsn"))); //������

	try {
		SLDBForumDelegate objDBForum = new SLDBForumDelegate();

		Vector objForumUserData = new Vector(0);
		objForumUserData.add(strCloseRsn);
		objForumUserData.add(strForumID);

		int intCnt = objDBForum.updateForumClosereq(objForumUserData);

		if (intCnt < 1) {
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;

		} else {
%>
			<script language="JavaScript">
			<!--
				alert("ó���Ǿ����ϴ�.");
				opener.location.href="/forum/indmain/ForumIndMain.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>";
				self.close();
			//-->
			</script>
<%
			return;
		}
		
	} catch (AppException objAppEx) {
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}
%>
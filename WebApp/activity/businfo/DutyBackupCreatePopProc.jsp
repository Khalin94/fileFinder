<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "yes";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();
	
		String strOrganId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("organ_id"));

		Vector objParamVt = new Vector();
		objParamVt.add(strUserId);
		objParamVt.add(strOrganId);
		
		int iResult = objBusInfoDelegate.insertBackup(objParamVt, "C");
		strError = "no";
		strMessage = "���������� ������� �ۼ��� ���۵Ǿ����ϴ�. ����Ŀ� ��� �ٿ�ε� ��ư�� �̿��Ͽ� ����� �����ñ� �ٶ��ϴ�.";
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
	opener.location.reload();
    self.window.close(); 
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>

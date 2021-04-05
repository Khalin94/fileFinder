<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
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
		
		nads.dsdm.app.activity.useritet.UserItetDelegate objUserItetDelegate = new nads.dsdm.app.activity.useritet.UserItetDelegate();
		
		String strAppIds = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("app_id"));   //���α׷�ID(��>"0000001,0000003")
		Vector objAppIdVt = ActComm.makeNoType(strAppIds, ",");  //���ڿ��� �Ǿ� �ִ� ���α׷�ID�� vector�� ����
		Hashtable objParamHt = new Hashtable();
		objParamHt.put("USER_ID", strUserId);    //�����ID
		objParamHt.put("APP_ID", objAppIdVt);    //���α׷�ID
		int intResult = objUserItetDelegate.insertUserItet(objParamHt);
		//--out.println("Result : " + intResult);
		strMessage = strMessage + String.valueOf(intResult) + "�� ���� �Ǿ����ϴ�.";
		//--response.sendRedirect("SendFax.jsp");
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
	location.href="./../SetupPerEnv_ConcernInfo.jsp";
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>

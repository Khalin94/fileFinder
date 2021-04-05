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
		
		String strAppIds = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("app_id"));   //프로그램ID(예>"0000001,0000003")
		Vector objAppIdVt = ActComm.makeNoType(strAppIds, ",");  //문자열로 되어 있는 프로그램ID을 vector에 저장
		Hashtable objParamHt = new Hashtable();
		objParamHt.put("USER_ID", strUserId);    //사용자ID
		objParamHt.put("APP_ID", objAppIdVt);    //프로그램ID
		int intResult = objUserItetDelegate.insertUserItet(objParamHt);
		//--out.println("Result : " + intResult);
		strMessage = strMessage + String.valueOf(intResult) + "건 생성 되었습니다.";
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

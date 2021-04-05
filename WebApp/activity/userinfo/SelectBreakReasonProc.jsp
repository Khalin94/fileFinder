<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strMessage = "";
	String strError = "no";
	
	String strSttCd   = "";
	String strSttChgRsn = "";
	String strUserId = "";
	try
	{
		strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
		
		Hashtable objSttHt = objUserInfoDelegate.selectStatus(strUserId);
		
		strSttCd   = (String)objSttHt.get("STT_CD");
		if(!strSttCd.equals("001") && !strSttCd.equals("002") && !strSttCd.equals("003")){
			strSttChgRsn = (String)objSttHt.get("STT_CHG_RSN");
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
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strMessage = "";
	String strError = "no";
	String strRecordCnt_10 = " ";
	String strRecordCnt_15 = " ";
	String strRecordCnt_20 = " ";
		
	String strDisplayKind_new = " ";
	String strDisplayKind_curr = " ";
		
	String strPeriod_7 = " ";
	String strPeriod_14 = " ";
	String strPeriod_30 = " ";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");

		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
		
		Hashtable objSrchHt = objUserInfoDelegate.selectSrch(strUserId);
		
		String strSrchRecordCnt   = ((String)objSrchHt.get("SRCH_RECORD_CNT")).trim();
		String strSrchDisplayKind = ((String)objSrchHt.get("SRCH_DISPLAY_KIND")).trim();
		String strGthrPeriod = (String)objSrchHt.get("GTHER_PERIOD");
		
		if(strSrchRecordCnt.equals("10")) strRecordCnt_10 = "selected";
		if(strSrchRecordCnt.equals("15")) strRecordCnt_15 = "selected";
		if(strSrchRecordCnt.equals("20")) strRecordCnt_20 = "selected";
		
		if(strSrchDisplayKind.equals("0")) strDisplayKind_new = "checked";
		if(strSrchDisplayKind.equals("1")) strDisplayKind_curr = "checked";
		
		if(strDisplayKind_new.equals("") && strDisplayKind_curr.equals("")){
			strDisplayKind_new = "checked";
		}
		
		if(strGthrPeriod.equals("7")) strPeriod_7  = "selected";
		if(strGthrPeriod.equals("14")) strPeriod_14  = "selected";
		if(strGthrPeriod.equals("30")) strPeriod_30  = "selected";
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
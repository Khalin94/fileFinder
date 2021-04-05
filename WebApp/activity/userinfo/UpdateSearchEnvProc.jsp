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

		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
		
		String strSrchRecordCnt   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("page_cnt"));
		String strSrchDisplayKind = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("win_type"));
		String strTerm = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("term"));
		
		Vector objSearchVt = new Vector();
		
		objSearchVt.add(strSrchRecordCnt);//검색결과창종류
		objSearchVt.add(strSrchDisplayKind);//검색결과창종류
		objSearchVt.add(strTerm);//인기검색어조회기간
		objSearchVt.add(strUserId);
		objSearchVt.add(strUserId);
		
		int intResult = objUserInfoDelegate.updateSrch(objSearchVt);
		
		session.setAttribute("SRCH_RECORD_CNT",strSrchRecordCnt);
		session.setAttribute("SRCH_DISPLAY_KIND", strSrchDisplayKind);
		session.setAttribute("GTHER_PERIOD",strTerm);
		//--out.println("Result : " + intResult);
		strMessage = "변경 되었습니다.";
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
	location.href="./../SetupPerEnv_SearchEnv.jsp";
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>

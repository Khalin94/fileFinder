<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*" %>

<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="kr.co.kcc.bf.config.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	ArrayList objRelOrganArry = new ArrayList();//관련기관
	Hashtable objRelOrganHt = new Hashtable();

	String strCommittee = "";

	try{
		strCommittee = kr.co.kcc.bf.bfutil.StringUtil.getNVL(request.getParameter("comm"), "");
		nads.dsdm.app.main.MainDelegate objMainCommDelegate = new nads.dsdm.app.main.MainDelegate();
		objRelOrganArry = objMainCommDelegate.selectRelOrgan(strCommittee, "");
	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(objMsgBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<html>
<title>의정자료 전자유통 시스템</title>
<head></head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" type="text/JavaScript">
<!--

//-->
</script>

<link href="../css/global.css" rel="stylesheet" type="text/css">
</head>
<script language="javascript">
function AddItem(selectobj,val,txt,optindex) {
	NewItem = new Option(txt, val, false, true);
	selectobj.options[optindex]=NewItem;
}
<%

	String strOrganIdLeft = "";
	String strOrganNmLeft = "";
	String strHomeUrl = "";
	for(int j=0; j<objRelOrganArry.size(); j++){
		objRelOrganHt = (Hashtable)objRelOrganArry.get(j);
		strOrganIdLeft = (String)objRelOrganHt.get("ORGAN_ID");
		strOrganNmLeft = (String)objRelOrganHt.get("ORGAN_NM");
		strHomeUrl = (String)objRelOrganHt.get("HOME_URL");
%>
		NewItem = new Option('<%=strOrganNmLeft%>', '<%=strHomeUrl%>', false, true);
		parent.form_main1.relorgan.options[<%=j + 1%>]=NewItem;
<%
	}
%>
	parent.form_main1.relorgan.selectedIndex = 0;
</script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="frmRecOrgan" action="/main/MainRelOrgan.jsp" method="post">
<input type="text" name="comm" value="">
</form>
</body>
</html>
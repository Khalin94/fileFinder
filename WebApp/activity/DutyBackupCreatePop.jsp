<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>�������� ������� ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="../css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="javascript">
	function fun_backup(vaOrganId){
		document.form_main.action = "./businfo/DutyBackupCreatePopProc.jsp?organ_id=" + vaOrganId;
		document.form_main.submit();
	}
</script>
</head>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
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
		
		int iResult  = objBusInfoDelegate.insertBackup(objParamVt, "S");
		
		if(iResult ==  -1){
%>
<script language="javascript">
<!--
	alert("��������� �Ϸ翡 �ѹ��� ���� �� �ֽ��ϴ�.(�ۼ��� ������� �ֽ�)");
	self.close();
//-->
</script>

<%
		}
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="380" border="0" cellspacing="0" cellpadding="0">
<form name="form_main" method="post" action="">
  <tr class="td_mypage"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td width="386" height="25" valign="middle"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
      </span><span class="soti_mypage">�������� ������� ����</span></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
	<td width="386" height="25" valign="middle">
      ���������� ��������� �����ϴ� ������� �� �μ��� �Ϸ翡 �ѹ��� �����մϴ�.
      ��������� �����ϴ� �ð��� �ټ� �ҿ� �� �� ������, �� ȭ�鿡�� ������ ������ ����
      ������� �ٿ�ε� ȭ�鿡�� ����� ������ �ٿ� �����ñ� �ٶ��ϴ�.
    </td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="36%">&nbsp;</td>
          <td width="64%" align="right"><a href="javascript:fun_backup('<%=strOrganId%>')"><img src="../image/button/bt_create.gif" width="44" height="20" border="0"></a>&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_cancel.gif" width="43" height="20" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
  <tr align="right"> 
    <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
<%
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>
</html>

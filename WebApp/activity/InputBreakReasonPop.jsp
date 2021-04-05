<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%
	String strSystemGbn = request.getParameter("system_use_gbn")==null?"":request.getParameter("system_use_gbn");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>탈퇴 사유 입력</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="../css/System.css" rel="stylesheet" type="text/css">
</head>
<script src="/js/forum.js"></script>
<script language="javascript">
	function fun_insert(){
		if(checkStrLen(form_main.stt_chg_rsn, 500, "탈퇴사유") == false){
            form_main.stt_chg_rsn.focus();
            return;
        } 

		document.form_main.submit();
	}
</script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="./userinfo/SelectBreakReasonProc.jsp" %>
<table width="380" border="0" cellspacing="0" cellpadding="0">
<form name="form_main" method="post" action="./userinfo/UpdateBreakReasonProc.jsp" >
<input type="hidden" name="system_use_gbn" value="<%=strSystemGbn%>">
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
      </span><span class="soti_mypage">탈퇴 사유 입력</span></td>
  </tr>
  <tr> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><textarea name="stt_chg_rsn" wrap="hard" class="textfield" style="WIDTH: 96% ; height: 140"><%=strSttChgRsn%></textarea></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right"><a href="javascript:fun_insert()"><img src="../image/button/bt_save.gif" width="43" height="20" border="0"></a>&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_cancel.gif" width="43" height="20" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</table>
</form>
</body>
</html>

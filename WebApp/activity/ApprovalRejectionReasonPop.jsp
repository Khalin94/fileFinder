<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>승인 반려 사유</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="../css/System.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="forum/SelectApprovalRejectionReasonProc.jsp" %>
<table width="380" border="0" cellspacing="0" cellpadding="0">
<form name="form_main" method="post" action="./forum/UpdateUserInfoProc.jsp">
  <tr class="td_mypage">
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td width="386" height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="25" valign="middle"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
      </span><span class="soti_mypage">승인 반려 사유</span></td>
  </tr>
  <tr> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><textarea name="remark" wrap="hard" class="textfield" style="WIDTH: 96% ; height: 140"><%=strReason%></textarea></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right"><a href="javascript:self.close()"><img src="../image/button/bt_confirm.gif" width="42" height="20" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
</html>

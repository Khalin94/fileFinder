<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<html>
<head>
<title>국회 의정활동 서류제출 정보관리 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js" ></script>
</head>
<script>
function goJoinMember(frm)
{
	//var inUser = confirm('국회직원이십니까?');
	var inUser = true;

	//var inUrl = "/join/UserCheck.jsp?Agreed=Y";
	//var outUrl = "/join/PreJoinMember.jsp?Agreed=Y";



	if(inUser == true)
		frm.action="/join/UserCheck.jsp";
	else
		frm.action="/join/JoinMember.jsp";

	frm.submit();
}
</script>
<body bgcolor="F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="605" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="35" align="left" valign="top">&nbsp;</td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top"> 
          <td width="203" height="55" background="../image/join/bg_top_middle.gif"><img src="../image/join/join_logo.gif" width="203" height="55"></td>
          <td width="100%" height="55" background="../image/join/bg_top_middle.gif"></td>
          <td width="7" height="55" align="right"><img src="../image/join/bg_top_right.gif" width="7" height="55"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr valign="top">
          <td width="1" height="100" align="left" background="../image/join/bg_left.gif"><img src="../image/join/bg_left.gif" width="1" height="1"></td>
          <td width="601" bgcolor="ffffff"><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr align="left" valign="top"> 
                <td height="20">&nbsp;</td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="13%" background="../image/join/bg_join_tit.gif"><span class="title">이용약관</span></td>
                      <td width="28%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="../image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
                    </tr>
                  </table> </td>
              </tr>
              <tr> 
                <td height="15" valign="top"></td>
              </tr>
            </table> 
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr bgcolor="AED889" height="3"> 
                <td width="100%" height="2" class="td_join"></td>
              </tr>
              <tr > 
                <td height="30" valign="top"><div align="left"  class="input">
                    <table width="100%" border="0" cellpadding="0" cellspacing="15" bgcolor="F1F1F1" class="td_top">
                      <tr> 
                        <td valign="top"><iframe frameborder=0 width='100%' height='300' leftmargin='0' rightmargin='0' topmargin='0' src="Agreement_If.jsp" scrolling=auto></iframe></td>
                      </tr>
                    </table>
                  </div></td>
              </tr>
              <tr> 
                <td class="tbl-line" height="2"></td>
              </tr>
              <tr valign="middle"> 
			  <form method="post">
				<input type=hidden name=Agreed value="Y">
				<input type=hidden name=juminNo1 value="">
				<input type=hidden name=juminNo2 value="">
                <td height="40"><img src="../image/button/bt_agree.gif" width="81" height="20" onclick="goJoinMember(this.document.forms[0])" style="cursor:hand">&nbsp;<img src="../image/button/bt_dontagree.gif" width="121" height="20" onclick="window.location='/index.html'" style="cursor:hand"></td>
				</form>
              </tr>
              <tr valign="top"> 
                <td height="10">&nbsp;</td>
              </tr>
            </table></td>
          <td width="4" align="right" background="../image/join/bg_right.gif"><img src="../image/join/bg_right.gif" width="4" height="1"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top">
          <td width="140" height="42"><img src="../image/join/copyright.gif" width="258" height="42"></td>
          <td width="99%" height="42" background="../image/join/bg_bottom_middle.gif"></td>
          <td width="6" height="42" align="right"><img src="../image/join/bottom_right.gif" width="6" height="42"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="35" align="left" valign="top">&nbsp;</td>
  </tr>
</table>
</body>
</html>

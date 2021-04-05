<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>국회 의정활동 서류제출 정보관리 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/global.css" rel="stylesheet" type="text/css">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js" ></script>
<script src="/js/validate.js" ></script>

</head>


<body bgcolor="F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();">
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
              <tr valign="top"> 
                <td height="20" align="left">&nbsp;</td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="16%" background="../image/join/bg_join_tit.gif"><span class="title">사용자 
                        체크 </span></td>
                      <td width="25%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="../image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
                    </tr>
                  </table></td>
              </tr>
              <tr>
                <td height="30" align="left" class="text_s">정확한 내용을 기입해 주세요.</td>
              </tr>
              <tr> 
                <td height="10" align="left" valign="top" class="text_s"></td>
              </tr>
            </table> 
			<form action="/join/PreJoinMember.jsp" name="frmCheckUser" method="post">
			 <input type=hidden name="CERT_DN" class="textfield" >
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr valign="top" bgcolor="AED889" height="3"> 
                <td height="2"  colspan="5" class="td_join"></td>
              </tr>
              <tr> 
                <td colspan="5"> <div align="center"><img src="../image/sub_common/E7E7E7.gif" height="1"></div></td>
              </tr>
              <tr > 
                <td width="26%" height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  주민등록번호</td>
                <td width="74%" height="25" colspan="4"  class="td_lmagin" ><div align="left"> 
                    <input name="juminNo1" type="text" class="textfield" style="WIDTH: 80px" onKeyUp="return autoTab(this, 6, event);">
                    - 
                    <input name="juminNo2" type="text" class="textfield" style="WIDTH: 80px" >
					<br>
                  </div></td>
              </tr>
              <tr> 
                <td colspan="5" class="tbl-line"> <img src="../image/common/spacer.gif" width="1" height="1" border="0"></td>
              </tr>
              <tr> 
                <td colspan="5" class="tbl-line" height="2"> <img src="../image/common/spacer.gif" width="1" height="1" border="0"></td>
              </tr>
            </table>
			
		
		
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="474" height="30" align="left"><img src="../image/button/bt_ok.gif" width="43" height="20" onclick="checkCertification()" style="cursor:hand">&nbsp;<img src="../image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand" onClick="document.location='/index.html'">
				</td>
                <td width="306" height="40" align="right">&nbsp;</td>
              </tr>
              <tr>
                <td height="10" align="left"></td>
                <td height="10" align="right"></td>
              </tr>
            </table>
			</form>
			</td>
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

<script language="javascript">
var frm = document.frmCheckUser;

function init()
{
	
	// 필수입력
	define('juminNo1', 'string', '주민등록번호', 6,6);	
	define('juminNo2', 'string', '주민등록번호', 7,7);	
}

function checkCertification()
{
	
	var juminNo;
	juminNo = frm.juminNo1.value + frm.juminNo2.value

	if( OnValidationSubmit() == true   )
	{
	
		frm.method = "post";
		frm.submit();

	}


	
}

</script>

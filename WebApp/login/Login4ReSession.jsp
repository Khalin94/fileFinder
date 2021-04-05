<%
	System.out.println("idid : "+session.getAttribute("pwd"));
%>
<script language="JavaScript">
<!--
/**********************************************************
* SSO Agent가 떠있는지 확인
*   document.ISignLtw.IsRunFromReg()
*   떠있을때 1, 죽었을때 0를 Return한다.
**********************************************************/
function checkSession()
{
	//alert(document.ISignLtw.IsRunFromReg());
//	if(document.ISignLtw.IsRunFromReg() == "1") {
		//window.location = "/login/Login4ReSession.jsp";
		//떠있다면 계속 진행
//	} else {
//		window.location = "/index.html";
//	}
}
//-->

</script>

<script language="javascript" src="/js/ISignLtw.js"></script>

<script> checkSession(); </script>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script src="/js/validate.js" ></script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init()">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<form name="frmLogin" action="/login/Login4ReSessionProc.jsp" method=post onsubmit="return checkValidation(this);">
  <input type='text' name='USER_ID' style=""></input>
  <input type='password' name='PWD' style=""></input>
  <tr>
    <td align="center" valign="middle"><table width="648" height="326" border="0" cellpadding="0" cellspacing="0">
        <tr align="left" valign="top"> 
          <td height="13" colspan="2"><img src="/image/login/ing_logo.gif" width="648" height="105"></td>
        </tr>
        <tr align="left" valign="top"> 
          <td width="307" height="206"><img src="/image/login/ing_img.gif" width="307" height="206"></td>
          <td width="341" height="206" background="/image/login/ing_bg.gif"><table width="341" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="left" valign="top"><img src="/image/login/ing_ment.gif" width="341" height="114"></td>
              </tr>
              <tr>
                <td align="center" valign="top"><img src="/image/login/ing_gif.gif" width="196" height="15">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr align="left" valign="top"> 
          <td colspan="2"><img src="/image/login/ing_copyright.gif" width="648" height="61"></td>
        </tr>
      </table></td>
  </tr>
  <input type=submit name=submit value="확인" style="">
</form>
</table>
</body>
</html>

<script language="javascript">

function init()
{
	
	// 필수입력
	define('USER_ID', 'string', '이름', 1);	
	define('PWD', 'string', '패스워드', 1);	


}
function checkValidation(frm)
{

	if( OnValidationSubmit() == true)
	{
		
		return true;
		
	}else
		return false;

}

frmLogin.Submit();
</script>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>공지 사항</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/css/popupCommon.css" type="text/css">
<style type="text/css">
<!--
body {
    font: 0.75em/1.2 "돋움",Dotum,"굴림",Gulim,AppleGothic,sans-serif;
}
td  {font-size:12;color:#333333;}
.nt  {font-size:12;cursor:hand;border:0px outset;color:#253768;font-family:돋움;border-bottom-width:1px;border-bottom-style:dotted;border-color:#dddddd;height:25;padding:5 0 0 5}
-->
</style>
<script language="JavaScript"> 
// 쿠키를 만듭니다. 아래 closeWin() 함수에서 호출됩니다
function setCookie( name, value, expiredays ) 
{ 
	var todayDate = new Date(); 
	todayDate.setDate( todayDate.getDate() + expiredays ); 
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
} 

// 체크후 닫기버튼을 눌렀을때 쿠키를 만들고 창을 닫습니다
function closeWin() 
{ 
	if ( document.pop.expire.checked ){ 
		setCookie( "naps_assembly_go_kr", "done" , 1); // 오른쪽 숫자는 쿠키를 유지할 기간을 설정합니다
	}
	self.close();
} 

function openhref(pPage) {
	opener.location.href = pPage
}
</script>
</head>

<body leftmargin="0" topmargin="0">
<form name=pop>
<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0" background="/images/popup_bg_02.jpg">
<tr><td>
<table width="100%" height="100%" cellspacing="20" cellpadding="0" border="0">
<tr>
    <td>
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
		<tr>
		    <td width="15" height="15"><img src="/images/popup_01.gif" width="15" height="15" border="0" alt=""></td>
		    <td background="/images/popup_02.gif"></td>
		    <td width="15"><img src="/images/popup_03.gif" width="15" height="15" border="0" alt=""></td>
		</tr>
		<tr>
		    <td background="/images/popup_04.gif"></td>
		    <td bgcolor="White" valign="top">
			
				<table width="100%" cellspacing="10" cellpadding="0" border="0">
				<tr>
				    <td>
						<table cellspacing="0" cellpadding="0" border="0">
						<tr>
						    <td width="4" bgcolor="F9B000"></td>
						    <td width="5"></td>
						    <td valign="bottom"><font color="006666"><b>의정자료전자유통시스템 서비스 일시 중단 안내</b></font></td>
						</tr>
						</table>
		
					</td>
				</tr>
				<tr>
				    <td height="1" bgcolor="D5D5D5"></td>
				</tr>
				<tr>
				    <td valign="top">국회사무처 정전에 따라 의정자료전자유통시스템 서비스가 일시 중지되오니 업무에 참고하시기 바랍니다. 
<br>
<br>
<br>● 일시 : 2018. 1. 27.(토) 00:00 ~ 27.(토) 17:00
<br>
<br>● 국회사무처 입법정보화담당관실(02-788-3881, 3882)
					</td>
				</tr>
				</table>
		
			</td>
		    <td background="/images/popup_05.gif"></td>
		</tr>
		<tr>
		    <td height="15"><img src="/images/popup_06.gif" width="15" height="15" border="0" alt=""></td>
		    <td background="/images/popup_07.gif"></td>
		    <td width="15"><img src="/images/popup_08.gif" width="15" height="15" border="0" alt=""></td>
		</tr>
		<tr>
			<td colspan="3">
                <p align="center">오늘하루 띄우지 않음<input type=checkbox name="expire" value="" OnClick="javascript:history.onclick=closeWin()">
				<a href="javascript:closeWin();"> 닫기 </a></p>
            </td>
        </tr>
		</table>
	</td>
</tr>
</table>
</td></tr>
</table>
</form>
</body>
</html>

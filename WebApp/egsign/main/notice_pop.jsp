<%@ page language="java" contentType="text/html;charset=euc-kr" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>���� ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/css/popupCommon.css" type="text/css">
<style type="text/css">
<!--
body {
    font: 0.75em/1.2 "����",Dotum,"����",Gulim,AppleGothic,sans-serif;
}
td  {font-size:12;color:#333333;}
.nt  {font-size:12;cursor:hand;border:0px outset;color:#253768;font-family:����;border-bottom-width:1px;border-bottom-style:dotted;border-color:#dddddd;height:25;padding:5 0 0 5}
-->
</style>
<script language="JavaScript"> 
// ��Ű�� ����ϴ�. �Ʒ� closeWin() �Լ����� ȣ��˴ϴ�
function setCookie( name, value, expiredays ) 
{ 
	var todayDate = new Date(); 
	todayDate.setDate( todayDate.getDate() + expiredays ); 
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
} 

// üũ�� �ݱ��ư�� �������� ��Ű�� ����� â�� �ݽ��ϴ�
function closeWin() 
{ 
	if ( document.pop.expire.checked ){ 
		setCookie( "naps_assembly_go_kr", "done" , 1); // ������ ���ڴ� ��Ű�� ������ �Ⱓ�� �����մϴ�
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
						    <td valign="bottom"><font color="006666"><b>�����ڷ���������ý��� ���� �Ͻ� �ߴ� �ȳ�</b></font></td>
						</tr>
						</table>
		
					</td>
				</tr>
				<tr>
				    <td height="1" bgcolor="D5D5D5"></td>
				</tr>
				<tr>
				    <td valign="top">��ȸ�繫ó ������ ���� �����ڷ���������ý��� ���񽺰� �Ͻ� �����ǿ��� ������ �����Ͻñ� �ٶ��ϴ�. 
<br>
<br>
<br>�� �Ͻ� : 2018. 1. 27.(��) 00:00 ~ 27.(��) 17:00
<br>
<br>�� ��ȸ�繫ó �Թ�����ȭ������(02-788-3881, 3882)
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
                <p align="center">�����Ϸ� ����� ����<input type=checkbox name="expire" value="" OnClick="javascript:history.onclick=closeWin()">
				<a href="javascript:closeWin();"> �ݱ� </a></p>
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

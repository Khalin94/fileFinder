<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%

	String strPopUpId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("PopUpId"));


	if(strPopUpId == null || strPopUpId.equals(""))
	{
		return;
	}

%>


<html>

<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href='../css/System.css' rel='stylesheet' type='text/css'>



<script language="javascript">
<!--


function setCookie(name, value, expiredays)
{ 
	var todayDate = new Date(); 
	todayDate.setDate( todayDate.getDate() + expiredays ); 
	document.cookie = name + '=' + escape( value ) + '; path=/; expires=' + todayDate.toGMTString() + ';' 
} 
	 
function closeWin()
{ 
	if(document.frm.chkClose.checked)
	{ 
		setCookie('<%=strPopUpId%>', 'Y' , 1); 
	} 
	
	parent.close(); 
}


//-->
</script>

</head>

<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>



<table width='100%' height='40' bgcolor='#F5F5F5' border='0' cellspacing="0" cellpadding="0">
	<form name='frm'>
		<tr height='40' valign='center'>

			<td>
				<div align='right'>
					<input type='checkbox' name='chkClose' value=''  onClick='javascript:closeWin();'>
					<font color='#330000'>오늘 하루 이 창 닫기</font>&nbsp;&nbsp;
				</div>
			</td>
		</tr>
	</form>
</table>


</body>


</html>

<html>
<head>
<title>메신저 로그인</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">


<script language="javascript">
<!--

var objHTTP;

function Login()
{		
	try
	{
		if(objHTTP == null)
		{
			objHTTP = new ActiveXObject("Microsoft.XMLHTTP");		

		}

		objHTTP.Open('GET','/messenger/GetUserInfo.jsp', false);
		objHTTP.Send();

		var strResult = objHTTP.responseText;
		
		opener.MessengerAgent.LogIn(strResult);			
	}
	catch(err)
	{		
	}	

	self.close();
}

function Logout()
{
     opener.MessengerAgent.LogOut();     
}

function Exit()
{
     opener.MessengerAgent.Exit();
}
-->
</script>

<link href="/css/System.css" rel="stylesheet" type="text/css">
<link href="/css/Main.css" rel="stylesheet" type="text/css">

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="javascript:Login();">

</body>
</html>

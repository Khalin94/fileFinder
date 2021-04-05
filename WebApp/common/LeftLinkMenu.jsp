<%
			String strLeftLocalMsgOpenGbn = (String)session.getAttribute("MSG_OPEN_GBN");
		%>
	    <script language="javascript" src="/js/MessengerAgent.js"></script>
		<%
			if(strLeftLocalMsgOpenGbn.equals("N")){    //로그인 시만 메신저 다운메시지를 띠운다.(06.04)
		%>          
        <SCRIPT for="MessengerAgent" event="OnMessengerInstall()" language="javascript">
			window.open('/main/DownMsger_Pop.jsp','MsgerDown','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=286,height=211,left=0,top=0');
		</SCRIPT>
		<%
				session.setAttribute("MSG_OPEN_GBN","Y");
			}
		%>
		<div align="left">
		<script language="javascript">
			function Login(vaGubn) {
				if(vaGubn == 'N'){
					window.open("/common/LogInMessenger.jsp", "LogInMessenger", "status=no,resizable=no,menubar=no,scrollbars=no,width=1, height=1, left=99999, top=99999");
				}
			}
		</script>
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="left" height="35">&nbsp;&nbsp;<a href="javascript:fun_bottomhomepage('http://www.assembly.go.kr:8000/cal/html/index.html','의사일정')" onfocus="this.blur()"><img src="/image/common/ban_agenda.gif" border="0"></a></td>
			</tr>
			<tr>
				<td align="left" height="35">&nbsp;&nbsp;<a href="javascript:Login('N')" onfocus="this.blur()"><img src="/image/common/ban_messenger.gif" border="0"></a></td>
			</tr>
		</table>
		</div>
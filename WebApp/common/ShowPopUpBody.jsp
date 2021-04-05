<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%

	String strForm = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("Form"));
	
	if(strForm == null || strForm.equals(""))
	{
		return;
	}	
	
	
%>

<html>
<head>
<title></title>
</head>
<body CONTENTEDITABLE="false">
<script language="javascript">
<!--

	document.write("<link href='../css/System.css' rel='stylesheet' type='text/css'>");
	document.write(parent.opener.<%=strForm%>.strCont.value);
	document.write("<link href='../css/System.css' rel='stylesheet' type='text/css'>");

//-->
</script>

<table width='100%' height='40' border='0' cellspacing="0" cellpadding="0">
		<tr height='40' valign='center'>

			<td>
				<div align='left'>
				<script language="javascript">					
					if(parent.opener.document.forms[1].linkfilename.value != ""){
						document.write("&nbsp;&nbsp;&nbsp;Ã·ºÎÆÄÀÏ : <a href=");
						document.write(parent.opener.document.forms[1].linkurl.value);
						document.write(">");
						document.write(parent.opener.document.forms[1].linkfilename.value);
						document.write("</a>");
					}					
				</script>
				</div>
			</td>

		</tr>
</table>

</body>
</html>
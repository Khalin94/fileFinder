<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<body>
<h3>������� �׽�Ʈ.</h3>
<form name="formName" method="post" action="./PuzanglimTestFormProc.jsp">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>�Է°�</td>
		<td><input type="text" name="TestInput"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="submit" value="������"></td>
	</tr>
</table>
</form>
<table><tr><td>
<%=nads.lib.reqsubmit.util.ErrorPageUtil.reportHeaders(request)%>
</td></tr></table>

</body>
</html>              

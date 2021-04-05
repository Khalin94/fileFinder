<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<body>
<h3>구부장님 테스트.</h3>
<form name="formName" method="post" action="./PuzanglimTestFormProc.jsp">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>입력값</td>
		<td><input type="text" name="TestInput"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="submit" value="보내기"></td>
	</tr>
</table>
</form>
<table><tr><td>
<%=nads.lib.reqsubmit.util.ErrorPageUtil.reportHeaders(request)%>
</td></tr></table>

</body>
</html>              

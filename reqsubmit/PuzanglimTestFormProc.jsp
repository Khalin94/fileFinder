<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%
  String strMessage="����";
  String strUserNm=(String)request.getSession().getAttribute("USER_NM");
  if(strUserNm==null || strUserNm.length()<1){
  	strMessage="����";
  }
  String strUserID=(String)request.getSession().getAttribute("USER_ID");
  String strTestData=request.getParameter("TestInput");
  
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<body>
<h3>������� �׽�Ʈ ���Ȯ��</h3>
<form name="formName" method="post" action="./PuzanglimTestFormProc.jsp">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>���:</td>
		<td><%=strMessage%></td>
	</tr>
	<%
	if(strMessage.equals("����")){
	%>
	<tr>
		<td>�Է°�:</td>
		<td><%=strTestData%></td>
	</tr>
	<tr>
		<td>�̿���:</td>
		<td><%=strUserNm + "(" + strUserID + ")" %></td>
	</tr>
	<%
	 }//endif
	%>
	<tr><td>
	<%=nads.lib.reqsubmit.util.ErrorPageUtil.reportHeaders(request)%>
	</td></tr>
</table>
</form>
</body>
</html>              

<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%
  String strMessage="성공";
  String strUserNm=(String)request.getSession().getAttribute("USER_NM");
  if(strUserNm==null || strUserNm.length()<1){
  	strMessage="실패";
  }
  String strUserID=(String)request.getSession().getAttribute("USER_ID");
  String strTestData=request.getParameter("TestInput");
  
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<body>
<h3>구부장님 테스트 결과확인</h3>
<form name="formName" method="post" action="./PuzanglimTestFormProc.jsp">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>결과:</td>
		<td><%=strMessage%></td>
	</tr>
	<%
	if(strMessage.equals("성공")){
	%>
	<tr>
		<td>입력값:</td>
		<td><%=strTestData%></td>
	</tr>
	<tr>
		<td>이용자:</td>
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

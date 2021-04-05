<%@ page language="java" contentType="application/vnd.ms-excel;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
	response.setHeader("Content-Disposition", "Statistics;filename=SelectSystem_GovDataBox_Excel.xls");
	response.setHeader("Content-Description", "SelectSystem_GovDataBox_Excel");
%>

<%
     //��Delegate �����
     MainStaticsDelegate objStatics = new  MainStaticsDelegate();     
  	 
   	 String AUDIT_YEAR = request.getParameter("strYear");
     String RLTD_GBN =request.getParameter("strRltd_cd");     
     
//   	 String AUDIT_YEAR = "2004";
//     String RLTD_GBN = "001";
  	 
     ArrayList objGovList = new ArrayList();
     try {
		objGovList = objStatics.select_GovBox_Sys(AUDIT_YEAR,RLTD_GBN);
		
		} catch (AppException objAppEx) {
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
		out.println(objAppEx.getStrErrCode());
		out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.");
		return;
	}
%>

<html>
<title>�����ڷ� �������� �����ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
	<table border="0" cellspacing="0" cellpadding="0">
		<tr align="center">
			<td colspan="3"><%=AUDIT_YEAR%>��  ���������ڷ��� </td>
		</tr>
   	</table>
   	<br>
 	<table border="1" cellspacing="0" cellpadding="0">          
		<tr>
		    <td>������</td>
		    <td>�� ����Ǽ�</td>
		    <td>���뿬��Ǽ�</td>
		</tr>              
<%
	for (int i = 0; i < objGovList.size(); i++) {
		Hashtable objHGovList = (Hashtable)objGovList.get(i);
%>
		<tr>
			<td>&nbsp;<%=objHGovList.get("ORGAN_NM")%></td>
			<td>&nbsp;<%=objHGovList.get("SEND_CNT")%></td>
			<td>&nbsp;<%=objHGovList.get("CONN_CNT")%></td>					
		</tr>
<%}%>          
      </table>
</body>
</html>

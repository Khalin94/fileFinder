<%@ page language="java" contentType="application/vnd.ms-excel;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
	response.setHeader("Content-Disposition", "Statistics;filename=SelectSystem_Organ_Excel.xls");
	response.setHeader("Content-Description", "SelectSystem_Organ_Excel");
%>


<%
     //��Delegate �����
     MainStaticsDelegate objStatics = new  MainStaticsDelegate();
     
   	 String AUDIT_YEAR = request.getParameter("strYear");
     String RLTD_GBN =request.getParameter("strRltd_cd");
     String COMM_GBN =request.getParameter("strComm_cd");
               
//   	 String AUDIT_YEAR = "2004"; 
//     String RLTD_GBN = "001"; 
//     String COMM_GBN = "TE00000001";
     
     ArrayList objCommList = new ArrayList();
     try {
		objCommList = objStatics.select_Organ_Sys(AUDIT_YEAR, RLTD_GBN, COMM_GBN);
		
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
			<td colspan="6"><%=AUDIT_YEAR%>�� �Ҽ� ����� �䱸/���� ��Ȳ </td>
		</tr>
   	</table>
   	<br>
	<table border="1" cellspacing="0" cellpadding="0">   	
		<tr align="center">
		    <td rowspan="2" bgcolor="#EFEFEF">����ȸ��</td>
		    <td rowspan="2" bgcolor="#EFEFEF">�� �䱸�Ǽ�</td>
		    <td colspan="4" bgcolor="#EFEFEF">�������</td>
		</tr>
		<tr align="center">
		    <td bgcolor="#EFEFEF">���ڹ���</td>
		    <td bgcolor="#EFEFEF">�����ڹ���</td>
		    <td bgcolor="#EFEFEF">�ش����ƴ�</td>
		    <td bgcolor="#EFEFEF">��</td>
		</tr>   		         
<%
	for (int i = 0; i < objCommList.size(); i++) {
		Hashtable objHCommList = (Hashtable)objCommList.get(i);
%>
		<tr>
			<td>&nbsp;<%=objHCommList.get("ORGAN_NM")%></td>
			<td align="left">&nbsp;<%=objHCommList.get("REQ_TOT")%></td>
			<td align="left">&nbsp;<%=objHCommList.get("SYS_SEND_CNT")%></td>
			<td align="left">&nbsp;<%=objHCommList.get("NON_SYS_SEND_CNT")%></td>
			<td align="left">&nbsp;<%=objHCommList.get("NOT_REQ")%></td>
			<td align="left">&nbsp;<%=objHCommList.get("SENT_TOT")%></td>
		</tr>
<%}%>          
      </table>
</body>
</html>


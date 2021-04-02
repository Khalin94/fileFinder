<%@ page language="java" contentType="application/vnd.ms-excel;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.excel.ExcelDownload" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
	response.setHeader("Content-Disposition", "Statistics;filename=SelectAudit_Organ_ExcelSt.xls");
	response.setHeader("Content-Description", "SelectAudit_Organ_ExcelSt");
%>


<%
     //��Delegate �����
     MainStaticsDelegate objStatics = new  MainStaticsDelegate();
     
   	 String AUDIT_YEAR = StringUtil.getNVLNULL(request.getParameter("strYear"));
     String RLTD_GBN = StringUtil.getNVLNULL(request.getParameter("strRltd_cd")); 
     String COMM_GBN = StringUtil.getNVLNULL(request.getParameter("strComm_cd"));
     
     ArrayList objCommList = new ArrayList();
     try {
		objCommList = objStatics.select_Organ_Sys_Audit(AUDIT_YEAR, RLTD_GBN, COMM_GBN);
//		objCommList = objStatics.select_Organ_Sys_Audit("2004", "001", "TE00000001");
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
			<td colspan="6"><%=AUDIT_YEAR%>��  �Ҽ� ����� �䱸 ��Ȳ </td>
		</tr>
   	</table>
   	<br>
 	<table border="1" cellspacing="0" cellpadding="0">          
			<tr align="center">
			  <td width="23%" height="25" class="td0_2"  rowspan="2">�����</td>			
			  <td width="35%" height="25" class="td0_2"  colspan="3">���簳����</td>
			  <td width="35%" height="25" class="td0_2"  colspan="3">���簳����</td>
			  <td width="7%" height="25" class="td0_2"  rowspan="2">�Ѱ�</td>
			</tr>
			<tr align="center">
			  <td width="15%" height="25" class="td0_2" >����ȸ�������</td>
			  <td width="15%" height="25" class="td0_2" >��ȸ�ǽ��α��</td>
			  <td width="5%" height="25" class="td0_2" >�Ұ�</td>
			  <td width="15%" height="25" class="td0_2" >����ȸ�������</td>
			  <td width="15%" height="25" class="td0_2" >��ȸ�ǽ��α��</td>
			  <td width="5%" height="25" class="td0_2" >�Ұ�</td>
			</tr>         	            
<%
	for (int i = 0; i < objCommList.size(); i++) {
		Hashtable objHCommList = (Hashtable)objCommList.get(i);
%>
			<tr align="center">
				<td height="20" bgcolor="FFFFFF" class="td0_1">&nbsp;<%=objHCommList.get("A0")%></td>
				<td height="20" bgcolor="ffffff">&nbsp;<%=objHCommList.get("A1")%></td>
				<td height="20" bgcolor="ffffff">&nbsp;<%=objHCommList.get("A2")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("SUM1")%></td>
				<td height="20" bgcolor="ffffff">&nbsp;<%=objHCommList.get("A3")%></td>
				<td height="20" bgcolor="ffffff">&nbsp;<%=objHCommList.get("A4")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("SUM2")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("TOTAL")%></td>				
			</tr>
<%}%>          
      </table>
</body>
</html>
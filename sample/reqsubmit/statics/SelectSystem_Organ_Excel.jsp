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
     //※Delegate 선언※
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
		
		// 에러 발생 메세지 페이지로 이동한다.
		out.println(objAppEx.getStrErrCode());
		out.println("메세지 페이지로 이동하여야 한다.");
		return;
	}
%>

<html>
<title>의정자료 전자유통 지원시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
	<table border="0" cellspacing="0" cellpadding="0">
		<tr align="center">
			<td colspan="6"><%=AUDIT_YEAR%>년 소속 기관별 요구/제출 현황 </td>
		</tr>
   	</table>
   	<br>
	<table border="1" cellspacing="0" cellpadding="0">   	
		<tr align="center">
		    <td rowspan="2" bgcolor="#EFEFEF">위원회명</td>
		    <td rowspan="2" bgcolor="#EFEFEF">총 요구건수</td>
		    <td colspan="4" bgcolor="#EFEFEF">제출상태</td>
		</tr>
		<tr align="center">
		    <td bgcolor="#EFEFEF">전자문서</td>
		    <td bgcolor="#EFEFEF">비전자문서</td>
		    <td bgcolor="#EFEFEF">해당기관아님</td>
		    <td bgcolor="#EFEFEF">계</td>
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


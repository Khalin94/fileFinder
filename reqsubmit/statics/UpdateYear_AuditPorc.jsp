<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//����
	
	//���� �������� ������ ��.
	String strYearNew =StringUtil.getNVLNULL(request.getParameter("strNew"));					//�⵵
	String strYearStart =StringUtil.getNVLNULL(request.getParameter("strStart"));					//������
	String strYearEnd  =StringUtil.getNVLNULL(request.getParameter("strEnd"));					//������	
	
    strYearStart = strYearStart.substring(0, 4) + "" + strYearStart.substring(5, 7) + "" + strYearStart.substring(8, 10);
    strYearEnd = strYearEnd.substring(0, 4) + "" + strYearEnd.substring(5, 7) + "" + strYearEnd.substring(8, 10);	
    
//	out.print("strCmd : " + strCmd + "<br>");
//	out.print("strYearNew : " + strYearNew + "<br>");
//	out.print("strYearStart : " + strYearStart + "<br>");
//	out.print("strYearEnd : " + strYearEnd + "<br>");
	
	//��Delegate �����.	
    MainStaticsDelegate objStatics = new  MainStaticsDelegate();	
    
	//�Է��� ����Ÿ�� HashTable ���� 
	Hashtable objHashData = new Hashtable();
	int intResult = 0;

	if(strCmd.equals("Update")){
//		out.println("����<br>");
		
		objHashData.put("AUDIT_YEAR", strYearNew);
		objHashData.put("START_DT", strYearStart);
		objHashData.put("END_DT", strYearEnd);
		
		try {
			intResult = objStatics.Update_Year_Audit(objHashData);	
		} catch (AppException objAppEx) {
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
			return;
		
		}
		
//		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
//			out.println("���� ����<br>");
		}
	}
	response.sendRedirect("SelectYear_Audit.jsp");
%>

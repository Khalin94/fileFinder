<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>

<%
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));							//����
	
	//���� �������� ������ ��.
	String strstrYear =StringUtil.getNVLNULL(request.getParameter("strYear"));					//�⵵
	
//	out.print("strCmd : " + strCmd + "<br>");
//	out.print("strstrYear : " + strstrYear + "<br>");
	
	//��Delegate �����.	
    MainStaticsDelegate objStatics = new  MainStaticsDelegate();	
    
	//�Է��� ����Ÿ�� HashTable ���� 
	Hashtable objHashData = new Hashtable();
	int intResult = 0;

	if(strCmd.equals("Delete")){
//		out.println("����<br>");
		
		objHashData.put("AUDIT_YEAR", strstrYear);
		
		try {
			intResult = objStatics.Delete_Year_Audit(objHashData);
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

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>

<%
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));							//구분
	
	//추후 세션으로 변경할 값.
	String strstrYear =StringUtil.getNVLNULL(request.getParameter("strYear"));					//년도
	
//	out.print("strCmd : " + strCmd + "<br>");
//	out.print("strstrYear : " + strstrYear + "<br>");
	
	//※Delegate 선언※.	
    MainStaticsDelegate objStatics = new  MainStaticsDelegate();	
    
	//입력할 데이타를 HashTable 생성 
	Hashtable objHashData = new Hashtable();
	int intResult = 0;

	if(strCmd.equals("Delete")){
//		out.println("삭제<br>");
		
		objHashData.put("AUDIT_YEAR", strstrYear);
		
		try {
			intResult = objStatics.Delete_Year_Audit(objHashData);
		} catch (AppException objAppEx) {
		
			// 에러 발생 메세지 페이지로 이동한다.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("메세지 페이지로 이동하여야 한다.<br>");
			return;
		
		}
		
//		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
//			out.println("생성 성공<br>");
		}
	}
	
	response.sendRedirect("SelectYear_Audit.jsp");
%>

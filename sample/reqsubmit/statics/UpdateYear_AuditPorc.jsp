<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//구분
	
	//추후 세션으로 변경할 값.
	String strYearNew =StringUtil.getNVLNULL(request.getParameter("strNew"));					//년도
	String strYearStart =StringUtil.getNVLNULL(request.getParameter("strStart"));					//시작일
	String strYearEnd  =StringUtil.getNVLNULL(request.getParameter("strEnd"));					//종료일	
	
    strYearStart = strYearStart.substring(0, 4) + "" + strYearStart.substring(5, 7) + "" + strYearStart.substring(8, 10);
    strYearEnd = strYearEnd.substring(0, 4) + "" + strYearEnd.substring(5, 7) + "" + strYearEnd.substring(8, 10);	
    
//	out.print("strCmd : " + strCmd + "<br>");
//	out.print("strYearNew : " + strYearNew + "<br>");
//	out.print("strYearStart : " + strYearStart + "<br>");
//	out.print("strYearEnd : " + strYearEnd + "<br>");
	
	//※Delegate 선언※.	
    MainStaticsDelegate objStatics = new  MainStaticsDelegate();	
    
	//입력할 데이타를 HashTable 생성 
	Hashtable objHashData = new Hashtable();
	int intResult = 0;

	if(strCmd.equals("Update")){
//		out.println("수정<br>");
		
		objHashData.put("AUDIT_YEAR", strYearNew);
		objHashData.put("START_DT", strYearStart);
		objHashData.put("END_DT", strYearEnd);
		
		try {
			intResult = objStatics.Update_Year_Audit(objHashData);	
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

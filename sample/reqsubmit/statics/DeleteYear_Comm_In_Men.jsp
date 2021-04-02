<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//구분
	
	//추후 세션으로 변경할 값.
	String strCommCd  = StringUtil.getNVLNULL(request.getParameter("strComm_cd"));		//위원회 ID
	String strMenCd  = StringUtil.getNVLNULL(request.getParameter("strMen_cd"));		    //의원실 ID
	String stryearCd =StringUtil.getNVLNULL(request.getParameter("strYear"));					//년도
	String strCombo =StringUtil.getNVLNULL(request.getParameter("strCombo"));				//현재콤보값
		
//	out.print("strCmd : " + strCmd + "<br>");
//	out.print("strCommCd : " + strCommCd + "<br>");
//	out.print("strMenCd : " + strMenCd + "<br>");
//	out.print("stryearCd : " + stryearCd + "<br>");
	
	//※Delegate 선언※.
	
    MainStaticsDelegate objStatics = new  MainStaticsDelegate();	

	//입력할 데이타를 HashTable 생성 
	Hashtable objHashData = new Hashtable();
	int intResult = 0;


	if(strCmd.equals("Del")){
//		out.println("삭제<br>");
		
		objHashData.put("REL_ORGAN_ID", strCommCd);
		objHashData.put("ORGAN_ID", strMenCd);
		objHashData.put("AUDIT_YEAR", stryearCd);
				
		try {
			intResult = objStatics.Delete_CommInMen(objHashData);	
		} catch (AppException objAppEx) {
		
			// 에러 발생 메세지 페이지로 이동한다.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("메세지 페이지로 이동하여야 한다.<br>");
			return;
		
		}
		
//		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
//			out.println("생성 성공<br>");
//			response.sendRedirect("SelectYear_Comm_In_Mem.jsp?year_cd=" + stryearCd +"&Comm_cd="+strCommCd);
//			response.sendRedirect("SelectYear_Comm_In_Mem.jsp");
		}
	}
	
%>

<form name=form1 method=post action=SelectYear_Comm_In_Mem.jsp>
<input type="hidden" name="year_cd" value="<%=stryearCd%>">
<input type="hidden" name="Comm_cd" value="<%=strCombo%>">
</form>
<script language="javascript">
  document.form1.submit();
</script>

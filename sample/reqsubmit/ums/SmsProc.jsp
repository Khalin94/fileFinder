<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%

	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//구분
	
	//추후 세션으로 변경할 값.
	String strSendPhoneNo   = StringUtil.getNVLNULL(request.getParameter("sendphoneno"));   //전송번호
	String strReturnNo           = StringUtil.getNVLNULL(request.getParameter("returnno")); 		    //회신번호
	String strSendStatus        = StringUtil.getNVLNULL(request.getParameter("sendstatus")); 		//전송상태
	String strSmsMsg 	       = StringUtil.getNVLNULL(request.getParameter("smsmsg"));	    	//메시지
	String strSystemGbn       = StringUtil.getNVLNULL(request.getParameter("systemgbn"));		//시스템구분
	String strServiceGbn       = StringUtil.getNVLNULL(request.getParameter("servicegbn")); 		//서비스구분
	String strDeptGbn            = StringUtil.getNVLNULL(request.getParameter("deptgbn")); 			//부서ID
	String strDeptNm             = StringUtil.getNVLNULL(request.getParameter("deptgnm")); 			//부서명
	String strUserID               = StringUtil.getNVLNULL(request.getParameter("userid")); 			    //사용자ID
	String strUserNm              = StringUtil.getNVLNULL(request.getParameter("usernm")); 			    //사용자Nm
//	String strOffiDocID           = StringUtil.getNVLNULL(request.getParameter("offidocid")); 			//공문ID
//	String strInOutGbn           = StringUtil.getNVLNULL(request.getParameter("inoutgbn")); 			//내외구분
	
	out.print("strSendPhoneNo : " + strSendPhoneNo + "<br>");
	out.print("strReturnNo : " + strReturnNo + "<br>");
	out.print("strSendStatus : " + strSendStatus + "<br>");
	out.print("strSmsMsg : " + strSmsMsg + "<br>");
	out.print("strSystemGbn : " + strSystemGbn + "<br>");
	out.print("strServiceGbn : " + strServiceGbn + "<br>");
	out.print("strDeptGbn : " + strDeptGbn + "<br>");
	out.print("strUserID : " + strUserID + "<br>");
//	out.print("strOffiDocID : " + strOffiDocID + "<br>");
//	out.print("strInOutGbn : " + strInOutGbn + "<br>");
	
	
	//※Delegate 선언※. 	 
    nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsInfo = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();
    
	//입력할 데이타를 HashTable 생성
	Hashtable objHashData = new Hashtable();
	int intResult = 0;
    
	if(strCmd.equals("create")){
		out.println("생성<br>");
		
		objHashData.put("SEND_PHONE_NO", strSendPhoneNo);
		objHashData.put("RETURN_NO", strReturnNo);
		objHashData.put("SEND_STATUS", strSendStatus);
		objHashData.put("MSG", strSmsMsg);
		objHashData.put("SYSTEM_GBN", strSystemGbn);
		objHashData.put("SERVICE_GBN", strServiceGbn);
		objHashData.put("DEPT_GBN", strDeptGbn);
		objHashData.put("DEPT_NM", strDeptNm);
		objHashData.put("USER_ID", strUserID);
		objHashData.put("USER_NM", strUserNm);
//		objHashData.put("OFFI_DOC_ID", strOffiDocID);
//		objHashData.put("IN_OUT_GBN", strInOutGbn);
		
		
		try {
			intResult = objUmsInfo.insertSMS(objHashData);	
		} catch (AppException objAppEx) {
		
			// 에러 발생 메세지 페이지로 이동한다.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("메세지 페이지로 이동하여야 한다.<br>");
			return;
		}
		
		out.print("intResult : " + intResult + "번 SEQ <br>");
		
		if(intResult != 0 ){
			out.println("생성 성공<br>");
//			response.sendRedirect("SmsTest.jsp");
		}
	}
	
%>

<input type="button" value="문자전송목록" style="cursor:hand" OnClick="javascript:history.go(-1);">
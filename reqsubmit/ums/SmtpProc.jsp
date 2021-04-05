<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate"%>

<%

	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));						  //구분
	
	//추후 세션으로 변경할 값.
	String strRid    		= StringUtil.getNVLNULL(request.getParameter("rid"));	    	  		  //수신자ID
	String strRname   = StringUtil.getNVLNULL(request.getParameter("rname")); 			  	  //수신자명
	String strMail        = StringUtil.getNVLNULL(request.getParameter("rmail")); 			  	  //수신자메일주소
    
	String strSid    	  	  = StringUtil.getNVLNULL(request.getParameter("sid"));	    	 		  //발신자ID
	String strSname     = StringUtil.getNVLNULL(request.getParameter("sname")); 			  //발신자명
	String strSmail       = StringUtil.getNVLNULL(request.getParameter("smail")); 			      //발신자메일주소
	String strSubject    = StringUtil.getNVLNULL(request.getParameter("subject")); 			  //제목
	String strContents  = StringUtil.getNVLNULL(request.getParameter("contents")); 		  //내용
	String strSystemGbn       = StringUtil.getNVLNULL(request.getParameter("systemgbn"));		//시스템구분
	String strServiceGbn       = StringUtil.getNVLNULL(request.getParameter("servicegbn")); 		//서비스구분
	String strStatus               = StringUtil.getNVLNULL(request.getParameter("status")); 			//전송상태
	String strDeptGbn            = StringUtil.getNVLNULL(request.getParameter("deptgbn")); 			//부서구분
	String strDeptNm             = StringUtil.getNVLNULL(request.getParameter("deptnm")); 			//부서명
//	String strUserID               = StringUtil.getNVLNULL(request.getParameter("userid")); 			    //사용자ID
//	String strOffiDocID           = StringUtil.getNVLNULL(request.getParameter("offidocid")); 			//공문ID
//	String strInOutGbn           = StringUtil.getNVLNULL(request.getParameter("inoutgbn")); 			//내외구분
   
	out.print("strRid : " + strRid + "<br>");
	out.print("strRname : " + strRname + "<br>");
	out.print("strMail : " + strMail + "<br>");
	
	out.print("strSid : " + strSid + "<br>");
	out.print("strSname : " + strSname + "<br>");
	out.print("strSmail : " + strSmail + "<br>");
	out.print("strSubject : " + strSubject + "<br>");
	out.print("strContents : " + strContents + "<br>");
	out.print("strSystemGbn : " + strSystemGbn + "<br>");
	out.print("strServiceGbn : " + strServiceGbn + "<br>");
	out.print("strStatus : " + strStatus + "<br>");
	out.print("strDeptGbn : " + strDeptGbn + "<br>");
	out.print("strDeptNm : " + strDeptNm + "<br>");
//	out.print("strUserID : " + strUserID + "<br>");
//	out.print("strOffiDocID : " + strOffiDocID + "<br>");
//	out.print("strInOutGbn : " + strInOutGbn + "<br>");
	
	
	//※Delegate 선언※.
    UmsDelegate objUmsInfo = new  UmsDelegate();
    
	//입력할 데이타를 HashTable 생성
	Hashtable objHashData = new Hashtable();
	int intResult = 0;
    
	if(strCmd.equals("create")){
		out.println("생성<br>");
		
		objHashData.put("RID", strRid);
		objHashData.put("RNAME", strRname);
		objHashData.put("RMAIL", strMail);
		
		objHashData.put("SID", strSid);
		objHashData.put("SNAME", strSname);
		objHashData.put("SMAIL", strSmail);
		objHashData.put("SUBJECT", strSubject);
		objHashData.put("CONTENTS", strContents);
		objHashData.put("SYSTEM_GBN", strSystemGbn);
		objHashData.put("SERVICE_GBN", strServiceGbn);
		objHashData.put("STATUS", strStatus);		
		objHashData.put("DEPT_GBN", strDeptGbn);
		objHashData.put("DEPT_NM", strDeptNm);
//		objHashData.put("USER_ID", strUserID);
//		objHashData.put("OFFI_DOC_ID", strOffiDocID);
//		objHashData.put("IN_OUT_GBN", strInOutGbn);
	    
		try {
			intResult = objUmsInfo.insertSMTP_REC(objHashData);
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
	
	
	
	if(strCmd.equals("create2")){
		out.println("생성<br>");
		
		objHashData.put("SID", strSid);
		objHashData.put("SNAME", strSname);
		objHashData.put("SMAIL", strSmail);
		objHashData.put("SUBJECT", strSubject);
		objHashData.put("CONTENTS", strContents);
		
		
		try {
			intResult = objUmsInfo.insertSMTP_MAI(objHashData);
		} catch (AppException objAppEx) {
		
			// 에러 발생 메세지 페이지로 이동한다.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("메세지 페이지로 이동하여야 한다.<br>");
			return;
		}
		
		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
			out.println("생성 성공<br>");
//			response.sendRedirect("SmsTest.jsp");
		}
	}
	
	
%>

<input type="button" value="문자전송목록" style="cursor:hand" OnClick="javascript:history.go(-1);">
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>

 
<%
	ResultSetHelper UserRS = null;

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
	String strStatus               = StringUtil.getNVLNULL(request.getParameter("status")); 				//전송상태
	String strDeptGbn            = StringUtil.getNVLNULL(request.getParameter("deptgbn")); 			//부서구분
	String strDeptNm             = StringUtil.getNVLNULL(request.getParameter("deptnm")); 			//부서명
	String strUserSttCd           = StringUtil.getNVLNULL(request.getParameter("stt_cd"));
    String webURL = ""; //http 주소
	
	//strContents = "http://naps.assembly.go.kr/newsletter/SendAllDoc.jsp?reqtitle="+strContents;
	
	//※Delegate 선언※.
    nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsInfo = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();
    UserRS =  new ResultSetHelper((List)objUmsInfo.getSUserInfo(strUserSttCd));

	//입력할 데이타를 HashTable 생성
	Hashtable objHashData = null;
	
	int intResult = 0;
    
	if(strCmd.equals("create")){
		while(UserRS.next()){
			objHashData = new Hashtable();
			System.out.println("111");
			strRid = (String)UserRS.getObject("USER_ID");
			strRname = (String)UserRS.getObject("USER_NM");
			strMail = (String)UserRS.getObject("EMAIL");

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
			
			try {
				intResult = objUmsInfo.insertSMTP_WEB_REC(objHashData);
			} catch (AppException objAppEx) {
			
				// 에러 발생 메세지 페이지로 이동한다.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("메세지 페이지로 이동하여야 한다.<br>");
				return;
			}							
		}
	}
	
%>

<input type="button" value="웹컨텐츠 메일" style="cursor:hand" OnClick="javascript:history.go(-1);">
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>


<%
	ResultSetHelper UserRS = null;
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//구분
	
	//추후 세션으로 변경할 값.
	String strSendPhoneNo   = "";   //전송번호
	String strReturnNo           = StringUtil.getNVLNULL(request.getParameter("returnno")); 		    //회신번호
	String strSendStatus        = StringUtil.getNVLNULL(request.getParameter("sendstatus")); 		//전송상태
	String strSmsMsg 	       = StringUtil.getNVLNULL(request.getParameter("smsmsg"));	    	//메시지
	String strSystemGbn       = StringUtil.getNVLNULL(request.getParameter("systemgbn"));		//시스템구분
	String strServiceGbn       = StringUtil.getNVLNULL(request.getParameter("servicegbn")); 		//서비스구분
	String strUserID               = StringUtil.getNVLNULL(request.getParameter("userid")); 			    //사용자ID
	String strUserNm              = StringUtil.getNVLNULL(request.getParameter("usernm")); 			    //사용자Nm
	String strUserSttCd           = StringUtil.getNVLNULL(request.getParameter("stt_cd"));
	
	
	
	//※Delegate 선언※. 	 
    nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsInfo = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();
    UserRS =  new ResultSetHelper(objUmsInfo.getSUserInfo(strUserSttCd));
	//입력할 데이타를 HashTable 생성
	Hashtable objHashData = null;
	int intResult = 0;
    
	if(strCmd.equals("create")){
		while(UserRS.next()){
			objHashData = new Hashtable();
			strSendPhoneNo = ((String)UserRS.getObject("CPHONE")).replaceAll("-","");
			objHashData.put("SEND_PHONE_NO", strSendPhoneNo);
			objHashData.put("RETURN_NO", strReturnNo);
			objHashData.put("SEND_STATUS", strSendStatus);
			objHashData.put("MSG", strSmsMsg);
			objHashData.put("SYSTEM_GBN", strSystemGbn);
			objHashData.put("SERVICE_GBN", strServiceGbn);
			objHashData.put("DEPT_GBN", "");
			objHashData.put("DEPT_NM", "");
			objHashData.put("USER_ID", strUserID);
			objHashData.put("USER_NM", strUserNm);
			
			
			try {
				intResult = objUmsInfo.insertSMS(objHashData);	
			} catch (AppException objAppEx) {
			
				// 에러 발생 메세지 페이지로 이동한다.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("메세지 페이지로 이동하여야 한다.<br>");
				return;
			}
		}		
	}
	
%>

<input type="button" value="문자전송목록" style="cursor:hand" OnClick="javascript:history.go(-1);">
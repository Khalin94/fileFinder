<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate"%>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	boolean sFlag = true;
	
	String strSystemid = StringUtil.getNVLNULL(request.getParameter("systemid"));         //시스템ID
	String strBusinessid = StringUtil.getNVLNULL(request.getParameter("businessid"));  //업무ID
	String strDocid = StringUtil.getNVLNULL(request.getParameter("docid"));					//결재문서ID	
	String strLegacyin = StringUtil.getNVLNULL(request.getParameter("legacyin"));          //참조1
	String strEvent = StringUtil.getNVLNULL(request.getParameter("event"));					//참조2
	
	//strLegacyin = "<?xml version='1.0' encoding='euc-kr'?><지출결의서><일반정보><전표번호>100001</전표번호><회계일자>2002-10-04</회계일자><회계단위명>xxxxxxx</회계단위명><품의부서>xxxxxxx</품의부서></일반정보><금액항목><계정코드>xxxxxxxxx</계정코드><은행명>xx은행</은행명><계좌번호>xxxxxxxxxx</계좌번호><예금주>홍길동</예금주><대변>xxxxxxx</대변></금액항목><DOCSUBMIT><SUID>39aDFDDDF000DFESFESFEF</SUID></DOCSUBMIT></지출결의서>";
	
	//전자결재에서 코드를 XML String으로 넘겨주는데 <SUID>코드</SUID>를 부분의 코드 값만 가져온다.
	if ( !strLegacyin.equals("")) {
		strLegacyin = nads.lib.reqsubmit.util.StringUtil.getCutString(strLegacyin, "<SUID>","</SUID>");
	}
	
	System.out.println("strSystemid : "+strSystemid);
	System.out.println("strBusinessid : "+strBusinessid);
	System.out.println("strDocid :"+strDocid);
	System.out.println("strLegacyin : "+strLegacyin);
	System.out.println("strEvent : "+strEvent);
	
	out.println("strSystemid :" + strSystemid + "<br>");
	out.println("strBusinessid :" + strBusinessid + "<br>");
	out.println("strDocid :" + strDocid + "<br>");
	out.println("strLegacyin :" + strLegacyin + "<br>");
	out.println("strEvent :" + strEvent + "<br>");
    
	String strRet = "";
	
	//Param 정보가 다 넘어왔는지 확인한다.
	if ( strSystemid == null || strSystemid.equals("")) {
		sFlag = false;
			System.out.println("9");
			out.println("9");
	} 
	if ( strBusinessid == null || strBusinessid.equals("")) {
		sFlag = false;
			System.out.println("8");
			out.println("8");
	} 
	if ( strDocid == null || strDocid.equals("")) {
		sFlag = false;
			System.out.println("7");
			out.println("7");
	}
	if ( strLegacyin == null || strLegacyin.equals("")) {
		sFlag = false;
			System.out.println("6");
			out.println("6");
	}
	if ( strEvent == null || strEvent.equals("")) {
		sFlag = false;
			System.out.println("5");
			out.println("5");
	}
	
    
	//###################################################
	//이부분에서 요구서발송 UMS 처리하는 Delegate을 추가한다.             
	//요구서 발송시 EMS 또는 SMS를 발송 예약 상태로 했을때                  
    //결재완료 정보가 오면 필드값을 전송요청 상태로 Update 해줘야 한다. 
    //결재반려 정보가 오면 해당 정보를 테이블에서 삭제해야한다.              
    //###################################################
    
	if (sFlag == true) {
		//###################################################
   	    //결재문서번호를 처리한다.                                                                
        //###################################################
        
	    //Delegate 선언
        UmsDelegate objUmsInfo = new  UmsDelegate();
        
        //*****************> update_ACUBE_NO  = SQL 사용해서 전자결재번호 UPDATE
		//입력할 데이타를 HashTable 생성
		Hashtable objHashData = new Hashtable();
   	    int intResult = 0;
   	    String strAprvRslt = "001"; //상신
		objHashData.put("APRV_DOC_NO", strDocid);     //결재번호
  		objHashData.put("APRV_RSLT", strAprvRslt);       //결재결과
  		objHashData.put("OFFI_DOC_ID", strLegacyin);   //공문ID
  		
  		
		try {
			intResult = objUmsInfo.update_ACUBE_NO(objHashData);
		} catch (AppException objAppEx) {
		
			// 에러 발생 메세지 페이지로 이동한다.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("메세지 페이지로 이동하여야 한다.<br>");
			return;
		}
		
		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
			out.println("생성 성공<br>");
		}
         
	    System.out.println("1");
    	out.println("1");
        //###################################################
	    
		// 완료(전자우편 또는 SMS정보를 변경시키는 update 정보를 처리한다.)
		//if ( strEvent.equals("0x08") || strEvent.equals("0x20") || strEvent.equals("0x08")) {
		if ( strEvent.equals("8")) {
			
        	//전자우편, SMS 상태정보를 전송요청으로 처리
   	   	    strAprvRslt = "002"; //완료
   	   	    
            //*****************> update_TBDS_OFFICIAL_DOC_INFO      Param 값으로 공문ID(strLegacyin)를 넘긴다 결재결과 테이블을 결재완료로 바꾼다.
            //*****************> update_SMTP_SEND_STATUS     		Param 값으로 공문ID(strLegacyin)를 넘긴다.
            //*****************> update_SMS_SEND_STATUS       		Param 값으로 공문ID(strLegacyin)를 넘긴다.
        	System.out.println("2");
        	out.println("2");
		}
		
		// 반려(전자우편 또는 SMS정보를 변경시키는 delete 정보를 처리한다.)
	    //if (strEvent.equals("0x10")) {
	    if (strEvent.equals("16")) {
        //발신정보Table, 전자우편Table, SMSTable에서 발신ID에 해당하는 정보를 삭제
   	   	    strAprvRslt = "003"; //반려
            //*****************> update_TBDS_OFFICIAL_DOC_INFO      Param 값으로 공문ID(strLegacyin)를 넘긴다 결재결과 테이블을 결재반려로 바꾼다.
            //*****************> delete_SMTP_MAI     Param 값으로 공문ID(strLegacyin)를 넘긴다.
		    //*****************> delete_SMTP_REC    Param 값으로 공문ID(strLegacyin)를 넘긴다.
		    //*****************> 트리거에 걸려있는 정보를 지운다.
		    //*****************> delete_SMS              Param 값으로 공문ID(strLegacyin)를 넘긴다.
  	        //*****************> delete_SEND_INFO   Param 값으로 공문ID(strLegacyin)를 넘긴다.
  	        
			System.out.println("3");
			out.println("3");
	    }
	    
		// 기안보류(전자우편 또는 SMS정보를 변경시키는 delete 정보를 처리한다.)
	    if (strEvent.equals("미정")) {
        //발신정보Table, 전자우편Table, SMSTable에서 발신ID에 해당하는 정보를 삭제
   	   	    strAprvRslt = "004"; //기안보류
            //*****************> update_TBDS_OFFICIAL_DOC_INFO      Param 값으로 공문ID(strLegacyin)를 넘긴다 결재결과 테이블을 결재기안보류로 바꾼다.        
            objHashData.clear();            
	        objHashData.put("APRV_DOC_NO", strDocid);     //결재번호
	  		objHashData.put("APRV_RSLT", strAprvRslt);      //결재결과
	  		objHashData.put("OFFI_DOC_ID", strLegacyin);  //공문ID
	  		
			try {
				intResult = objUmsInfo.update_ACUBE_NO(objHashData);
			} catch (AppException objAppEx) {
			
				// 에러 발생 메세지 페이지로 이동한다.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("메세지 페이지로 이동하여야 한다.<br>");
				return;
			}
			
			out.print("intResult : " + intResult);
			
			if(intResult != 0 ){
				out.println("생성 성공<br>");
			}
            
			System.out.println("4");
			out.println("4");
	    }
	}
	//###################################################
	 
	//전자결재에 결과통보
	if(sFlag == true){
	   strRet = "<?xml version='1.0' encoding='euc-kr'?>\n"+
	                   "<REPLY>"+
					   "<REPLY_CODE>1</REPLY_CODE>"+
					   "<DESCRIPTION>성공</DESCRIPTION>"+
					   "</REPLY>";
	System.out.println("성공");
	out.println("성공");
	}
	else{
	   strRet = "<?xml version='1.0' encoding='euc-kr'?>\n"+
	                   "<REPLY>"+
					   "<REPLY_CODE>0</REPLY_CODE>"+
					   "<DESCRIPTION>실패</DESCRIPTION>"+
					   "</REPLY>";
	System.out.println("실패");
	out.println("실패");
	}
	
	//out.println(strRet);
%>
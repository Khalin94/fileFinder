<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.util.Vector"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>


<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
/******************************************************************************
* Name		  : SGovSubDataDelete.jsp
* Summary	  : 정부제출자료함 삭제.				
******************************************************************************/

 //String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
 String strUserID = (String)session.getAttribute("USER_ID");
 String strUserID1 = StringUtil.getEmptyIfNull((String)request.getParameter("RegrID"));
 System.out.println("kangthis logs strUserID1 => " + strUserID);
 System.out.println("kangthis logs strUserID2 => " + strUserID1);
 /*if (strUserID == null || strUserID.equals("") || !strUserID.equals(strUserID1)) {
     out.println("<script language=javascript>");
     out.println("alert('등록한 사용자만 삭제할 수 있습니다.')");
     out.println("history.back();");
     out.println("</script>");
     return;
 }*/
	
 if(strUserID == null){
	strUserID = "tester2"; //제출기관
 }
 

 String strGbnKindCode = StringUtil.getEmptyIfNull((String)request.getParameter("strGbnKindCode")); // 정부제출자료 코드 종류
 //System.out.println("[SGovSubDataDelete.jsp] strGbnKindCode = " + strGbnKindCode);
 String strGovSubmtDataId = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataId"));
 String strAnsSubmtQryTerm = StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryTerm"));
 String strAnsSubmtQryField = StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryField"));
 String strGovSubmtDataSortField = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortField"));
 String strGovSubmtDataSortMtd = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortMtd"));
 String strGovSubmtDataPageNum = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataPageNum"));
 String	strSubmtDate =  StringUtil.getEmptyIfNull((String)request.getParameter("strSubmtDate")); // 등록일자.
 //System.out.println("[SGovSubDataDelete.jsp] strSubmtDate = " + strSubmtDate);
 
 String	strPdfFilePath =  StringUtil.getEmptyIfNull((String)request.getParameter("strPdfFilePath")); // 등록일자.
 //System.out.println("[SGovSubDataDelete.jsp] strPdfFilePath = " + strPdfFilePath);
 
 String	strOrgFilePath =  StringUtil.getEmptyIfNull((String)request.getParameter("strOrgFilePath")); // 등록일자.
 //System.out.println("[SGovSubDataDelete.jsp] strOrgFilePath = " + strOrgFilePath);
 
 String	strTocFilePath =  StringUtil.getEmptyIfNull((String)request.getParameter("strTocFilePath")); // 등록일자.
 //System.out.println("[SGovSubDataDelete.jsp] strTocFilePath = " + strTocFilePath);
 
 if(strSubmtDate != null){
 	
 	 String strYear = strSubmtDate.substring(0,4);
 	/* 
 	 System.out.println(" [SGovSubDataDelete.jsp] strYear =" + strYear);
	 System.out.println(" [SGovSubDataDelete.jsp] strGovSubmtDataId = " + strGovSubmtDataId);
	 System.out.println(" [SGovSubDataDelete.jsp] strAnsSubmtQryTerm  = " + strAnsSubmtQryTerm);
	 System.out.println(" [SGovSubDataDelete.jsp] strAnsSubmtQryField  = " + strAnsSubmtQryField);
	 System.out.println(" [SGovSubDataDelete.jsp] strGovSubmtDataSortField = " + strGovSubmtDataSortField);
	 System.out.println(" [SGovSubDataDelete.jsp] strGovSubmtDataSortMtd = " + strGovSubmtDataSortMtd);
	 System.out.println(" [SGovSubDataDelete.jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);
	 */
	
	    
	 SGovSubmtDataDelegate obGovSmdata = new SGovSubmtDataDelegate();
	 Hashtable objHash = null;
         int result1 = obGovSmdata.getRegrIdCheck(strUserID, strGovSubmtDataId);
	System.out.println("kangthis logs result1 => " +result1);
         if (result1 < 1) {
	    out.println("<script language=javascript>");
	    out.println("alert('등록한 사용자만이 삭제할수 있습니다.')");
	    out.println("history.back();");
	    out.println("</script>");
	    return;
	 }
	 
	 //UserInfoDelegate objUser = new UserInfoDelegate(strUserID);
	 //String strGbnCode = objUser.getOrganGBNCode();
	 String strGbnCode = "001";		 // 제출기관으로 설정 나중에 지울것
	 
	 FileUtil objFile = new FileUtil();
	 int intResult = obGovSmdata.getGovSubmtDataDelete(strGbnCode,strGovSubmtDataId); // db정보 삭제	
		
		if(intResult < 0){	
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  	objMsgBean.setStrCode("DSDATA-0010"); //등록오류
%>
	  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%	  	
		}else{
		  //파일삭제
		  
		  String strFilePath =  EnvConstants.UNIX_SAVE_PATH + strYear + "/etc/" ;
		  strPdfFilePath = strFilePath + strPdfFilePath ;
		  strOrgFilePath = strFilePath + strOrgFilePath ;
		  strTocFilePath = strFilePath + strTocFilePath ;

		   boolean blnCheckDel = true;
		   
		   try{
			  if(strGbnKindCode.equals("004")){ //정부시정및처리결과 보고서
				objFile.deleteFile(strPdfFilePath);
				//System.out.println("정부시정및처리결과 보고서다");
			  }else{			   
				objFile.deleteFile(strPdfFilePath);				
			  	objFile.deleteFile(strOrgFilePath);			  	
			  	objFile.deleteFile(strTocFilePath);
			  	
			  	//System.out.println("[SGovSubDataDelete.jsp] strPdfFilePath ="  + strPdfFilePath);
  				//System.out.println("[SGovSubDataDelete.jsp] strOrgFilePath ="  + strOrgFilePath);
  				//System.out.println("[SGovSubDataDelete.jsp] strTocFilePath ="  + strTocFilePath);
			  }
			}catch(Exception e){
				blnCheckDel = false;
			}
			
			if(blnCheckDel){
%>
					<html>
					<script language="JavaScript">
						function init(){
							alert("회의자료등록함 자료가 삭제되었습니다 ");
							formName.submit();
						}
					</script>
					<body onLoad="init()">
									<form name="formName" method="get" action="./SGovSubDataBoxList.jsp" ><!--요구함 신규정보 전달 -->
									    <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"><!--정부제출자료목록정렬필드 -->
										<input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"><!--정부제출자료목록정령방법-->
										<input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>"><!--정부제출자료 페이지 번호 -->
										<input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>"><!--정부제출자료 조회필드 -->
										<input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>"><!--정부제출자료 조회어 -->
									</form>
					</body>
					</html>
<%

			}else{
				System.out.println("파일삭제시 에러가 발생하였습니다.");
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  		objMsgBean.setStrCode("DSDATA-0012"); //등록오류
%>
	  			<jsp:forward page="/common/message/ViewMsg.jsp"/>			
<%
			}
		}
	
 }else{
 	System.out.println("  등록일자를 알수가 없어 파일을 삭제 할수가 없다. ");
 }
%>            

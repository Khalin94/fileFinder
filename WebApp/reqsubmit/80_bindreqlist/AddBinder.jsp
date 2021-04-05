<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	//String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
	//strUserID = "tester1";

	String strReqId = null;	
	String strAnsID = null;
	String strAnsIdInfo = null;
	String StstrAnsIDData = null;
	ArrayList objTotalBinderList = null;
	Hashtable objBinderHash = null;
	String strAnsFileId = null;
	String[] strReqIdArray = new String[300];
	boolean blnCheck = false;
	/* 요구에 대한 답변 확인 */
	int intReqCheckNum = 0;
	/* 요구에 대한 답변없는 수 확인 */
	int intAnsCheckNum = 0;


	strReqIdArray = request.getParameterValues("ReqInfoIDs");
	//System.out.println("strReqId ="  +strReqIdArray[0]);
	bindDelegate objBindDelegate = new bindDelegate();
 	ArrayList objCheckArray = new ArrayList();
	ArrayList objAnsIDArray = new ArrayList();
	
	if (strReqIdArray != null)
	{
		int intRegIDLength = strReqIdArray.length ;
		//System.out.println("intRegIDLength =" + intRegIDLength);
		String strDeleteFileIndex = null;		
		String strBinderList = null;
		
		objTotalBinderList = (ArrayList)session.getAttribute(EnvConstants.BINDER);
		
		if(objTotalBinderList == null ){
			objTotalBinderList = new ArrayList();
			System.out.println("[AddBinder.jsp] 바인더목록들이 세션에 없다. ");
		}		
		

		for(int i=0; i<intRegIDLength ; i++) {
			strReqId = strReqIdArray[i];
			Hashtable objHansCount	 = objBindDelegate.getAnsIDCount(strReqId);
			objBinderHash = objBindDelegate.getAnsIDArray(strReqId);
			/*for (java.util.Enumeration enum=objBinderHash.keys();enum.hasMoreElements();){
				System.out.println("[addBinder ] Key:" + (String)enum.nextElement());
			}*/			
			String strAnsInfoCount =	(String)objHansCount.get("TOTALCOUNT");
		

			Integer intFieldCnt = (Integer)objBinderHash.get("FETCH_COUNT");
			Integer objAnsInfoCount = new Integer(strAnsInfoCount);
			int intAnsInfoCount = objAnsInfoCount.intValue();
			intReqCheckNum = intReqCheckNum + intAnsInfoCount;

			int intSessionIDCount  = objTotalBinderList.size();
			//System.out.println("**** 요구 ID " + strReqId  + " 에 대한 답변 개수는 ? = " + intAnsInfoCount + " *******");
			// 요구에 대한 답변의 갯수만큼 답변ID을 세션에 추가한다.

			for(int j = 0 ; j < intAnsInfoCount; j++){					
				  strAnsID = (String)((Vector)objBinderHash.get("ANS_ID")).elementAt(j);
				  strAnsFileId = (String)((Vector)objBinderHash.get("ANS_FILE_ID") ).elementAt(j) ;
				 
				  //System.out.println("[AddBinder.jsp]   답변 파일 ID strAnsFileId = " + strAnsFileId);
				  //System.out.println("[AddBinder.jsp]  요구 ID에 의한  " + j + " 번째 답변 ID = " + strAnsID );
				  if(strAnsFileId=="" ||  strAnsFileId.equals("") ){
						System.out.println("[AddBinder.jsp]  요구 ID에 의한  " + j + " 번째 답변 ID = " + strAnsID + " 는 답변파일이 없으므로 바인더목록에 추가할수 없다." );
						intAnsCheckNum++;
				  }else{
					  objAnsIDArray.add(strAnsID);
				  }
			}
			//System.out.println("[AddBinder.jsp]  총 답변id갯수는 ? = " + objAnsIDArray.size());
			//objTotalBinderList  = objBindDelegate.checkSessionIsAnsIDs(strAnsID,objTotalBinderList);
			for(int  j = 0 ; j < objAnsIDArray.size() ; j ++){				
				  strAnsIdInfo = (String)objAnsIDArray.get(j);		
				  //System.out.println("비교할 답변 id = " + strAnsIdInfo);
				  if(intSessionIDCount == 0){
						objTotalBinderList.add(strAnsIdInfo);
				  }else{
					  for(int k = 0; k < intSessionIDCount; k++) {        	    	    	
						StstrAnsIDData = (String)objTotalBinderList.get(k);
						//System.out.println("[AddBinder.jsp] 현재 세션에 들어있는  " + j + " 번째 답변 ID = " + StstrAnsIDData );
						blnCheck = false;
						if(StstrAnsIDData.equals(strAnsIdInfo)){
							 blnCheck = true;
							 objCheckArray.add(strAnsIdInfo);						 
							 break;        
						}			  					  						
					  }
					  if(!blnCheck){
							 System.out.println("세션에 값을 추가한다. strAnsID =" + strAnsIdInfo );
							 objTotalBinderList.add(strAnsIdInfo);
					  }
				  }
			}
		}

		//System.out.println("  요구에 대한 전체 답변의  갯수 = " + intReqCheckNum );
		//System.out.println("  요구에 대한 전체 답변이 없는  갯수 = " + intAnsCheckNum );
		//System.out.println("objTotalBinderList.size() = " + objTotalBinderList.size() + "\n\n");
		session.setAttribute(EnvConstants.BINDER,objTotalBinderList); 		
	}

%>
<html>
<head>
<title>바인더 추가</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="350" border="0" cellspacing="0" cellpadding="0">
  <tr class="td_reqsubmit"> 
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="350" height="34" class="soti_reqsubmit" bgcolor="#f4f4f4">&nbsp;&nbsp;<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
      <font style="font-size:14px">바인더 추가</font></td>
  </tr>
  <tr>
	<td height="1" bgcolor="#c0c0c0"></td>
  </tr>
  <tr> 
    <td height="10"></td>
  </tr>
  <tr> 
    <td height="23" align="left" valign="top">
		<%
			if(intReqCheckNum == intAnsCheckNum) {
		%>
		&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> 작업 결과 : <B>바인더 목록 추가 실패 (Failed)</B>
        <p>
		&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> 사 유 : 요구에 대한 답변파일이 존재하지 않습니다.<br>
		<%
			} else {
		%>
		&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> 작업 결과 : <B>바인더 목록 추가 성공 (Success)</B>
        <p>
		&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> 참 조 : 파일이 첨부되지 않은 답변은 추가하지 않습니다. <br>
		<%
			}
		%>

	</td>
  </tr>
  <tr> 
    <td height="30"></td>
  </tr>
  <tr> 
    <td height="40" align="left">
	   <table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">&nbsp;
		  <a href="javascript:window.close();opener.location.href='/reqsubmit/80_bindreqlist/BindList.jsp?binderSortField=ANS_DT&binderSortMtd=DESC&binderPageNum=1'"><img src="/image/button/bt_binderReqList.gif" width="109" height="20" border="0"></a>
		  </td>
        </tr>
      </table></td>
  </tr>
  <tr>
	<td height="1" bgcolor="#c0c0c0"></td>
  </tr>
  <tr> 
    <td height="25" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</table>
<p> </p>
</body>
</html>
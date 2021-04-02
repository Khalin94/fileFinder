<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
/********************************************************************************************/	
/*****  국감시스템연계를 위한 BACKGROUND JOB PROCCESS         ********/	
/********************************************************************************************/	


   UserInfoDelegate objUser = new UserInfoDelegate(request);
   bindDelegate objBindDelegate = new bindDelegate();

   String   strReqBoxId = null;
   String   strReqBoxDsc = null;  //자료명(요구함명) 
   String   strAnsID = null;
   String   strBinderSortMtd = null;
   String   strBinderSortField = null;
   String   strNewBindedFileName = null;
   String   strUserID = null; //등록자
   String 	strRegDt = null;  //등록일
   String   strYear = null ;  // 해당년도
   String   strReqBindID = null ; // 국감시스템연계자료함 ID  
   String   strPDFFilePath = null;
   String   strAuditYear = null; //국감적용년도
   
   ArrayList objArray = new ArrayList();
   Hashtable objArrayIDHashtable = null;
   Hashtable objBinderHash = null;
   boolean booleanCheck = false;

   strUserID = objUser.getUserID();
   //System.out.println("[bindingProc.jsp] strUserID =" + strUserID);
   //strReqIdArray = request.getParameterValues("BindingReqBoxID");
   strReqBoxId = request.getParameter("ReqBoxID");
   //System.out.println(" [bindingProc.jsp] 요구함 ID = " + strReqBoxId );
   strBinderSortMtd = request.getParameter("strBinderSortMtd");
   strBinderSortField = request.getParameter("strBinderSortField");

   if(strBinderSortMtd == null || strBinderSortMtd.equals("")){
		strBinderSortMtd = "DESC";
   }

   if(strBinderSortField == null || strBinderSortField.equals("")){
		strBinderSortField = "REG_DT";
   }
   
    /** 요구함ID에 대한 답변ID를 구한다.**/
    objArrayIDHashtable =  objBindDelegate.getAnsIDList(strReqBoxId);
    
		//strReqBoxDsc  =(String)((Vector)objArrayIDHashtable.get("REQ_BOX_DSC")).elementAt(0);
		strReqBoxDsc  = (String)((Vector)objArrayIDHashtable.get("REQ_BOX_NM")).elementAt(0);
		//strAuditYear  =(String)((Vector)objArrayIDHashtable.get("AUDIT_YEAR")).elementAt(0);

		Integer intFieldCnt = (Integer)objArrayIDHashtable.get("FETCHCOUNTNAME");			
	    int intAnsCount = intFieldCnt.intValue();
		//System.out.println("[bindingProc.jsp] Count = " + intAnsCount );			
	//if(intAnsCount == 0 || intAnsCount == 1){
	%>
		<!--<html>
		<head>
		<title>국정감사시스템 연계 의원요구답변 추가</title>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link href="/css/System.css" rel="stylesheet" type="text/css">
		</head>
		<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
			<table width="247" height="150" border="0" cellpadding="0" cellspacing="0">
			  <tr height="5"> 
				<td height="5" align="left" valign="top" class="td_reqsubmit"></td>
			  </tr>
			  <tr> 
				<td align="center" valign="middle">
					<table width="95%" border="0" cellspacing="4" cellpadding="0">			
					  <tr> 
						<td align="center"> 답변파일이 2개 이상 존재 해야<br>
							바인딩작업을 할수 있습니다.<br><br>
						</td> 
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr> 
				<td height="25" align="right" valign="middle" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
			  </tr>
			</table>
		</body>
		</html>-->
	<%
	//}else{
		int intEqualsCount = 0;
		
		for(int j =0 ; j < intAnsCount ; j++){
			strAnsID  =(String)((Vector)objArrayIDHashtable.get("ANS_ID")).elementAt(j);
			strPDFFilePath  =(String)((Vector)objArrayIDHashtable.get("PDF_FILE_PATH")).elementAt(j);
			
			if(strPDFFilePath == "" || strPDFFilePath.equals("")){
    			intEqualsCount++;
				//booleanCheck = true;
				//break;
			}else{
				objArray.add(strAnsID);
			}
		}
			
		//if(booleanCheck){
		////System.out.println("intEqualsCount = " + intEqualsCount);
		//System.out.println("intAnsCount = " + intAnsCount);
		
		if(intAnsCount == intEqualsCount){
%>
				<html>
				<head>
				<title>바인딩 작업</title>
				<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
				<link href="/css/System.css" rel="stylesheet" type="text/css">
				</head>
				<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
					<table width="247" height="150" border="0" cellpadding="0" cellspacing="0">
					  <tr height="5"> 
						<td height="5" align="left" valign="top" class="td_reqsubmit"></td>
					  </tr>
					  <tr> 
						<td align="center" valign="middle">
							<table width="95%" border="0" cellspacing="4" cellpadding="0">			
							  <tr> 
								<td align="center">바인딩 작업할 답변파일이<br>
									존재하지 않습니다.<br><br>
								</td> 
							  </tr>
							</table>
						</td>
					  </tr>
					  <tr> 
						<td height="25" align="right" valign="middle" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
					  </tr>
					</table>
				</body>
				</html>
	<%
		} else{
				//System.out.println(" [bindingProc.jsp] 답변 ID 전체 갯수는  = " +  objArray.size());
				objBinderHash = objBindDelegate.getBindListInfo("ANS_ID",strBinderSortMtd,strBinderSortField,objArray);
				/* 북마크정보인 Xtoc 생성*/
				String strXtocPath = objBindDelegate.createXtocToDelegate(objBinderHash);  
				//System.out.println("[bindingProc.jsp] Temp 폴더에 생성된 xtoc 파일 패스 정보   strXtocPath =" + strXtocPath);
				
				if(strXtocPath.compareTo("Error") == 0){
				   //System.out.println(" [bindingProc.jsp] strXtocPath 가 null 이다");
				}else{
									 
					 strReqBindID = objBindDelegate.getReqGovConnectNextID();
					 strRegDt = FileUtil.getFileName(strXtocPath,"/");
					 strRegDt = FileUtil.getPureFileName(strRegDt);
					 //System.out.println(" ***** strRegDt = " + strRegDt + " *******");
					 strYear = strRegDt.substring(0,4);
					
					 String strGovConnectBindFolder = EnvConstants.UNIX_SAVE_PATH + strYear + "/ReqBind/";
					 //System.out.println( strGovConnectBindFolder + " 폴더 미리 생성 ");
					 FileUtil.prepareFolder(strGovConnectBindFolder);
					 
					
					 //System.out.println("*****[ start binding ]******");
					 //String strXtocPath,String strYear,String strReqBoxId ,String reqBindID
					 strNewBindedFileName =  objBindDelegate.ReqGovConnectStartBinding(strXtocPath,strYear,strReqBoxId,strReqBindID);
					 //System.out.println("[bindingProc] 생성된 Binder 파일의 리턴값 = " +strNewBindedFileName);
					 //System.out.println("*****[ bind End ]***********");	 
				}

				if( strNewBindedFileName == "Error" || strNewBindedFileName.equals("Error") ){
					System.out.println(" [bindingProc.jsp] 바인딩 실패");
					/* objMsgBean.setMsgType(MessageBean.TYPE_WARN);
					objMsgBean.setStrCode("DSDATA-0034");	  	
					objMsgBean.setStrMsg(" [bindingProc.jsp] 바인딩된 파일 생성 실패.");
  			        <jsp:forward page="/common/message/ViewMsg.jsp"/>	  
					*/
			%>
					<html>
					<head>
					<title>국정감사시스템 연계 의원요구답변 추가</title>
					<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
					<link href="/css/System.css" rel="stylesheet" type="text/css">
					</head>
					<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
						<table width="247" height="150" border="0" cellpadding="0" cellspacing="0">
						  <tr height="5"> 
							<td height="5" align="left" valign="top" class="td_reqsubmit"></td>
						  </tr>
						  <tr> 
							<td align="center" valign="middle">
								<table width="95%" border="0" cellspacing="4" cellpadding="0">			
								  <tr> 
									<td align="center">바인딩 프로세스 에러<br>
										
									</td> 
								  </tr>
								</table>
							</td>
						  </tr>
						  <tr> 
							<td height="25" align="right" valign="middle" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
						  </tr>
						</table>
					</body>
					</html>
			<%
				}else{
					Vector objInsertParam = new Vector();								
					objInsertParam.add(strReqBindID);
					objInsertParam.add(strReqBoxId);
					objInsertParam.add(strReqBoxDsc);
					objInsertParam.add(strUserID);
					objInsertParam.add(strRegDt);
					
					//strNewBindedFileName =  strYear + "/ReqBind/" + strNewBindedFileName;
					strNewBindedFileName = "DB등록중";
					objInsertParam.add(strNewBindedFileName);
					objInsertParam.add("N");
					//DB에 추가함 			
				  objBindDelegate.InsertReqConnectBinding(objInsertParam);
			%>	
					<html>
					<head>
					<title>국정감사시스템 연계 의원요구답변 추가</title>
					<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
					<link href="/css/System.css" rel="stylesheet" type="text/css">
					</head>
					<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
					<table width="247" border="0" cellspacing="0" cellpadding="0">
					  <tr class="td_reqsubmit"> 
						<td height="5"></td>
						<td height="5"></td>
					  </tr>
					  <tr> 
						<td height="10"></td>
						<td height="10"></td>
					  </tr>
					  <tr> 
						<td width="14">&nbsp;</td>
						<td width="386" height="25" valign="middle" class="soti_reqsubmit"><img src="../image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
						  바인딩 작업 </td>
					  </tr>
					  <tr> 
						<td height="10"></td>
						<td height="10"></td>
					  </tr>
					  <tr> 
						<td width="14">&nbsp;</td>
						<td height="23" align="left" valign="top"><table width="95%" border="0" cellspacing="4" cellpadding="0">
							<tr> 
							  <td height="26" align="center"> </td>
							</tr>
							<tr> 
							  <td align="center"><p>※바인딩이 성공적으로<br>
										이루어졌습니다. </p>
					</td>
							</tr>
						  </table></td>
					  </tr>
					  <tr> 
						<td height="10"></td>
						<td height="10"></td>
					  </tr>
					  <tr> 
						<td width="14">&nbsp;</td>
						<td height="40" align="left">
						   <table width="96%" border="0" cellspacing="0" cellpadding="0">
							<tr> 
							  <td height="25" align="right">&nbsp;
							 <!-- <a href="javascript:window.close();opener.location.href='http://10.201.19.148:7001/reqsubmit/80_bindreqlist/BindList.jsp?binderSortField=ANS_DT&binderSortMtd=DESC&binderPageNum=1'"><img src="../image/button/bt_binderReqList.gif" width="109" height="20" border="0"></a>-->
							  </td>
							</tr>
						  </table></td>
					  </tr>
					  <tr> 
						<td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
					  </tr>
					</table>
					<p> </p>
					</body>
					</html>
	   <%
	   
				}				
		}
	   %>	
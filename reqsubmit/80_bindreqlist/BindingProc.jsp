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
/*****  �����ý��ۿ��踦 ���� BACKGROUND JOB PROCCESS         ********/	
/********************************************************************************************/	


   UserInfoDelegate objUser = new UserInfoDelegate(request);
   bindDelegate objBindDelegate = new bindDelegate();

   String   strReqBoxId = null;
   String   strReqBoxDsc = null;  //�ڷ��(�䱸�Ը�) 
   String   strAnsID = null;
   String   strBinderSortMtd = null;
   String   strBinderSortField = null;
   String   strNewBindedFileName = null;
   String   strUserID = null; //�����
   String 	strRegDt = null;  //�����
   String   strYear = null ;  // �ش�⵵
   String   strReqBindID = null ; // �����ý��ۿ����ڷ��� ID  
   String   strPDFFilePath = null;
   String   strAuditYear = null; //��������⵵
   
   ArrayList objArray = new ArrayList();
   Hashtable objArrayIDHashtable = null;
   Hashtable objBinderHash = null;
   boolean booleanCheck = false;

   strUserID = objUser.getUserID();
   //System.out.println("[bindingProc.jsp] strUserID =" + strUserID);
   //strReqIdArray = request.getParameterValues("BindingReqBoxID");
   strReqBoxId = request.getParameter("ReqBoxID");
   //System.out.println(" [bindingProc.jsp] �䱸�� ID = " + strReqBoxId );
   strBinderSortMtd = request.getParameter("strBinderSortMtd");
   strBinderSortField = request.getParameter("strBinderSortField");

   if(strBinderSortMtd == null || strBinderSortMtd.equals("")){
		strBinderSortMtd = "DESC";
   }

   if(strBinderSortField == null || strBinderSortField.equals("")){
		strBinderSortField = "REG_DT";
   }
   
    /** �䱸��ID�� ���� �亯ID�� ���Ѵ�.**/
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
		<title>��������ý��� ���� �ǿ��䱸�亯 �߰�</title>
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
						<td align="center"> �亯������ 2�� �̻� ���� �ؾ�<br>
							���ε��۾��� �Ҽ� �ֽ��ϴ�.<br><br>
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
				<title>���ε� �۾�</title>
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
								<td align="center">���ε� �۾��� �亯������<br>
									�������� �ʽ��ϴ�.<br><br>
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
				//System.out.println(" [bindingProc.jsp] �亯 ID ��ü ������  = " +  objArray.size());
				objBinderHash = objBindDelegate.getBindListInfo("ANS_ID",strBinderSortMtd,strBinderSortField,objArray);
				/* �ϸ�ũ������ Xtoc ����*/
				String strXtocPath = objBindDelegate.createXtocToDelegate(objBinderHash);  
				//System.out.println("[bindingProc.jsp] Temp ������ ������ xtoc ���� �н� ����   strXtocPath =" + strXtocPath);
				
				if(strXtocPath.compareTo("Error") == 0){
				   //System.out.println(" [bindingProc.jsp] strXtocPath �� null �̴�");
				}else{
									 
					 strReqBindID = objBindDelegate.getReqGovConnectNextID();
					 strRegDt = FileUtil.getFileName(strXtocPath,"/");
					 strRegDt = FileUtil.getPureFileName(strRegDt);
					 //System.out.println(" ***** strRegDt = " + strRegDt + " *******");
					 strYear = strRegDt.substring(0,4);
					
					 String strGovConnectBindFolder = EnvConstants.UNIX_SAVE_PATH + strYear + "/ReqBind/";
					 //System.out.println( strGovConnectBindFolder + " ���� �̸� ���� ");
					 FileUtil.prepareFolder(strGovConnectBindFolder);
					 
					
					 //System.out.println("*****[ start binding ]******");
					 //String strXtocPath,String strYear,String strReqBoxId ,String reqBindID
					 strNewBindedFileName =  objBindDelegate.ReqGovConnectStartBinding(strXtocPath,strYear,strReqBoxId,strReqBindID);
					 //System.out.println("[bindingProc] ������ Binder ������ ���ϰ� = " +strNewBindedFileName);
					 //System.out.println("*****[ bind End ]***********");	 
				}

				if( strNewBindedFileName == "Error" || strNewBindedFileName.equals("Error") ){
					System.out.println(" [bindingProc.jsp] ���ε� ����");
					/* objMsgBean.setMsgType(MessageBean.TYPE_WARN);
					objMsgBean.setStrCode("DSDATA-0034");	  	
					objMsgBean.setStrMsg(" [bindingProc.jsp] ���ε��� ���� ���� ����.");
  			        <jsp:forward page="/common/message/ViewMsg.jsp"/>	  
					*/
			%>
					<html>
					<head>
					<title>��������ý��� ���� �ǿ��䱸�亯 �߰�</title>
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
									<td align="center">���ε� ���μ��� ����<br>
										
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
					strNewBindedFileName = "DB�����";
					objInsertParam.add(strNewBindedFileName);
					objInsertParam.add("N");
					//DB�� �߰��� 			
				  objBindDelegate.InsertReqConnectBinding(objInsertParam);
			%>	
					<html>
					<head>
					<title>��������ý��� ���� �ǿ��䱸�亯 �߰�</title>
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
						  ���ε� �۾� </td>
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
							  <td align="center"><p>�ع��ε��� ����������<br>
										�̷�������ϴ�. </p>
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
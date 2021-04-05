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
* Summary	  : ���������ڷ��� ����.				
******************************************************************************/

 //String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
 String strUserID = (String)session.getAttribute("USER_ID");
 String strUserID1 = StringUtil.getEmptyIfNull((String)request.getParameter("RegrID"));
 System.out.println("kangthis logs strUserID1 => " + strUserID);
 System.out.println("kangthis logs strUserID2 => " + strUserID1);
 /*if (strUserID == null || strUserID.equals("") || !strUserID.equals(strUserID1)) {
     out.println("<script language=javascript>");
     out.println("alert('����� ����ڸ� ������ �� �ֽ��ϴ�.')");
     out.println("history.back();");
     out.println("</script>");
     return;
 }*/
	
 if(strUserID == null){
	strUserID = "tester2"; //������
 }
 

 String strGbnKindCode = StringUtil.getEmptyIfNull((String)request.getParameter("strGbnKindCode")); // ���������ڷ� �ڵ� ����
 //System.out.println("[SGovSubDataDelete.jsp] strGbnKindCode = " + strGbnKindCode);
 String strGovSubmtDataId = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataId"));
 String strAnsSubmtQryTerm = StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryTerm"));
 String strAnsSubmtQryField = StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryField"));
 String strGovSubmtDataSortField = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortField"));
 String strGovSubmtDataSortMtd = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortMtd"));
 String strGovSubmtDataPageNum = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataPageNum"));
 String	strSubmtDate =  StringUtil.getEmptyIfNull((String)request.getParameter("strSubmtDate")); // �������.
 //System.out.println("[SGovSubDataDelete.jsp] strSubmtDate = " + strSubmtDate);
 
 String	strPdfFilePath =  StringUtil.getEmptyIfNull((String)request.getParameter("strPdfFilePath")); // �������.
 //System.out.println("[SGovSubDataDelete.jsp] strPdfFilePath = " + strPdfFilePath);
 
 String	strOrgFilePath =  StringUtil.getEmptyIfNull((String)request.getParameter("strOrgFilePath")); // �������.
 //System.out.println("[SGovSubDataDelete.jsp] strOrgFilePath = " + strOrgFilePath);
 
 String	strTocFilePath =  StringUtil.getEmptyIfNull((String)request.getParameter("strTocFilePath")); // �������.
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
	    out.println("alert('����� ����ڸ��� �����Ҽ� �ֽ��ϴ�.')");
	    out.println("history.back();");
	    out.println("</script>");
	    return;
	 }
	 
	 //UserInfoDelegate objUser = new UserInfoDelegate(strUserID);
	 //String strGbnCode = objUser.getOrganGBNCode();
	 String strGbnCode = "001";		 // ���������� ���� ���߿� �����
	 
	 FileUtil objFile = new FileUtil();
	 int intResult = obGovSmdata.getGovSubmtDataDelete(strGbnCode,strGovSubmtDataId); // db���� ����	
		
		if(intResult < 0){	
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  	objMsgBean.setStrCode("DSDATA-0010"); //��Ͽ���
%>
	  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%	  	
		}else{
		  //���ϻ���
		  
		  String strFilePath =  EnvConstants.UNIX_SAVE_PATH + strYear + "/etc/" ;
		  strPdfFilePath = strFilePath + strPdfFilePath ;
		  strOrgFilePath = strFilePath + strOrgFilePath ;
		  strTocFilePath = strFilePath + strTocFilePath ;

		   boolean blnCheckDel = true;
		   
		   try{
			  if(strGbnKindCode.equals("004")){ //���ν�����ó����� ����
				objFile.deleteFile(strPdfFilePath);
				//System.out.println("���ν�����ó����� ������");
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
							alert("ȸ���ڷ����� �ڷᰡ �����Ǿ����ϴ� ");
							formName.submit();
						}
					</script>
					<body onLoad="init()">
									<form name="formName" method="get" action="./SGovSubDataBoxList.jsp" ><!--�䱸�� �ű����� ���� -->
									    <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"><!--���������ڷ��������ʵ� -->
										<input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"><!--���������ڷ������ɹ��-->
										<input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>"><!--���������ڷ� ������ ��ȣ -->
										<input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>"><!--���������ڷ� ��ȸ�ʵ� -->
										<input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>"><!--���������ڷ� ��ȸ�� -->
									</form>
					</body>
					</html>
<%

			}else{
				System.out.println("���ϻ����� ������ �߻��Ͽ����ϴ�.");
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  		objMsgBean.setStrCode("DSDATA-0012"); //��Ͽ���
%>
	  			<jsp:forward page="/common/message/ViewMsg.jsp"/>			
<%
			}
		}
	
 }else{
 	System.out.println("  ������ڸ� �˼��� ���� ������ ���� �Ҽ��� ����. ");
 }
%>            

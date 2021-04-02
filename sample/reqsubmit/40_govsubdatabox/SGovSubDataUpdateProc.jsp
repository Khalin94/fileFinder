<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.params.govsubmtdata.SGovSubmtDataInsertForm" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate" %>
<%@ page import="nads.lib.reqsubmit.form.RequestWrapper"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.uniflow.UniFlowWrapper"%>



<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>


<%
	// ����� ����
	
	//UserInfoDelegate objUser = new UserInfoDelegate(strUserID);
	UserInfoDelegate objUser = new UserInfoDelegate(request);

	String strGbnCode = objUser.getOrganGBNCode();
	strGbnCode = "001";		 // ���������� ���� ���߿� �����;

 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  
  /**�Ķ���� ���� ��Ͽ��� ��� ����ٴ�..*/
  SGovSubmtDataInsertForm objParams = new SGovSubmtDataInsertForm();
  SGovSubmtDataDelegate objSubmtDataDelegate = new SGovSubmtDataDelegate();

  String RegDt = objParams.getParamValue("RegDt"); 	
  String strInsertYear = RegDt.substring(0,4);  
  String strFileSaveYearPath = strInsertYear + "/etc";
  
  // UNIX ���� �н� 
  String strSaveFilePath = EnvConstants.UNIX_SAVE_PATH  + strInsertYear + "/etc";
  String strCreatEtcFolder = strSaveFilePath + "/";
  FileUtil.prepareFolder(strCreatEtcFolder);
  String strTempSaveFilePath = EnvConstants.UNIX_TEMP_SAVE_PATH ; //EnvConstants.UNIX_SAVE_PATH  + strInsertYear + "/etc/temp";
  //System.out.println("[SGovSubDataInsertProc.jsp] Unix  strSaveFilePath = " + strSaveFilePath);
  //System.out.println("[SGovSubDataInsertProc.jsp] Unix  strSaveTempFilePath = " + strTempSaveFilePath);
  
  // UNIFLOWWORK�� �޼��� ������ �н�  
  String strTempWorkFlowMsgFolder = EnvConstants.WIN_TEMP_SAVE_PATH ; //EnvConstants.WIN_SAVE_PATH + strInsertYear + "/etc/temp";
  //System.out.println("[SGovSubDataInsertProc.jsp] uniworkFlow  strTempWorkFlowMsgFolder = " + strTempWorkFlowMsgFolder);
  //System.out.println("[SGovSubDataUpdateProc.jsp] strSaveFilePath = " + strSaveFilePath);
    
  boolean blnParamCheck=false;
  /** ���޵� �ĸ����� üũ */
  
  /************************************************************************/  
  /*  Multipart�ϰ�� �ݵ�� �̳༮�� �̿��ؼ� ���� Valid�Ķ����� �Ѱ������ */
  /*	���� 															  */
  /************************************************************************/
  try{ 
	  // ����
	  //System.out.println("\n strTempSaveFilePath �� ���Ϻ��� �� �н����� = " + strTempSaveFilePath );
	  RequestWrapper objRequestWrapper =  new RequestWrapper(request,strTempSaveFilePath);
	  blnParamCheck=objParams.validateParams(objRequestWrapper);
	  	   
  }catch(Exception ex){
	   if(blnParamCheck==false){
		  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  	objMsgBean.setStrCode("DSPARAM-0010"); // ���ε� ���Ͽ뷮 �ʰ��� �����ڵ�
		  	objMsgBean.setStrMsg(objParams.getStrErrors());
		  	//out.println("ParamError:" + objParams.getStrErrors());
		  	%>
		  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
		  	<%
		  	return;
	  	}
  } 
%>

<%
 /*************************************************************************************************/
 /** 					DB ���� 														  	*/
 /*************************************************************************************************/
%>

<%
 	 Vector objUpdateData = new Vector();	
		       	
   	 UniFlowWrapper objUniFlowWrapper = new UniFlowWrapper();
		       	 	 	
	 int intExtractTextResult	= 0;
	 int intResult = -1;

	 // ���������ڷ�(ȸ�������ڷ�) �����ڵ�
 	 String GovSubmtDataType = objParams.getParamValue("GovSubmtDataType"); 
 	 objUpdateData.add(GovSubmtDataType); 	 
     //System.out.println("[SGovSubDataUpdateProc.jsp][add] GovSubmtDataType =" + GovSubmtDataType);
 	 // �����
 	 String strReqOrganId = objParams.getParamValue("strReqOrganId");	
 	 objUpdateData.add(strReqOrganId);
     //System.out.println("[SGovSubDataUpdateProc.jsp][add] strReqOrganId = " + strReqOrganId); 	 
     // ���⳻��
 	 String SubmtCont = objParams.getParamValue("SubmtCont"); 
 	 objUpdateData.add(SubmtCont); 
 	 //System.out.println("[SGovSubDataUpdateProc.jsp][add] SubmtCont =" + SubmtCont);
    
	 boolean strSQLType = true;
	 boolean blnResult = true;
	 
	 String strSubmtDataNextID = objParams.getParamValue("submtDataId");

 		
 		//System.out.println("[SGovSubDataUpdateProc.jsp] [���������ڷᰡ �ƴ� ����.]");	 
 	  	String PDFFilePath = objParams.getParamValue("PDFFilePath"); 		 	  	
		//System.out.println("[SGovSubDataUpdateProc.jsp]  PDFFilePath = " + PDFFilePath);

		if(PDFFilePath == null || PDFFilePath.equals("")){

			String strOldPdfFileName = objParams.getParamValue("strOldPdfFileName");
			String strOldPdfFile = strInsertYear + "/etc/" +  strOldPdfFileName;
			objUpdateData.add(strOldPdfFile);			
			//System.out.println("[SGovSubDataUpdateProc.jsp] strOldPdfFile = " + strOldPdfFile);

		}else{

			String strPDFFileName =   "pdf_" + strSubmtDataNextID + ".pdf" ;
			String strUpdatePDFFileName	= FileUtil.getFileName(PDFFilePath);
			String strReturnParam =  "GOV^" + strUpdatePDFFileName + "^" +strInsertYear +"^etc^" + strSubmtDataNextID;		 
			String strErrorReturnParam = "ERROR^GOV^" + strUpdatePDFFileName + "^" +strInsertYear +"^etc^" + strSubmtDataNextID;
			//System.out.println("[SGovSubDataInsertProc.jsp] strReturnParam = " + strReturnParam);		 
			
			intExtractTextResult = objUniFlowWrapper.GovSubmitExtractIndexText(strUpdatePDFFileName, strInsertYear ,strSubmtDataNextID,strReturnParam,strErrorReturnParam);
		 	
   		    //System.out.println("[SGovSubDataUpdateProc.jsp] ������ idx ���� ���� = " + intExtractTextResult);			
			
			//PDFFilePath = strFileSaveYearPath + "/" + strPDFFileName;
			PDFFilePath = "DB�����";
			objUpdateData.add(PDFFilePath); 	
			//System.out.println("[SGovSubDataUpdateProc.jsp] [DBQUREY VECTOR ADD] PDFFilePath =" + PDFFilePath);
		}
	 
 	  	String OrginalFilePath = objParams.getParamValue("OrginalFilePath");
		//System.out.println( "  *********** OrginalFilePath = " + OrginalFilePath + " ********* " );

		if(OrginalFilePath == null || OrginalFilePath.equals("")){
			String strOldOrgFileName = objParams.getParamValue("strOldOrgFileName");
			String strOldOrgFile = strInsertYear + "/etc/" + strOldOrgFileName;			
			objUpdateData.add(strOldOrgFile); 	
			//objUpdateData.add(strOldOrgFileName); 	
			//System.out.println("[SGovSubDataUpdateProc.jsp] strOldOrgFile = " + strOldOrgFile);
		}else{
			String strOrgFileName =(String)FileUtil.getFileName(OrginalFilePath);     	
			String strExtension = FileUtil.getFileExtension(strOrgFileName);
			strOrgFileName = "src_" + strSubmtDataNextID + "." + strExtension;     
			String strOrgSaveFilePath = strSaveFilePath + "/" + strOrgFileName;							 
			
			//System.out.println("[SGovSubDataUpdateProc.jsp] strOrgSaveFilePath =" + strOrgSaveFilePath);
			//System.out.println("[SGovSubDataUpdateProc.jsp]  OrginalFilePath = " + OrginalFilePath);
			blnResult = FileUtil.copyFile(OrginalFilePath,strOrgSaveFilePath);   
			//System.out.println("blnResult = " + blnResult);									
			
			OrginalFilePath = strFileSaveYearPath + "/" + strOrgFileName;
			objUpdateData.add(OrginalFilePath);
			//System.out.println("[SGovSubDataUpdateProc.jsp] [ADD] OrginalFilePath =" + OrginalFilePath);		
		}


	 	String TOCFilePath = objParams.getParamValue("TOCFilePath");    

		if(TOCFilePath == null || TOCFilePath.equals("")){
			String strOldTocFileName = objParams.getParamValue("strOldTocFileName");
			String strOldTocFile = strInsertYear + "/etc/" +  strOldTocFileName;			
			objUpdateData.add(strOldTocFile); 	
			//objUpdateData.add(strOldTocFileName); 	
			//System.out.println("[SGovSubDataUpdateProc.jsp] strOldTocFile = " + strOldTocFile);
		}else{

			String strTOCFileName =(String)FileUtil.getFileName(TOCFilePath);     	
			strTOCFileName = "toc_" + strSubmtDataNextID + ".toc";  
			String strTOCSaveFilePath = strSaveFilePath + "/" + strTOCFileName;
			//System.out.println("[SGovSubDataUpdateProc.jsp] strTOCSaveFilePath =" + strTOCSaveFilePath);
			//System.out.println("[SGovSubDataUpdateProc.jsp] TOCFilePath =" + TOCFilePath);
			blnResult = FileUtil.copyFile(TOCFilePath,strTOCSaveFilePath); 
			//System.out.println("blnResult = " + blnResult);

			TOCFilePath = strFileSaveYearPath + "/" + strTOCFileName;
			objUpdateData.add(TOCFilePath); 	 
			//System.out.println("[SGovSubDataUpdateProc.jsp] [ADD] TOCFilePath = " + TOCFilePath); 	  	    
		}

 	  	// �䱸����� ����ȸ���� Ȯ���ϴ� �ڵ� 001 ������ 002 ��ȸ������åó 004 ����ȸ
		String strDlbrtHighOrganID = objParams.getParamValue("strReqOrganCd"); 
		//objUpdateData.add(strDlbrtHighOrganID); 
		//System.out.println("[SGovSubDataUpdateProc.jsp] [ADD] strDlbrtHighOrganID = " + strDlbrtHighOrganID); 	  	    

		// 
		if(strDlbrtHighOrganID == "004" || strDlbrtHighOrganID.equals("004")){
		 	 objUpdateData.add(strReqOrganId);
		}else{
			 objUpdateData.add("");
		}
		
		
		//System.out.println(" strSubmtDataNextID = " + strSubmtDataNextID);
		objUpdateData.add(strSubmtDataNextID); 
		
		for(int i = 0 ; i < objUpdateData.size() ; i++){
			String dd	= (String)objUpdateData.get(i);
			//System.out.println("���� = " +dd);
		}		

 	    intResult = objSubmtDataDelegate.getGovSubmtDataUpdate(objUpdateData,strGbnCode,strSQLType);
 	     
 	
	 
	 if(intResult < 0){// || intExtractTextResult < 0 ){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0010"); //��Ͽ���
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%	  	
	 }else{


 /*************************************************************************************************/
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
	<html>
	<script language="JavaScript">
		function init(){
			alert("ȸ���ڷ����� ������ �����Ǿ����ϴ� ");
			formName.submit();
		}
	</script>
	<body onLoad="init()">
					<form name="formName" method="get" action="./SGovSubDataBoxList.jsp" ><!--�䱸�� �ű����� ���� -->
					    <input type="hidden" name="strAnsSubmtQryField" value="<%=objParams.getParamValue("strAnsSubmtQryField")%>">
						<input type="hidden" name="strAnsSubmtQryTerm" value="<%=objParams.getParamValue("strAnsSubmtQryTerm")%>">
						<input type="hidden" name="strGovSubmtDataPageNum" value="<%=objParams.getParamValue("strGovSubmtDataPageNum")%>">
						<input type="hidden" name="strGovSubmtDataSortField" value="<%=objParams.getParamValue("strGovSubmtDataSortField")%>">
						<input type="hidden" name="strGovSubmtDataSortMtd" value="<%=objParams.getParamValue("strGovSubmtDataSortMtd")%>">
					</form>
	</body>
	</html>
<%
	}
%>
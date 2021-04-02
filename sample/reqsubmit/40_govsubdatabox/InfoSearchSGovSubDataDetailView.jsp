<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>



<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	String  strGovSubmtDataId = null;
	String  strGovSubmtDataSortField = null;
	String  strGovSubmtDataSortMtd = null;
	String  strGovSubmtDataPageNum = null;
	String  strAnsSubmtQryTerm = null;
	String  strAnsSubmtQryField = null;
	
	String strSubmtOrganNm = null;
	String strSubmtDataCont = null;
	String strPdfFilePath = null;
	String strOrgFilePath = null;
	String strTocFilePath = null;
	String strReqOrganNm = null;//�䱸��� ID (�����ID)
	//String strReqOrganId = null;
	String strUserNm = null;
	String strSubmtDate = null;
	String strSelCodeName = null;   //���������ڷ� �ڵ��̸�
	String strGovSubmtYear = null; // �����ش�⵵
	String strGovDlbrtHighOrganID = null; //  ����� ID(�䱸��� ID)
	//String strGovSubmtDataID = null; // ���������ڷ� id
	
	boolean blnCheck = false;
	
	SGovSubmtDataDelegate objGovSubmtData = null;
	UserInfoDelegate objUser = null;
	 FileUtil objFileUtil = new FileUtil();
	
	objUser = new UserInfoDelegate(request);

	String strGbnCode = null;
	String strOrganId = null;
	strGbnCode = objUser.getOrganGBNCode();   // 003:�ǿ��� 004:����ȸ (����), 006:������ (���)
	System.out.println("��� ����  strGbnCode = " + strGbnCode );
	strOrganId = objUser.getOrganID();
	System.out.println("�䱸 ���  strOrganId = " + strOrganId );
	String strUserID =	objUser.getUserID();
	String strUserName = objUser.getUserName();
	
 
/*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

	//����� ID
	//strReqOrganId =  (String)request.getParameter("strReqOrganId");
	//System.out.println("[SGovSubDataDetailView.jsp] strReqOrganId = " + strReqOrganId);	
			   	
	//������� 
	//strReqOrganNm =  StringUtil.toMulti((String)(request.getParameter("strReqOrganNm")));
	//System.out.println("[SGovSubDataDetailView.jsp] strReqOrganNm = " + strReqOrganNm);

	//���������ڷ��� id
	strGovSubmtDataId =  (String)request.getParameter("strGovSubmtDataId");
	System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataId = " + strGovSubmtDataId);
	
	//�˻���
	strAnsSubmtQryTerm =  (String)request.getParameter("strAnsSubmtQryTerm");
	System.out.println("strAnsSubmtQryTerm ="  + strAnsSubmtQryTerm);
	if(strAnsSubmtQryTerm != null){
		strAnsSubmtQryTerm =  StringUtil.toMulti(request.getParameter("strAnsSubmtQryTerm"));
	}
	System.out.println("[SGovSubDataDetailView.jsp] strAnsSubmtQryTerm = " + strAnsSubmtQryTerm);

	//�˻��ʵ�
	strAnsSubmtQryField =  (String)request.getParameter("strAnsSubmtQryField");	
	System.out.println("[SGovSubDataDetailView.jsp] strAnsSubmtQryField = " + strAnsSubmtQryField);
	
	// ���� �ʵ弱�� (���������ڷ��ڵ�)
	strGovSubmtDataSortField =  (String)request.getParameter("strGovSubmtDataSortField");
	if(strGovSubmtDataSortField == null){
			strGovSubmtDataSortField = "REG_DT";
	}
	System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataSortField = " + strGovSubmtDataSortField);
    
	// ���� ����
 	strGovSubmtDataSortMtd=  (String)request.getParameter("strGovSubmtDataSortMtd");
	if(strGovSubmtDataSortMtd == null){
			strGovSubmtDataSortMtd = "DESC";
	}
		System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataSortMtd = " + strGovSubmtDataSortMtd);
	// ���� ������ ��ȣ �ޱ�.
	strGovSubmtDataPageNum = (String)request.getParameter("strGovSubmtDataPageNum");
	if(strGovSubmtDataPageNum == null){
		strGovSubmtDataPageNum = "1";
	}
	System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);
	

	Hashtable objhash = null;
	
	objGovSubmtData = new SGovSubmtDataDelegate();
	
	objhash = objGovSubmtData.getGovSubmtDetailView(strGovSubmtDataId);
	
	
	String strGbnKindCode = (String)( (Vector)objhash.get("SUBMT_DATA_GBN") ).elementAt(0);	 //���� 	
	System.out.println("  ******* strGbnKindCode  =  " + strGbnKindCode + " ********** " );

	if(strGbnKindCode == "001" || strGbnKindCode.equals("001") || strGbnKindCode == "002" || strGbnKindCode.equals("002")){
		blnCheck = true;
	}else{
		blnCheck = false;
	}
    System.out.println("  ******* blnCheck  =  " + blnCheck + " ********** " );

	strSelCodeName = (String)( (Vector)objhash.get("CD_NM") ).elementAt(0);			//���������ڷ��ڵ��̸�
  	strSubmtOrganNm = (String)( (Vector)objhash.get("ORGAN_NM") ).elementAt(0); 			 //��������
	strReqOrganNm = (String)( (Vector)objhash.get("REQ_ORGAN_NM") ).elementAt(0); 	  //�������(�䱸�����)
    strUserNm = (String)( (Vector)objhash.get("USER_NM") ).elementAt(0);   				    // ����ڸ�    
  	strSubmtDataCont = (String)( (Vector)objhash.get("DATA_NM") ).elementAt(0);  			//���⳻��
    strSubmtDataCont  = StringUtil.getDescString(strSubmtDataCont);
  	strPdfFilePath  = (String)( (Vector)objhash.get("APD_PDF_FILE_PATH") ).elementAt(0);	//PDF�����н�
  	strPdfFilePath = FileUtil.getFileSeparatorPath(strPdfFilePath);
  	strPdfFilePath = FileUtil.getFileName(strPdfFilePath);
  	System.out.println("[SGovSubDataDetailView.jsp] strPdfFilePath =" + strPdfFilePath);
  	
  	strOrgFilePath =(String)( (Vector)objhash.get("APD_ORG_FILE_PATH") ).elementAt(0); 	//���������н� 
  	strOrgFilePath = FileUtil.getFileSeparatorPath(strOrgFilePath);
  	strOrgFilePath = FileUtil.getFileName(strOrgFilePath);  	
  	System.out.println("[SGovSubDataDetailView.jsp] strOrgFilePath =" + strOrgFilePath);  	
  	
  	strTocFilePath =  (String)( (Vector)objhash.get("APD_TOC_FILE_PATH") ).elementAt(0); 	//TOC�����н�
  	strTocFilePath = FileUtil.getFileSeparatorPath(strTocFilePath);
  	strTocFilePath = FileUtil.getFileName(strTocFilePath);
  	System.out.println("[SGovSubDataDetailView.jsp] strTocFilePath =" + strTocFilePath);
  	 
  	strSubmtDate =  (String)( (Vector)objhash.get("REG_DT") ).elementAt(0);  				//�������
	String strYear =strSubmtDate.substring(0,4); // �⵵ 

  	strGovSubmtYear =  (String)( (Vector)objhash.get("SUBMT_YEAR")).elementAt(0);  		//���� �ش� �⵵
  	strGovDlbrtHighOrganID =  (String)( (Vector)objhash.get("DLBRT_ORGAN_ID")).elementAt(0);  	//����� ID
  

	 String strFileNameInfo = strGovSubmtYear + "_" + strSelCodeName + "_" + strSubmtOrganNm;

	 //������ ����Ʈ : �ѱ�,word,powerpointer,excel,�ƹ�����,txt���� ,html����, toc���� , ��Ÿ���� 
%>
<script language="javascript">
	
 	function gotoUpdate(formName){
  		var varAction = formName.action;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataUpdate.jsp";
		formName.submit();
		formName.action = varAction;
    }
    
    function gotoList(formName){
  		var varAction = formName.action;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp";
		formName.submit();
		formName.action = varAction;
    }

    function gotoDelete(formName){
    
    	if(confirm("���������ڷ� ��Ͽ��� �����Ͻðڽ��ϱ� ?")==true){
  			var varAction = formName.action;
			formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataDelete.jsp";
			formName.submit();
			formName.action = varAction;
		}
    }
    
	function PDFfileDownLoad(govSubmtDataId,code){
		
			var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=" + code;	
			
			window.open(linkPath,"DowloadOrginalDocFile",	
			"resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=800,width=900" );	   
	
			/*window.open(linkPath,"DowloadOrginalDocFile",
			"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
			*/

		//var varAction = formName.action;
		//formName.action=linkPath;
		//formName.submit();
		//formName.action = varAction;
	}

	//function OrgFileDownLoad(orgFileName,orgNewFileName){
	function OrgFileDownLoad(govSubmtDataId,strFileName,strYearData){

		/*var varAction = formName.action;		
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GDOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.action=linkPath;
		formName.submit();
		formName.action = varAction;
*/

		var varTarget = formName.target;
		var varAction = formName.action;
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GDOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.method ="post";
		formName.action=linkPath;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction; 
			
			
	}
	
	function TocFileDownLoad(govSubmtDataId,strFileName,strYearData){
	
		var varTarget = formName.target;
		var varAction = formName.action;
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GTOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.method ="post";
		formName.action=linkPath;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction; 			
	}
	

    
</script>  	
<link href="/css/global.css"  rel="stylesheet" type="text/css" />
<link href="/css/System.css" rel="stylesheet" type="text/css">
<head>
<title>ȸ���ڷ� �����  �ڼ��� ���� </title>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr align="left" valign="top">
		<td width="186" height="470" background="/image/common/bg_leftMenu.gif">

		<td width="950">

<form name="formName" method="get" action="<%=request.getRequestURI()%>">
		<!--------------------------------------- ������� MAIN WORK AREA ���� �ڵ��� �����Դϴ�. ----------------------------->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top"> 
			  <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
			  <td align="left">
			  <table width="759" border="0" cellspacing="0" cellpadding="0">
				  <tr> 
					<td height="23" align="left" valign="top"></td>
				  </tr> 
				  <tr> 
					<td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">					
						<tr> 
						  <td width="50%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
								<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
								<span class="title">ȸ���ڷ� ����� �ڷ� ���� �˻�</span><strong>-ȸ���ڷ� ����� �󼼺���</strong>
						  </td>
						 <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
						  <td width="44%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
								<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
								<!--<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> -->
						  </td>		
					   </tr>
					   </td>
				  <tr> 
					<td height="30" align="left" class="text_s">
							<!-------------------- ���� �������� ���� ���� ��� ------------------------>
							����ȸ�� ���Ǹ� ��û�ϴ� �ڷ��� �� ������ Ȯ���ϽǼ� �ֽ��ϴ�.  
					</td>
				  </tr>
				  <tr> 
					<td height="5" align="left" class="soti_reqsubmit"></td>
				  </tr>
				  <tr> 
					<td height="30" align="left" class="soti_reqsubmit">
						<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
						<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
					  ȸ���ڷ� �����
					</td>
				  </tr>
				  <tr> 
					<td align="left" valign="top" class="soti_reqsubmit">

	<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->

						<table width="680" border="0" cellspacing="0" cellpadding="0">
							<tr class="td_reqsubmit"> 
							  <td width="160" height="2"></td>
							  <td height="2" colspan="3"></td>
							</tr>														
							<tr> 
							 <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
							���� �⵵ </td>
						     <td height="25" colspan="4" class="td_lmagin"><%=strGovSubmtYear%></td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							 <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
							���� </td>
						     <td height="25" colspan="4" class="td_lmagin"><%=strSelCodeName%></td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							 <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
							�����</td>
						    <td height="25" colspan="3" class="td_lmagin"><%=strReqOrganNm%></td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								������</td>
							  <td height="25"  class="td_lmagin">						
								<%=strSubmtOrganNm%>																			
							  </td>
							  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								�����</td>
							  <td height="25" class="td_lmagin">
								<%=strUserNm%>
							  </td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								���⳻��</td>
							  <td height="25" colspan="3" class="td_lmagin">
							  	<%=strSubmtDataCont%>
								<!--<textarea rows="3" cols="70" name="SubmtCont"  wrap="hard" class="textfield" style="WIDTH: 90% ; height: 80"></textarea>-->
							  </td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>  
							
							<tr>
								  <td height="25" class="td_gray1" width="160">
								  <img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								  ÷������
								  </td>
								  <td colspan="3">
<%
		if(!blnCheck){
%>												   
								   <table border="0" width="520">
										
										  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
											PDF </td>
										<td height="25" colspan="3" class="td_lmagin" >
 <%
								System.out.println("******* strPdfFilePath = " + strPdfFilePath);
								if(strPdfFilePath == "DB�����" || strPdfFilePath.equals("DB�����")){
									out.println("�����");								
								}else{
 %>
										<a href="javascript:PDFfileDownLoad('<%=strGovSubmtDataId%>','GPDF');">
										<img src="/image/common/icon_pdf.gif" border="0"></a>&nbsp;			   
  <% 						
										String strPdfFileName =  strFileNameInfo  + ".pdf";								
										out.println(strPdfFileName);
								}
  %> 	
  										</td>
										</tr>
										<tr height="1" class="tbl-line"> 
										  <td height="1"></td>
										  <td height="1" colspan="3"></td>
										</tr> 
									</table>
<%
	}else{
%>
								  <table border="0" width="520">
								   <tr> 
									   <td height="25" class="td_gray1">
									    <img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
										PDF </td>
									   <td height="25" colspan="3" class="td_lmagin" >
<%
								System.out.println("******* strPdfFilePath = " + strPdfFilePath);
								if(strPdfFilePath == "DB�����" || strPdfFilePath.equals("DB�����")){
									out.println("�����");								
								}else{
%>
										<a href="javascript:PDFfileDownLoad('<%=strGovSubmtDataId%>','GPDF');">
										<img src="/image/common/icon_pdf.gif" border="0"></a>&nbsp;
  <% //=strPdfFilePath								
									String strPdfFileName =  strFileNameInfo  + ".pdf";								
									out.println(strPdfFileName);
								}
  %> 
										</td>
								   </tr>
								   <tr height="1" class="tbl-line"> 
										  <td height="1"></td>
										  <td height="1" colspan="3"></td>
								   </tr> 
								   <tr>
									   <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ��������</td>
									   <td height="25" colspan="3" class="td_lmagin">
					<%
						String strExtension = FileUtil.getFileExtension(strOrgFilePath);						
						String strOrgFileName =  strFileNameInfo  + "." + strExtension;
						System.out.println(" strExtension = " + strExtension);
					%>
									   <a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>')">
					<% 												
						if(strExtension.equals("DOC") || strExtension.equals("doc")){
							System.out.println("doc �̴�");
					%>	
										<img src="/image/common/icon_word.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("HWP") || strExtension.equals("hwp")){ 
						    System.out.println("hwp �̴�");
					%>	
										<img src="/image/common/icon_hangul.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("GUL") || strExtension.equals("gul")){
							System.out.println("gul �̴�");
					%>	
										<img src="/image/common/icon_hun.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("TXT") || strExtension.equals("txt")){
							System.out.println("txt �̴�");
					%>	
										<img src="/image/common/icon_txt.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("HTML") || strExtension.equals("html") || strExtension.equals("HTM") || strExtension.equals("htm")){
							 System.out.println("html �̳� htm �̴�");
					%>	
										<img src="/image/common/icon_html.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("XLS") || strExtension.equals("xls")){
						System.out.println("xls �̴�");
					%>	
										<img src="/image/common/icon_excel.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("TOC") || strExtension.equals("toc")){
							System.out.println("toc �̴�");
					%>	
										<img src="/image/common/icon_toc.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("ppt") || strExtension.equals("PPT")){
						System.out.println("ppt �̴�");
					%>	
										<img src="/image/common/icon_ppt.gif" border="0"></a> &nbsp;
					<%
						}else{
						System.out.println("��Ÿ �̴�");
					%>
										<img src="/image/common/icon_etc.gif" border="0"></a> &nbsp;
					<%
						}
						out.println(strOrgFileName);
					%>
									   </td>
								   </tr>
								   <tr height="1" class="tbl-line"> 
									  <td height="1"></td>
									  <td height="1" colspan="3"></td>
									</tr>
								   <tr>
									   <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ��������</td>
									   <td height="25" colspan="3" class="td_lmagin">
					<%	
						String strTocFileName =  strFileNameInfo  + ".toc";
					%>
					<a href="javascript:TocFileDownLoad('<%=strGovSubmtDataId%>','<%=strTocFileName%>','<%=strYear%>');">
									   <img src="/image/common/icon_toc.gif" border="0">&nbsp;
									   </a>									  
									 <%
										out.println(strTocFileName);
									 %> 									   
									   
									   </td>   
									</tr>
									<tr height="1" class="tbl-line"> 
									  <td height="1"></td>
									  <td height="1" colspan="3"></td>
									</tr>
									 </table>
<%
	}
%>					   
								  </td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>  
						</table>	
					<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->                   
					</td>
				  </tr>
				  <tr>
					<!-- �����̽���ĭ -->
					<td>&nbsp;</td>
					<!-- �����̽���ĭ -->
				  </tr>
				  <tr>
					<td>
					<!----------------------- ���� ��ҵ� Form���� ��ư ���� ------------------------->
					 <table>
					   <tr>
						 <td>
<%
							//if(strUserName.equals(strUserNm) || strOrganId.equals(strGovDlbrtHighOrganID)){
							if(strOrganId.equals(strGovDlbrtHighOrganID)){
%>													 
							<!--img src="/image/button/bt_modify.gif"  height="20" border="0" onClick="gotoUpdate(formName)" style="cursor:hand" alt="��ϵ� �ڷḦ ������ �� �ֽ��ϴ�."-->&nbsp;
							<img src="/image/button/bt_delete.gif"  height="20" border="0" onClick="gotoDelete(formName)" style="cursor:hand" alt="��ϵ�  �ڷḦ ������ �� �ֽ��ϴ�.">&nbsp;
<%
							}
%>
						 </td>
					   </tr>
					</table>   
					<!----------------------- ���� ��ҵ� Form���� ��ư �� ------------------------->               	   
					</td>
				  </tr>  
			
			<input type="hidden" name="strGovSubmtYear" value="<%=strGovSubmtYear%>"><!--���� �ش� �⵵-->	     
			<input type="hidden" name="strSubmtDataCont" value="<%=strSubmtDataCont%>"><!--���⳻�� -->
			<input type="hidden" name="strGovSubmtDataId" value="<%=strGovSubmtDataId%>"><!--���������ڷ� ID -->     
			<input type="hidden" name="strOrganId" value="<%=strOrganId%>"><!--������ id ( ������ �ϰ��) -->
			<input type="hidden" name="strGbnKindCode" value="<%=strGbnKindCode%>"><!-- ���������ڷ� �ڵ� -->
			<input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--�˻��� -->
			<input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"> <!--�˻��ʵ� 000 �̸� ��ü -->			   
			<input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--���� �ʵ� --> 			   
			<input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">  <!--���� ���� --> 			   
			<input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- �������� --> 
			<input type="hidden" name="strSubmtDate" value="<%=strSubmtDate%>">  <!-- ������� --> 
			<input type="hidden" name="strPdfFilePath" value="<%=strPdfFilePath%>">  <!-- Pdf�����н� --> 
			<input type="hidden" name="strOrgFilePath" value="<%=strOrgFilePath%>">  <!-- ���������н� --> 
			<input type="hidden" name="strTocFilePath" value="<%=strTocFilePath%>">  <!-- Toc�����н� --> 
			
			<input type="hidden" name="strReqOrganNm" value="<%=strReqOrganNm%>"><!--���� ������� -->	   
<input type="hidden" name="strGovDlbrtHighOrganID" value="<%=strGovDlbrtHighOrganID%>"><!--�����id (�䱸���ID)-->	      

			  </table>
			  </td>
			</tr>
		</table>
		<!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->     </form>


		</td>
	  </tr>
	</table>

</body>
</html>
<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.util.Vector"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="java.io.UnsupportedEncodingException"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>
<%
	/******************************************************************************
	* Name		  : SGovSubDataUpdate.jsp
	* Summary	  : ���������ڷ��� ����.
	* Description : ���������ڷ��� ���� ȭ�� ����. 				
	******************************************************************************/
	 //����� ID
	 String strReqOrganID = null;
	  //���⳻��
	 String strSubmtDataCont = null;

	 //����⵵
	 String strGovSubmtYear = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtYear")));
	 //���⳻��
	 //String strSubmtDataCont = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strSubmtDataCont")));	
	 //���������ڷ� id
	 String strGovSubmtDataId = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataId"));
	 //����� id
	 //String strReqOrganId = StringUtil.getEmptyIfNull((String)request.getParameter("strReqOrganId")); 
	 //������ id
	 String strOrganId = StringUtil.getEmptyIfNull((String)request.getParameter("strOrganId"));
	 //���������ڷᱸ���ڵ�
	 String strGbnCode = StringUtil.getEmptyIfNull((String)request.getParameter("strGbnKindCode")); 
	 //�������
   	 String strRegDt = StringUtil.getEmptyIfNull((String)request.getParameter("strSubmtDate")); 
	 //�˻���
	 String strAnsSubmtQryTerm = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryTerm")));
	 //�˻����ʵ�
	 String strAnsSubmtQryField = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryField")));
	 //�˻��ʵ�
	 String strGovSubmtDataSortField = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortField"));
	 //�˻�����(orderby �� �ʵ�)
	 String strGovSubmtDataSortMtd = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortMtd"));
	 //��������
	 String strGovSubmtDataPageNum = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataPageNum"));
	 //������� 
	 String strReqOrganNm = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strReqOrganNm"))); 
	 //PDF ���� �̸�
	 String strOldPdfFileName = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strPdfFilePath"))); 
	 //���� ���� �̸�
	 String strOldOrgFileName = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strOrgFilePath"))); 
	 //TOC �����̸�
	 String strOldTocFileName = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strTocFilePath"))); 
	 //����� id
	 String strGovDlbrtHighOrganID = StringUtil.getEmptyIfNull((String)request.getParameter("strGovDlbrtHighOrganID")); 
	
	 //System.out.println("[SGovSubDataUpdate.jsp] strReqOrganId = " + strReqOrganId);
	 
	 boolean blnUserInfo = false;
	 
	 /*
	 System.out.println("[SGovSubDataUpdate.jsp] strOrganId = " + strOrganId);
	 System.out.println("[SGovSubDataUpdate.jsp] strGbnCode = " + strGbnCode); //���������� �ڷ��ڵ�
	 System.out.println("[SGovSubDataUpdate.jsp] strGovSubmtDataSortField = " + strGovSubmtDataSortField);
	 System.out.println("[SGovSubDataUpdate.jsp] strGovSubmtDataSortMtd = " + strGovSubmtDataSortMtd);
	 System.out.println("[SGovSubDataUpdate.jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);
	 System.out.println("[SGovSubDataUpdate.jsp] strAnsSubmtQryTerm  = " + strAnsSubmtQryTerm);
	 System.out.println("[SGovSubDataUpdate.jsp] strAnsSubmtQryField  = " + strAnsSubmtQryField);
	 System.out.println("[SGovSubDataUpdate.jsp] strOldPdfFileName = " + strOldPdfFileName);
	 System.out.println("[SGovSubDataUpdate.jsp] strOldOrgFileName = " + strOldOrgFileName);
	 System.out.println("[SGovSubDataUpdate.jsp] strOldTocFileName = " + strOldTocFileName);
	 System.out.println("[SGovSubDataUpdate.jsp] strGovDlbrtHighOrganID = " + strGovDlbrtHighOrganID);
	 System.out.println("[SGovSubDataUpdate.jsp] strGovSubmtDataId = " + strGovSubmtDataId);
	 */   
	 SGovSubmtDataDelegate obGovSmdata = new SGovSubmtDataDelegate();
	 Hashtable objHash = null;
	
	 UserInfoDelegate objUser = new UserInfoDelegate(request);	
	 String strUserGbnCode = objUser.getOrganGBNCode();
	 //System.out.println("[SGovSubDataUpdate.jsp] strUserGbnCode = " + strUserGbnCode);
	 
	 strOrganId = objUser.getOrganID();
	 
	 //objHash = obGovSmdata.getChargeUserInfo(strOrganId);
	 objHash = obGovSmdata.getGovSubmtDetailView(strGovSubmtDataId);
	
     // PDF�����н�
	 //String strOldPdfFile  = (String)( (Vector)objHash.get("APD_PDF_FILE_PATH") ).elementAt(0);	

	 // ��������
	 String strOrganNm  =  (String)((Vector)objHash.get("ORGAN_NM") ).elementAt(0); 
	 System.out.println("[SGovSubDataUpdate.jsp]  strOrganNm ="  +strOrganNm);
	 // �����.
	 String strUserNm =	 (String)( (Vector)objHash.get("USER_NM") ).elementAt(0); 
	 //System.out.println("[SGovSubDataUpdate.jsp]  strUserNm =" + strUserNm);
	 
	 strSubmtDataCont =	 (String)( (Vector)objHash.get("DATA_NM") ).elementAt(0); 
	 strSubmtDataCont = StringUtil.ReplaceString(strSubmtDataCont,"\r","");
     strSubmtDataCont = StringUtil.ReplaceString(strSubmtDataCont,"\n","");
	 String strSelCodeName = null;
	 
	 boolean blnCheckGvoSumbtDataResult = false;
%>

<html>
<head>
<%
	try{
		 blnUserInfo = objUserInfo.isRequester(); 
	}catch(Exception e){		 
    } 
	if(blnUserInfo){ // �䱸��
%>
	<title><%=MenuConstants.GOV_SUBMT_REQ_DATA_BOX%> > <%=MenuConstants.GOV_SUBMT_DATA_UPDATE%> </title>
<%
	}else{
%>
	<title><%=MenuConstants.GOV_SUBMT_DATA_BOX%> > <%=MenuConstants.GOV_SUBMT_DATA_UPDATE%> </title>	
<%
	}
%>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
<%
    Hashtable objFirstSortHash =  obGovSmdata.getSubmtMSortData();
 	//���������ڷ� ����� �޺� �ڽ��� �ڷ� �ֱ����� Array�� ������ �־��ִ� �κ�.
	Integer intFieldCnt = (Integer)objFirstSortHash.get("FETCH_COUNT"); 	
    out.println("var form;");
	out.println("var arrCmtSubmtOrgans=new Array(" + intFieldCnt.intValue() + ");");
	for(int i=0; i < intFieldCnt.intValue();i++){
	    out.println("arrCmtSubmtOrgans[" + i + "]=new Array('" +
						(String)( (Vector)objFirstSortHash.get("ORGAN_KIND") ).elementAt(i)	+ "','" +
						(String)( (Vector)objFirstSortHash.get("ORGAN_ID") ).elementAt(i) + "','" +
						(String)( (Vector)objFirstSortHash.get("ORGAN_NM") ).elementAt(i) + "');" );
	}//endfor
%>

  /** ���������� ���п� ���� ÷������ ��� ��ȭ*/
  function makeHtmlInsertForm(GovSubmtDataType){
	     // ����� ��� ��ݰ�� �ϰ��
		//if(GovSubmtDataType == 002 || GovSubmtDataType == 003 || GovSubmtDataType == 006){
			var str = "";
			str = str +	"<table border=\"0\" width=\"520\">";
			str = str + "<tr>";
			str = str + " <td height=\"25\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\"> PDF </td> ";
			str = str + " <td height=\"25\" colspan=\"3\" class=\"td_lmagin\">" ;
			str = str + "	<input type=\"file\" name=\"PDFFilePath\" size=\"50\"  class=\"textfield\">";					
			str = str + " </td>";
		    str = str + "</tr>";
			str = str + "<tr height=\"1\" class=\"tbl-line\">"; 
	 	    str = str + "<td height=\"1\"></td>";
			str = str + "<td height=\"1\" colspan=\"3\"></td>";
 			str = str + "</tr>";
			str = str + "<tr>"; 
			str = str + "<td height=\"25\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">" ;
			str = str + " �������� </td>";
			str = str + " <td height=\"25\" colspan=\"3\" class=\"td_lmagin\">";
			str = str + "<input type=\"file\" name=\"OrginalFilePath\" size=\"50\"  class=\"textfield\">";
			str = str + " </td>";
			str = str + " </tr>";
			str = str + " <tr height=\"1\" class=\"tbl-line\"> ";
			str = str + " <td height=\"1\"></td>";
			str = str + "<td height=\"1\" colspan=\"3\"></td>";
			str = str + "</tr>  ";                 
			str = str + " <tr> ";
			str = str + " <td height=\"25\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" ";
			str = str + " height=\"6\">";
			str = str + " �������� </td>";
			str = str + "<td height=\"25\" colspan=\"3\" class=\"td_lmagin\">";
			str = str + "<input type=\"file\" name=\"TOCFilePath\" size=\"50\"  class=\"textfield\">";
			str = str + "</td>";
			str = str + " </tr>";
			str = str + "<tr height=\"1\" class=\"tbl-line\"> ";
			str = str + "  <td height=\"1\"></td>";
			str = str + "  <td height=\"1\" colspan=\"3\"></td>";
			str = str + " </tr>";
			str = str + "</table>";

		    document.all.inputDiv.innerHTML = str;			

		/*}else{// ����� �����̿��� �ڵ��ϰ��
			var str = "";
			str = str +	"<table border=\"0\" width=\"520\">";
			str = str + "<tr>";
			str = str + " <td height=\"25\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\"> PDF </td> ";
			str = str + " <td height=\"25\" colspan=\"3\" class=\"td_lmagin\">" ;
			str = str + "	<input type=\"file\" name=\"PDFFilePath\" size=\"50\"  class=\"textfield\">";					
			str = str + " </td>";
		    str = str + "</tr>";
			str = str + "<tr height=\"1\" class=\"tbl-line\">"; 
	 	    str = str + "<td height=\"1\"></td>";
			str = str + "<td height=\"1\" colspan=\"3\"></td>";
 			str = str + "</tr>";
			document.all.inputDiv.innerHTML = str;
		}*/

  }



  /** ����ȸ ID ��ȭ�� ���� ������ ����Ʈ ��ȭ */
  function changeSubmtOrganList(value){
	var da= formName.GovSubmtDataType.options[formName.GovSubmtDataType.selectedIndex].value
    //makeHtmlInsertForm(da);
	//alert(formName.GovSubmtDataType.options[formName.GovSubmtDataType.selectedIndex].value);
  }//end of func	

  
// �亯 ������ ���� �Է� ���� �޶����Ƿ� ������ �ʼ��Է°��� ���� ���並 ����.. �־��ֽþ��~
  function checkSubmit() {
	var f = document.formName;
	var ansType = f.GovSubmtDataType.value;

	if(document.formName.SubmtCont.value == ""){ //elements['SubmtCont'].value==""){
		alert("�䱸�Ը���  �Է��ϼ���!!");
		formName.elements['SubmtCont'].focus();
		return false;
	} 

	// �����/����/��ݰ���� ���    var chckCode = <%=strGbnCode%>;
	/*if( ansType == "001" || ansType == "002" || ansType == "003"){
		//if(f.GovSubmtDataType.value != <%=strGbnCode%>){
			if (f.PDFFilePath.value == "") {
				alert("PDF ������ ������ �ּ���");
				f.PDFFilePath.focus();
				return;
			} else if (f.OrginalFilePath.value == "") {
				alert("���� ���� ������ ������ �ּ���");
				f.OrginalFilePath.focus();
				return;
			}else if (f.TOCFilePath.value == "") {
				alert("���� ������ ������ �ּ���");
				f.TOCFilePath.focus();
				return;
			}
		//}
	}else{
		if (f.PDFFilePath.value == "") {
			alert(" PDF ������ ������ �ּ���");
			f.PDFFilePath.focus();
			return;
		}
	}*/


	 if(CheckUploadFile(f) != false){
		if(f.TOCFilePath.value != "" ){
			 if(CheckUploadTocFile(f) != false){
				setReqOrganCD();
				f.method="post";
				//f.strHighReqOrganID.value = f.NextLevelReqOrganName.options[document.formName.NextLevelReqOrganName.selectedIndex].value
				f.action="/reqsubmit/40_govsubdatabox/SGovSubDataUpdateProc.jsp";
				f.submit();
			 }
		}else{
				setReqOrganCD();
				formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataUpdateProc.jsp";
				formName.submit();

		}
	 }
 }


 /* ������� ����ȸ���� Ȯ���Ҽ��մ� �ڵ尪����*/
 function setReqOrganCD(){
	var selectOrganId = document.formName.strReqOrganId.options[document.formName.strReqOrganId.selectedIndex].value;
	for(var i=0;i<arrCmtSubmtOrgans.length;i++){
	   var strTmpCmt=arrCmtSubmtOrgans[i][0]; //�䱸����ڵ�
	   var tmpOpt=new Option();
	   tmpOpt.value=arrCmtSubmtOrgans[i][1]; // �䱸���ID
	   tmpOpt.text=arrCmtSubmtOrgans[i][2]; // �䱸�����
		
	   if(arrCmtSubmtOrgans[i][1] == selectOrganId){
			document.formName.strReqOrganCd.value = strTmpCmt;
			break;
	   }		   
	}
 }

   function gotoList(formName,strGovSubmtDataId,strAnsSubmtQryTerm,strAnsSubmtQryField,strGovSubmtDataSortField,strGovSubmtDataSortMtd,strGovSubmtDataPageNum){
  		var varTarget = formName.target;
		var varAction = formName.action;
	
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataDetailView.jsp?strGovSubmtDataId=" + strGovSubmtDataId + "&strAnsSubmtQryTerm=" + strAnsSubmtQryTerm + "&strAnsSubmtQryField=" +strAnsSubmtQryField + "&strGovSubmtDataSortMtd=" + strGovSubmtDataSortMtd + "&strGovSubmtDataPageNum=" + strGovSubmtDataPageNum;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction; 

    }

	function CheckUploadFile(form)
	{
		var str=form.PDFFilePath.value;		
		if(str!="") {		
			var strExt=str.substring(str.length-3); //Ȯ���� ���
			strExt=strExt.toUpperCase();
			if(!(strExt=="PDF")){
				alert("Acrobat(*.pdf) ������ ����� �� �ֽ��ϴ�.");
				return false;
			}
		}
	}
	
	function CheckUploadTocFile(form)
	{
		var str=form.TOCFilePath.value;				
		var strExt=str.substring(str.length-3);//Ȯ���� ���.
		strExt=strExt.toUpperCase();
		if(!(strExt=="TOC")){
			alert("Ȯ���ڰ� (*.TOC) ���� ������ ��� �� �� �ֽ��ϴ�.");
			return false;
		}
	}

  function PdfFileOpen(strPath){
      var http =  "/reqsubmit/common/PDFView.jsp?PDF=" + strPath  ;
	  window.open(http,"PdfView",
		"resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );	
   }

   function PDFfileDownLoad(strDocFilePath){
   	        var strHttpFilePath = "/reqsubmit/common/FileDownLoad.jsp?DOC=" + strDocFilePath;						
			
	}
</script>
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="../common/MenuTopReqsubmit.jsp" %>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr align="left" valign="top">
		<td width="186" height="470" background="/image/common/bg_leftMenu.gif">
		<%@ include file="../common/MenuLeftReqsubmit.jsp"%>
		</td>
     <!------------------------- 2004.06.02. ������ ����Ǹ鼭 �߰��� ���� START ------------------------------------->    
		<td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
           <tr height="24" valign="top"> 
	          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
	              <tr>
	                <td height="24"></td>
	              </tr>
	            </table>
	          </td>
            </tr>        
        <!------------------------- 2004.06.02. ������ ����Ǹ鼭 �߰��� ���� END ------------------------------------->    			
			<tr valign="top"> 
			  <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
			  <td align="left">
			  <table width="759" border="0" cellspacing="0" cellpadding="0">
<form name="formName3" method="post"  action="./SGovSubDataBoxList.jsp">	 
	  <input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--�˻��� -->
	  <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"> <!--�˻��ʵ� 001 �̸� ��ü -->
	  <input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--���� �ʵ� --> 			   
	  <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">  <!--���� ���� --> 			   
	  <input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- �������� --> 
</form>

<form name="formName" method="post" encType="multipart/form-data" action="./SGovSubDataUpdateProc.jsp">
				  <tr> 
					<td height="23" align="left" valign="top"></td>
				  </tr>
				  <tr> 
					<td height="23" align="left" valign="top">

					
<!-- ************************** Title �� Title Line ���� *********************************-->                            			
				<%
					if(blnUserInfo){ //�䱸���� �ϰ��
				%>	
					<table width=100% height=23 border=0 cellpadding=0 cellspacing=0> 
					  <tr> 
						<td width=11.0% background=/image/reqsubmit/bg_reqsubmit_tit.gif>
							<span class=title> 
							<%
								out.println(MenuConstants.GOV_SUBMT_REQ_DATA_BOX);
							%>
							</span>
						</td>
						<td width=47.0% align=left background=/image/common/bg_titLine.gif>&nbsp;</td>
						<td width=42.0% align=right background=/image/common/bg_titLine.gif class=text_s>
							<img src=/image/common/icon_navi.gif width=3 height=5 align=absmiddle>
							&nbsp;
							<%
								String strLocation = MenuConstants.GOTO_HOME + ">" + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > " +  MenuConstants.GOV_SUBMT_REQ_DATA_BOX + " > " + "<b>" + MenuConstants.GOV_SUBMT_DATA_UPDATE + "</b>";
								out.println(strLocation);
							%>
						</td>
					  </tr>
					 </table>	
				<%
					}else{
				%>
				
					 <table width=100% height=23 border=0 cellpadding=0 cellspacing=0>
						  <tr> 
							<td width=15.4% background=/image/reqsubmit/bg_reqsubmit_tit.gif>
								<span class=title>
								<%
									out.println(MenuConstants.GOV_SUBMT_DATA_BOX);
								%>
								</span></td><td width=43.6% align=left background=/image/common/bg_titLine.gif>&nbsp;
							</td>
							<td width=41.0% align=right background=/image/common/bg_titLine.gif class=text_s>
							<img src=/image/common/icon_navi.gif width=3 height=5 align=absmiddle>&nbsp;
							<%
								 String strLocation = MenuConstants.GOTO_HOME + ">" + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > " +  MenuConstants.GOV_SUBMT_DATA_BOX + " > " + "<b>" + MenuConstants.GOV_SUBMT_DATA_UPDATE + "</b>";
								 out.println(strLocation);
							%>
							</td>
						  </tr>
					 </table>	
				<%
					}
				%>
 <!-- ************************** Title �� Title Line ���㳡 *********************************-->                            	  
					  
					  
					  </td>
				  </tr>
				  <tr> 
					<td height="50" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>

                		 <!-- ȸ���ڷ����� -->����, �����, ���� ���� ���� ����� ���� �Ǵ� �ڷ� �� ���� ȸ�� ���࿡ �ʿ��� �ڷḦ ��ȸ �Ǵ� ���ñ������ ����Ͽ� ��ȣ Ȱ���� �� �ֵ��� �ϴ� ����� �����մϴ�
                </td>
				  </tr>
				  <tr> 
					<td height="5" align="left" class="soti_reqsubmit"></td>
				  </tr>
				  <tr> 
					<td height="30" align="left" class="soti_reqsubmit">
						<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
						<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
					  <%=MenuConstants.GOV_SUBMT_DATA_UPDATE%>
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
							  <td height="25" class="td_gray1" width="160">
							  <img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								���� �⵵ </td>
							  <td height="25" colspan="3" class="td_lmagin">
									<select name="strYear"   class="select">
									<%											  
										  //java.text.SimpleDateFormat dateFormat=new java.text.SimpleDateFormat("yyyy");
										  //int nCurYear=Integer.parseInt(dateFormat.format(new java.util.Date()));
											Integer ObjYear = new Integer(strGovSubmtYear);
											int intCurYear = ObjYear.intValue();
											for(int i=intCurYear-5; i<=intCurYear + 10;i++){
												out.print("<option value='" + i + "' ");
												if(i==intCurYear){
													out.print(" selected ");
												}
												out.println(">" + i + "</option>");
											}
									%>
							  		</select>
							  	</td>
							</tr>
							<tr> 
							  <td height="25" class="td_gray1" width="160">
							  <img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								���� </td>
							  <td height="25" colspan="3" class="td_lmagin">
							  		<select name="GovSubmtDataType" onChange="changeSubmtOrganList(this.value)"  class="select">													
									<%

										Hashtable objGbnCodeList = obGovSmdata.getGovSubmtDataGBNCodeList();
										int intSize = objGbnCodeList.size();
										Integer objInt =(Integer)objGbnCodeList.get("FETCH_COUNT");
										int intCount = objInt.intValue();
										String strGndCodeName = null;
										String strGbnCodeData = null;
							
										for( int i = 0 ; i < intCount ; i ++){
											 strGbnCodeData = (String)((Vector)objGbnCodeList.get("MSORT_CD")).elementAt(i);
											 //System.out.println(" strGbnCodeData = " + strGbnCodeData);
											 strGndCodeName = (String)((Vector)objGbnCodeList.get("CD_NM")).elementAt(i);
											 //System.out.println(" strGndCodeName = " + strGndCodeName);
									%>
											<option
									<%
											if(strGbnCodeData == strGbnCode || strGbnCodeData.equals(strGbnCode)){
												out.print(" selected ");
												strGbnCode = strGbnCodeData;
											}
									%>
													  value="<%=strGbnCodeData%>"><%=strGndCodeName%></option>
									<%
										} //FOR
									%>
									</select><!-- ���� ���� �ڷ� �ڵ� ���-->
							  </td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								�����</td>
							  <td height="25" colspan="3" class="td_lmagin">
									<select name="strReqOrganId" class="select">
							<%
								//Hashtable objFirstSortHash =  obGovSmdata.getSubmtMSortData();
								//Integer intFirstSortFieldCnt = (Integer)objFirstSortHash.get("FETCH_COUNT");
								//int intFirstCount= intFirstSortFieldCnt.intValue();
								// ����� �ߺз�
								String strFistMsortCd = null;
								String strFistMsortNm = null;
							
								for(int i=0; i < intFieldCnt.intValue() ; i++){
								 strFistMsortCd =(String)((Vector)objFirstSortHash.get("RNUM")).elementAt(i);
								 strReqOrganID =(String)((Vector)objFirstSortHash.get("ORGAN_ID")).elementAt(i);
								 strFistMsortNm =(String)((Vector)objFirstSortHash.get("ORGAN_NM")).elementAt(i);
								 out.println("<option value=\"" + strReqOrganID + "\" " +  StringUtil.getSelectedStr(strGovDlbrtHighOrganID,strReqOrganID) + ">" + strFistMsortNm + "</option>");
								}
							%>									
									 </select>
							  </td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								������</td>
							  <td height="25" class="td_lmagin" width="100">
							  <%=strOrganNm%>	
							  </td>
							  <td width="90" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								����� </td>
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
								<textarea rows="3" cols="70" name="SubmtCont"  wrap="hard" class="textfield" style="WIDTH: 90% ; height: 80"><%=strSubmtDataCont%></textarea>
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
<!--<DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:520; z-index:1; border-width:0px; border-style:none;">-->

								  <table border="0" width="520">
								   <tr> 
									   <td width = "100" height="25" class="td_gray1">
									    <img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
										PDF </td>
									   <td height="25" colspan="3" class="td_lmagin" >
									   <input type="file" name="PDFFilePath" value="<%=strOldPdfFileName%>" size="50" class="textfield">

				<%		
										String strYearData = strRegDt.substring(0,4);									
										String strPDFFilePathData = strYearData + "/etc/" + strOldPdfFileName;	
				%>
									  <a href="javascript:PdfFileOpen('<%=strPDFFilePathData%>');">
										 <img src="/image/button/bt_down_icon.gif" border="0" alt="PDF ������ �ٿ�ε� �ϽǼ� �ֽ��ϴ�."></a>
										 ��PDF������ �����Ͻø� ������ ������ �����Ͻ� ���Ϸ�<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ġ�մϴ�
									  </td>
								   </tr>
								   <tr height="1" class="tbl-line"> 
										  <td height="1"></td>
										  <td height="1" colspan="3"></td>
								   </tr> 					       
									   <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ��������</td>
									   <td height="25" colspan="3" class="td_lmagin">
											<input type="file" name="OrginalFilePath" value="<%=strOldOrgFileName%>" size="50" class="textfield">
				<%		
										//String strYearData = strRegDt.substring(0,4);									
										String strOrgFilePathData = strYearData + "/etc/" + strOldOrgFileName;
										String strOrgFileHttp = "/reqsubmit/common/FileDownLoad.jsp?DOC=" + strOrgFilePathData;
												
										if(strOldOrgFileName == "" || strOldOrgFileName.equals("")){
				%>
										 �ؿ��� ������ ������� �ʾҽ��ϴ�.
				<%
										}else{
				%>
										<a href="<%=strOrgFileHttp%>">																					
										 <img src="/image/button/bt_down_icon.gif" border="0" alt="���������� �ٿ�ε� �ϽǼ� �ֽ��ϴ�."></a>
										 �ؿ��������� �����Ͻø� ������ ������ �����Ͻ� ���Ϸ�<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ġ�մϴ�
				<%
										 }
				%>
									   </td>
								   </tr>					   
								   <tr height="1" class="tbl-line"> 
									  <td height="1"></td>
									  <td height="1" colspan="3"></td>
									</tr>
									<input type="hidden" name="TOCFilePath" value=""  size="50"   class="textfield">
									 </table>
<!--</DIV>-->						   
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
							<img src="/image/button/bt_save.gif"  height="20" border="0" onClick="checkSubmit()" style="cursor:hand" alt="������ ������ ���� �� �� �ֽ��ϴ�.">&nbsp;
							<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="formName.reset()" style="cursor:hand" alt="������ ������ ��� �� �� �ֽ��ϴ�.">&nbsp;	
							<img src="/image/button/bt_list.gif"  height="20" border="0" onClick="gotoList(formName,'<%=strGovSubmtDataId%>','<%=strAnsSubmtQryTerm%>','<%=strAnsSubmtQryField%>','<%=strGovSubmtDataSortField%>','<%=strGovSubmtDataSortMtd%>','<%=strGovSubmtDataPageNum%>');" style="cursor:hand" alt="ȸ���ڷ� �󼼺��� ȭ������ �̵� �� �� �ֽ��ϴ�.">&nbsp;
						 </td>
					   </tr>
					</table>   
					<!----------------------- ���� ��ҵ� Form���� ��ư �� ------------------------->
					</td>
				  </tr>			  			      
	  <input type="hidden" name="strGovSubmtYear" value="<%=strGovSubmtYear%>"> <!--���� �⵵ -->
	  <!--<input type="hidden" name="strReqOrganId" value="<%//=strReqOrganId%>"> ����� id  selet�� ���õ� ID-->
	  <input type="hidden" name="submtDataId" value="<%=strGovSubmtDataId%>"> <!--���������ڷ� ��ȣ -->
	  <input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--�˻��� -->
	  <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"> <!--�˻��ʵ� 001 �̸� ��ü -->
	  <input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--���� �ʵ� -->	
	  <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">  <!--���� ���� -->
	  <input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- �������� -->
	  <input type="hidden" name="strOldPdfFileName" value="<%=strOldPdfFileName%>">  <!-- ������ pdf ���ϸ� -->
	  <input type="hidden" name="strOldOrgFileName" value="<%=strOldOrgFileName%>">  <!-- ������ ���� ���ϸ� -->
	  <input type="hidden" name="strOldTocFileName" value="<%=strOldTocFileName%>">  <!-- ������ Toc ���ϸ�-->
	  <input type="hidden" name="strSubmtDataCont" value="<%=strSubmtDataCont%>"> <!--���� ���� -->
	  <input type="hidden" name="strOrganId" value="<%=strOrganId%>"> <!--������ ID -->
	  <input type="hidden" name="strGbnCode" value="<%=strGbnCode%>"> <!--���� �ڷ� �ڵ� -->
	  <input type="hidden" name="strReqOrganNm" value="<%=strReqOrganNm%>"> <!--������� -->
	  <input type="hidden" name="strReqOrganCd" value=""><!--����� �ڵ� 001 ������ 002 ��ȸ������åó 003 ����ȸ-->
	  <!--<input type="hidden" name="strGovDlbrtHighOrganID" value="<%//=strGovDlbrtHighOrganID%>"> �����-->
</form>
			  </table>
			  </td>
			</tr>
		</table>
		<!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->      
		</td>
	  </tr>
	</table>
<%@ include file="../../common/Bottom.jsp" %>
</body>
</html>              


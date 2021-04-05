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
	* Summary	  : 정부제출자료함 수정.
	* Description : 정부제출자료함 수정 화면 제공. 				
	******************************************************************************/
	 //담당기관 ID
	 String strReqOrganID = null;
	  //제출내용
	 String strSubmtDataCont = null;

	 //적용년도
	 String strGovSubmtYear = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtYear")));
	 //제출내용
	 //String strSubmtDataCont = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strSubmtDataCont")));	
	 //정부제출자료 id
	 String strGovSubmtDataId = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataId"));
	 //담당기관 id
	 //String strReqOrganId = StringUtil.getEmptyIfNull((String)request.getParameter("strReqOrganId")); 
	 //제출기관 id
	 String strOrganId = StringUtil.getEmptyIfNull((String)request.getParameter("strOrganId"));
	 //정부제출자료구분코드
	 String strGbnCode = StringUtil.getEmptyIfNull((String)request.getParameter("strGbnKindCode")); 
	 //등록일자
   	 String strRegDt = StringUtil.getEmptyIfNull((String)request.getParameter("strSubmtDate")); 
	 //검색어
	 String strAnsSubmtQryTerm = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryTerm")));
	 //검색어필드
	 String strAnsSubmtQryField = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryField")));
	 //검색필드
	 String strGovSubmtDataSortField = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortField"));
	 //검색순차(orderby 할 필드)
	 String strGovSubmtDataSortMtd = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortMtd"));
	 //페이지수
	 String strGovSubmtDataPageNum = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataPageNum"));
	 //담당기관명 
	 String strReqOrganNm = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strReqOrganNm"))); 
	 //PDF 파일 이름
	 String strOldPdfFileName = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strPdfFilePath"))); 
	 //원본 파일 이름
	 String strOldOrgFileName = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strOrgFilePath"))); 
	 //TOC 파일이름
	 String strOldTocFileName = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strTocFilePath"))); 
	 //담당기관 id
	 String strGovDlbrtHighOrganID = StringUtil.getEmptyIfNull((String)request.getParameter("strGovDlbrtHighOrganID")); 
	
	 //System.out.println("[SGovSubDataUpdate.jsp] strReqOrganId = " + strReqOrganId);
	 
	 boolean blnUserInfo = false;
	 
	 /*
	 System.out.println("[SGovSubDataUpdate.jsp] strOrganId = " + strOrganId);
	 System.out.println("[SGovSubDataUpdate.jsp] strGbnCode = " + strGbnCode); //정부제출함 자료코드
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
	
     // PDF문서패스
	 //String strOldPdfFile  = (String)( (Vector)objHash.get("APD_PDF_FILE_PATH") ).elementAt(0);	

	 // 제출기관명
	 String strOrganNm  =  (String)((Vector)objHash.get("ORGAN_NM") ).elementAt(0); 
	 System.out.println("[SGovSubDataUpdate.jsp]  strOrganNm ="  +strOrganNm);
	 // 등록자.
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
	if(blnUserInfo){ // 요구자
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
 	//정부제출자료 담당기관 콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
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

  /** 정부제출기관 구분에 따른 첨부파일 등록 변화*/
  function makeHtmlInsertForm(GovSubmtDataType){
	     // 예산안 결산 기금결산 일경우
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
			str = str + " 원본문서 </td>";
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
			str = str + " 목차파일 </td>";
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

		/*}else{// 예산안 결산안이외의 코드일경우
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



  /** 위원회 ID 변화에 따른 제출기관 리스트 변화 */
  function changeSubmtOrganList(value){
	var da= formName.GovSubmtDataType.options[formName.GovSubmtDataType.selectedIndex].value
    //makeHtmlInsertForm(da);
	//alert(formName.GovSubmtDataType.options[formName.GovSubmtDataType.selectedIndex].value);
  }//end of func	

  
// 답변 유형에 따라서 입력 폼이 달라지므로 유형별 필수입력값에 대한 강요를 하자.. 넣어주시어요~
  function checkSubmit() {
	var f = document.formName;
	var ansType = f.GovSubmtDataType.value;

	if(document.formName.SubmtCont.value == ""){ //elements['SubmtCont'].value==""){
		alert("요구함명을  입력하세요!!");
		formName.elements['SubmtCont'].focus();
		return false;
	} 

	// 예산안/결산안/기금결산일 경우    var chckCode = <%=strGbnCode%>;
	/*if( ansType == "001" || ansType == "002" || ansType == "003"){
		//if(f.GovSubmtDataType.value != <%=strGbnCode%>){
			if (f.PDFFilePath.value == "") {
				alert("PDF 파일을 선택해 주세요");
				f.PDFFilePath.focus();
				return;
			} else if (f.OrginalFilePath.value == "") {
				alert("원본 문서 파일을 선택해 주세요");
				f.OrginalFilePath.focus();
				return;
			}else if (f.TOCFilePath.value == "") {
				alert("목차 파일을 선택해 주세요");
				f.TOCFilePath.focus();
				return;
			}
		//}
	}else{
		if (f.PDFFilePath.value == "") {
			alert(" PDF 파일을 선택해 주세요");
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


 /* 담당기관이 위원회인지 확인할수잇는 코드값설정*/
 function setReqOrganCD(){
	var selectOrganId = document.formName.strReqOrganId.options[document.formName.strReqOrganId.selectedIndex].value;
	for(var i=0;i<arrCmtSubmtOrgans.length;i++){
	   var strTmpCmt=arrCmtSubmtOrgans[i][0]; //요구기관코드
	   var tmpOpt=new Option();
	   tmpOpt.value=arrCmtSubmtOrgans[i][1]; // 요구기관ID
	   tmpOpt.text=arrCmtSubmtOrgans[i][2]; // 요구기관명
		
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
			var strExt=str.substring(str.length-3); //확장자 얻기
			strExt=strExt.toUpperCase();
			if(!(strExt=="PDF")){
				alert("Acrobat(*.pdf) 문서만 등록할 수 있습니다.");
				return false;
			}
		}
	}
	
	function CheckUploadTocFile(form)
	{
		var str=form.TOCFilePath.value;				
		var strExt=str.substring(str.length-3);//확장자 얻기.
		strExt=strExt.toUpperCase();
		if(!(strExt=="TOC")){
			alert("확장자가 (*.TOC) 파일 문서만 등록 할 수 있습니다.");
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
     <!------------------------- 2004.06.02. 디자인 변경되면서 추가된 사항 START ------------------------------------->    
		<td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
           <tr height="24" valign="top"> 
	          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
	              <tr>
	                <td height="24"></td>
	              </tr>
	            </table>
	          </td>
            </tr>        
        <!------------------------- 2004.06.02. 디자인 변경되면서 추가된 사항 END ------------------------------------->    			
			<tr valign="top"> 
			  <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
			  <td align="left">
			  <table width="759" border="0" cellspacing="0" cellpadding="0">
<form name="formName3" method="post"  action="./SGovSubDataBoxList.jsp">	 
	  <input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--검색어 -->
	  <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"> <!--검색필드 001 이면 전체 -->
	  <input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--정렬 필드 --> 			   
	  <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">  <!--정렬 방향 --> 			   
	  <input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- 페이지수 --> 
</form>

<form name="formName" method="post" encType="multipart/form-data" action="./SGovSubDataUpdateProc.jsp">
				  <tr> 
					<td height="23" align="left" valign="top"></td>
				  </tr>
				  <tr> 
					<td height="23" align="left" valign="top">

					
<!-- ************************** Title 과 Title Line 맞춤 *********************************-->                            			
				<%
					if(blnUserInfo){ //요구자자 일경우
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
 <!-- ************************** Title 과 Title Line 맞춤끝 *********************************-->                            	  
					  
					  
					  </td>
				  </tr>
				  <tr> 
					<td height="50" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>

                		 <!-- 회의자료함은 -->법안, 예결산, 국감 등의 업무 수행시 참고가 되는 자료 및 각종 회의 진행에 필요한 자료를 국회 또는 관련기관에서 등록하여 상호 활용할 수 있도록 하는 기능을 제공합니다
                </td>
				  </tr>
				  <tr> 
					<td height="5" align="left" class="soti_reqsubmit"></td>
				  </tr>
				  <tr> 
					<td height="30" align="left" class="soti_reqsubmit">
						<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
						<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
					  <%=MenuConstants.GOV_SUBMT_DATA_UPDATE%>
					</td>
				  </tr>
				  <tr> 
					<td align="left" valign="top" class="soti_reqsubmit">
<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
						<table width="680" border="0" cellspacing="0" cellpadding="0">
							<tr class="td_reqsubmit"> 
							  <td width="160" height="2"></td>
							  <td height="2" colspan="3"></td>
							</tr>
							<tr> 
							  <td height="25" class="td_gray1" width="160">
							  <img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								적용 년도 </td>
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
								구분 </td>
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
									</select><!-- 정부 제출 자료 코드 목록-->
							  </td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								담당기관</td>
							  <td height="25" colspan="3" class="td_lmagin">
									<select name="strReqOrganId" class="select">
							<%
								//Hashtable objFirstSortHash =  obGovSmdata.getSubmtMSortData();
								//Integer intFirstSortFieldCnt = (Integer)objFirstSortHash.get("FETCH_COUNT");
								//int intFirstCount= intFirstSortFieldCnt.intValue();
								// 담당기관 중분류
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
								제출기관</td>
							  <td height="25" class="td_lmagin" width="100">
							  <%=strOrganNm%>	
							  </td>
							  <td width="90" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								등록자 </td>
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
								제출내용</td>
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
								  첨부파일
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
										 <img src="/image/button/bt_down_icon.gif" border="0" alt="PDF 파일을 다운로드 하실수 있습니다."></a>
										 ※PDF파일을 선택하시면 이전의 파일을 선택하신 파일로<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;대치합니다
									  </td>
								   </tr>
								   <tr height="1" class="tbl-line"> 
										  <td height="1"></td>
										  <td height="1" colspan="3"></td>
								   </tr> 					       
									   <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 원본파일</td>
									   <td height="25" colspan="3" class="td_lmagin">
											<input type="file" name="OrginalFilePath" value="<%=strOldOrgFileName%>" size="50" class="textfield">
				<%		
										//String strYearData = strRegDt.substring(0,4);									
										String strOrgFilePathData = strYearData + "/etc/" + strOldOrgFileName;
										String strOrgFileHttp = "/reqsubmit/common/FileDownLoad.jsp?DOC=" + strOrgFilePathData;
												
										if(strOldOrgFileName == "" || strOldOrgFileName.equals("")){
				%>
										 ※원본 파일을 등록하지 않았습니다.
				<%
										}else{
				%>
										<a href="<%=strOrgFileHttp%>">																					
										 <img src="/image/button/bt_down_icon.gif" border="0" alt="원본파일을 다운로드 하실수 있습니다."></a>
										 ※원본파일을 선택하시면 이전의 파일을 선택하신 파일로<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;대치합니다
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
	<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 -------------------------> 
					</td>
				  </tr>
				  <tr>
					<!-- 스페이스한칸 -->
					<td>&nbsp;</td>
					<!-- 스페이스한칸 -->
				  </tr>
				  <tr>
					<td>
					<!----------------------- 저장 취소등 Form관련 버튼 시작 ------------------------->
					 <table>
					   <tr>
						 <td>
							<img src="/image/button/bt_save.gif"  height="20" border="0" onClick="checkSubmit()" style="cursor:hand" alt="설정된 정보를 수정 할 수 있습니다.">&nbsp;
							<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="formName.reset()" style="cursor:hand" alt="설정된 정보를 취소 할 수 있습니다.">&nbsp;	
							<img src="/image/button/bt_list.gif"  height="20" border="0" onClick="gotoList(formName,'<%=strGovSubmtDataId%>','<%=strAnsSubmtQryTerm%>','<%=strAnsSubmtQryField%>','<%=strGovSubmtDataSortField%>','<%=strGovSubmtDataSortMtd%>','<%=strGovSubmtDataPageNum%>');" style="cursor:hand" alt="회의자료 상세보기 화면으로 이동 할 수 있습니다.">&nbsp;
						 </td>
					   </tr>
					</table>   
					<!----------------------- 저장 취소등 Form관련 버튼 끝 ------------------------->
					</td>
				  </tr>			  			      
	  <input type="hidden" name="strGovSubmtYear" value="<%=strGovSubmtYear%>"> <!--적용 년도 -->
	  <!--<input type="hidden" name="strReqOrganId" value="<%//=strReqOrganId%>"> 담당기관 id  selet로 선택된 ID-->
	  <input type="hidden" name="submtDataId" value="<%=strGovSubmtDataId%>"> <!--정부제출자료 번호 -->
	  <input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--검색어 -->
	  <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"> <!--검색필드 001 이면 전체 -->
	  <input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--정렬 필드 -->	
	  <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">  <!--정렬 방향 -->
	  <input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- 페이지수 -->
	  <input type="hidden" name="strOldPdfFileName" value="<%=strOldPdfFileName%>">  <!-- 기존의 pdf 파일명 -->
	  <input type="hidden" name="strOldOrgFileName" value="<%=strOldOrgFileName%>">  <!-- 기존의 원본 파일명 -->
	  <input type="hidden" name="strOldTocFileName" value="<%=strOldTocFileName%>">  <!-- 기존의 Toc 파일명-->
	  <input type="hidden" name="strSubmtDataCont" value="<%=strSubmtDataCont%>"> <!--제출 내용 -->
	  <input type="hidden" name="strOrganId" value="<%=strOrganId%>"> <!--제출기관 ID -->
	  <input type="hidden" name="strGbnCode" value="<%=strGbnCode%>"> <!--제출 자료 코드 -->
	  <input type="hidden" name="strReqOrganNm" value="<%=strReqOrganNm%>"> <!--담당기관명 -->
	  <input type="hidden" name="strReqOrganCd" value=""><!--담당기관 코드 001 법제실 002 국회예산정책처 003 위원회-->
	  <!--<input type="hidden" name="strGovDlbrtHighOrganID" value="<%//=strGovDlbrtHighOrganID%>"> 담당기관-->
</form>
			  </table>
			  </td>
			</tr>
		</table>
		<!--------------------------------------- 여기까지  MAIN WORK AREA 실제 코딩의 끝입니다. ----------------------------->      
		</td>
	  </tr>
	</table>
<%@ include file="../../common/Bottom.jsp" %>
</body>
</html>              


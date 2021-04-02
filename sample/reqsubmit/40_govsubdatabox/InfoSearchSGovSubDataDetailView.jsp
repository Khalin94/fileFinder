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
	String strReqOrganNm = null;//요구기관 ID (담당기관ID)
	//String strReqOrganId = null;
	String strUserNm = null;
	String strSubmtDate = null;
	String strSelCodeName = null;   //정부제출자료 코드이름
	String strGovSubmtYear = null; // 제출해당년도
	String strGovDlbrtHighOrganID = null; //  담당기관 ID(요구기관 ID)
	//String strGovSubmtDataID = null; // 정부제출자료 id
	
	boolean blnCheck = false;
	
	SGovSubmtDataDelegate objGovSubmtData = null;
	UserInfoDelegate objUser = null;
	 FileUtil objFileUtil = new FileUtil();
	
	objUser = new UserInfoDelegate(request);

	String strGbnCode = null;
	String strOrganId = null;
	strGbnCode = objUser.getOrganGBNCode();   // 003:의원실 004:위원회 (보기), 006:제출기관 (등록)
	System.out.println("기관 구분  strGbnCode = " + strGbnCode );
	strOrganId = objUser.getOrganID();
	System.out.println("요구 기관  strOrganId = " + strOrganId );
	String strUserID =	objUser.getUserID();
	String strUserName = objUser.getUserName();
	
 
/*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

	//담당기관 ID
	//strReqOrganId =  (String)request.getParameter("strReqOrganId");
	//System.out.println("[SGovSubDataDetailView.jsp] strReqOrganId = " + strReqOrganId);	
			   	
	//담당기관명 
	//strReqOrganNm =  StringUtil.toMulti((String)(request.getParameter("strReqOrganNm")));
	//System.out.println("[SGovSubDataDetailView.jsp] strReqOrganNm = " + strReqOrganNm);

	//정부제출자료함 id
	strGovSubmtDataId =  (String)request.getParameter("strGovSubmtDataId");
	System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataId = " + strGovSubmtDataId);
	
	//검색어
	strAnsSubmtQryTerm =  (String)request.getParameter("strAnsSubmtQryTerm");
	System.out.println("strAnsSubmtQryTerm ="  + strAnsSubmtQryTerm);
	if(strAnsSubmtQryTerm != null){
		strAnsSubmtQryTerm =  StringUtil.toMulti(request.getParameter("strAnsSubmtQryTerm"));
	}
	System.out.println("[SGovSubDataDetailView.jsp] strAnsSubmtQryTerm = " + strAnsSubmtQryTerm);

	//검색필드
	strAnsSubmtQryField =  (String)request.getParameter("strAnsSubmtQryField");	
	System.out.println("[SGovSubDataDetailView.jsp] strAnsSubmtQryField = " + strAnsSubmtQryField);
	
	// 정렬 필드선택 (정보제출자료코드)
	strGovSubmtDataSortField =  (String)request.getParameter("strGovSubmtDataSortField");
	if(strGovSubmtDataSortField == null){
			strGovSubmtDataSortField = "REG_DT";
	}
	System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataSortField = " + strGovSubmtDataSortField);
    
	// 정렬 순서
 	strGovSubmtDataSortMtd=  (String)request.getParameter("strGovSubmtDataSortMtd");
	if(strGovSubmtDataSortMtd == null){
			strGovSubmtDataSortMtd = "DESC";
	}
		System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataSortMtd = " + strGovSubmtDataSortMtd);
	// 정보 페이지 번호 받기.
	strGovSubmtDataPageNum = (String)request.getParameter("strGovSubmtDataPageNum");
	if(strGovSubmtDataPageNum == null){
		strGovSubmtDataPageNum = "1";
	}
	System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);
	

	Hashtable objhash = null;
	
	objGovSubmtData = new SGovSubmtDataDelegate();
	
	objhash = objGovSubmtData.getGovSubmtDetailView(strGovSubmtDataId);
	
	
	String strGbnKindCode = (String)( (Vector)objhash.get("SUBMT_DATA_GBN") ).elementAt(0);	 //구분 	
	System.out.println("  ******* strGbnKindCode  =  " + strGbnKindCode + " ********** " );

	if(strGbnKindCode == "001" || strGbnKindCode.equals("001") || strGbnKindCode == "002" || strGbnKindCode.equals("002")){
		blnCheck = true;
	}else{
		blnCheck = false;
	}
    System.out.println("  ******* blnCheck  =  " + blnCheck + " ********** " );

	strSelCodeName = (String)( (Vector)objhash.get("CD_NM") ).elementAt(0);			//정부제출자료코드이름
  	strSubmtOrganNm = (String)( (Vector)objhash.get("ORGAN_NM") ).elementAt(0); 			 //제출기관명
	strReqOrganNm = (String)( (Vector)objhash.get("REQ_ORGAN_NM") ).elementAt(0); 	  //담당기관명(요구기관명)
    strUserNm = (String)( (Vector)objhash.get("USER_NM") ).elementAt(0);   				    // 등록자명    
  	strSubmtDataCont = (String)( (Vector)objhash.get("DATA_NM") ).elementAt(0);  			//제출내용
    strSubmtDataCont  = StringUtil.getDescString(strSubmtDataCont);
  	strPdfFilePath  = (String)( (Vector)objhash.get("APD_PDF_FILE_PATH") ).elementAt(0);	//PDF문서패스
  	strPdfFilePath = FileUtil.getFileSeparatorPath(strPdfFilePath);
  	strPdfFilePath = FileUtil.getFileName(strPdfFilePath);
  	System.out.println("[SGovSubDataDetailView.jsp] strPdfFilePath =" + strPdfFilePath);
  	
  	strOrgFilePath =(String)( (Vector)objhash.get("APD_ORG_FILE_PATH") ).elementAt(0); 	//원본문서패스 
  	strOrgFilePath = FileUtil.getFileSeparatorPath(strOrgFilePath);
  	strOrgFilePath = FileUtil.getFileName(strOrgFilePath);  	
  	System.out.println("[SGovSubDataDetailView.jsp] strOrgFilePath =" + strOrgFilePath);  	
  	
  	strTocFilePath =  (String)( (Vector)objhash.get("APD_TOC_FILE_PATH") ).elementAt(0); 	//TOC문서패스
  	strTocFilePath = FileUtil.getFileSeparatorPath(strTocFilePath);
  	strTocFilePath = FileUtil.getFileName(strTocFilePath);
  	System.out.println("[SGovSubDataDetailView.jsp] strTocFilePath =" + strTocFilePath);
  	 
  	strSubmtDate =  (String)( (Vector)objhash.get("REG_DT") ).elementAt(0);  				//등록일자
	String strYear =strSubmtDate.substring(0,4); // 년도 

  	strGovSubmtYear =  (String)( (Vector)objhash.get("SUBMT_YEAR")).elementAt(0);  		//제출 해당 년도
  	strGovDlbrtHighOrganID =  (String)( (Vector)objhash.get("DLBRT_ORGAN_ID")).elementAt(0);  	//담당기관 ID
  

	 String strFileNameInfo = strGovSubmtYear + "_" + strSelCodeName + "_" + strSubmtOrganNm;

	 //아이콘 리스트 : 한글,word,powerpointer,excel,훈민정음,txt문서 ,html문서, toc파일 , 기타문서 
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
    
    	if(confirm("정부제출자료 목록에서 삭제하시겠습니까 ?")==true){
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
<title>회의자료 등록함  자세히 보기 </title>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr align="left" valign="top">
		<td width="186" height="470" background="/image/common/bg_leftMenu.gif">

		<td width="950">

<form name="formName" method="get" action="<%=request.getRequestURI()%>">
		<!--------------------------------------- 여기부터 MAIN WORK AREA 실제 코딩의 시작입니다. ----------------------------->
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
								<!-------------------- 타이틀을 입력해 주세요 ------------------------>
								<span class="title">회의자료 등록함 자료 문서 검색</span><strong>-회의자료 등록함 상세보기</strong>
						  </td>
						 <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
						  <td width="44%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
								<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
								<!--<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> -->
						  </td>		
					   </tr>
					   </td>
				  <tr> 
					<td height="30" align="left" class="text_s">
							<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
							위원회에 심의를 요청하는 자료의 상세 내용을 확인하실수 있습니다.  
					</td>
				  </tr>
				  <tr> 
					<td height="5" align="left" class="soti_reqsubmit"></td>
				  </tr>
				  <tr> 
					<td height="30" align="left" class="soti_reqsubmit">
						<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
						<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
					  회의자료 등록함
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
							 <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
							적용 년도 </td>
						     <td height="25" colspan="4" class="td_lmagin"><%=strGovSubmtYear%></td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							 <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
							구분 </td>
						     <td height="25" colspan="4" class="td_lmagin"><%=strSelCodeName%></td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							 <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
							담당기관</td>
						    <td height="25" colspan="3" class="td_lmagin"><%=strReqOrganNm%></td>
							</tr>
							<tr height="1" class="tbl-line"> 
							  <td height="1"></td>
							  <td height="1" colspan="3"></td>
							</tr>
							<tr> 
							  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								제출기관</td>
							  <td height="25"  class="td_lmagin">						
								<%=strSubmtOrganNm%>																			
							  </td>
							  <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								등록자</td>
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
								  첨부파일
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
								if(strPdfFilePath == "DB등록중" || strPdfFilePath.equals("DB등록중")){
									out.println("등록중");								
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
								if(strPdfFilePath == "DB등록중" || strPdfFilePath.equals("DB등록중")){
									out.println("등록중");								
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
									   <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 원본파일</td>
									   <td height="25" colspan="3" class="td_lmagin">
					<%
						String strExtension = FileUtil.getFileExtension(strOrgFilePath);						
						String strOrgFileName =  strFileNameInfo  + "." + strExtension;
						System.out.println(" strExtension = " + strExtension);
					%>
									   <a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>')">
					<% 												
						if(strExtension.equals("DOC") || strExtension.equals("doc")){
							System.out.println("doc 이다");
					%>	
										<img src="/image/common/icon_word.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("HWP") || strExtension.equals("hwp")){ 
						    System.out.println("hwp 이다");
					%>	
										<img src="/image/common/icon_hangul.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("GUL") || strExtension.equals("gul")){
							System.out.println("gul 이다");
					%>	
										<img src="/image/common/icon_hun.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("TXT") || strExtension.equals("txt")){
							System.out.println("txt 이다");
					%>	
										<img src="/image/common/icon_txt.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("HTML") || strExtension.equals("html") || strExtension.equals("HTM") || strExtension.equals("htm")){
							 System.out.println("html 이나 htm 이다");
					%>	
										<img src="/image/common/icon_html.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("XLS") || strExtension.equals("xls")){
						System.out.println("xls 이다");
					%>	
										<img src="/image/common/icon_excel.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("TOC") || strExtension.equals("toc")){
							System.out.println("toc 이다");
					%>	
										<img src="/image/common/icon_toc.gif" border="0"></a> &nbsp;
					<%
						}else if(strExtension.equals("ppt") || strExtension.equals("PPT")){
						System.out.println("ppt 이다");
					%>	
										<img src="/image/common/icon_ppt.gif" border="0"></a> &nbsp;
					<%
						}else{
						System.out.println("기타 이다");
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
									   <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 목차파일</td>
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
<%
							//if(strUserName.equals(strUserNm) || strOrganId.equals(strGovDlbrtHighOrganID)){
							if(strOrganId.equals(strGovDlbrtHighOrganID)){
%>													 
							<!--img src="/image/button/bt_modify.gif"  height="20" border="0" onClick="gotoUpdate(formName)" style="cursor:hand" alt="등록된 자료를 수정할 수 있습니다."-->&nbsp;
							<img src="/image/button/bt_delete.gif"  height="20" border="0" onClick="gotoDelete(formName)" style="cursor:hand" alt="등록된  자료를 삭제할 수 있습니다.">&nbsp;
<%
							}
%>
						 </td>
					   </tr>
					</table>   
					<!----------------------- 저장 취소등 Form관련 버튼 끝 ------------------------->               	   
					</td>
				  </tr>  
			
			<input type="hidden" name="strGovSubmtYear" value="<%=strGovSubmtYear%>"><!--제출 해당 년도-->	     
			<input type="hidden" name="strSubmtDataCont" value="<%=strSubmtDataCont%>"><!--제출내용 -->
			<input type="hidden" name="strGovSubmtDataId" value="<%=strGovSubmtDataId%>"><!--정부제출자료 ID -->     
			<input type="hidden" name="strOrganId" value="<%=strOrganId%>"><!--제출기관 id ( 제출자 일경우) -->
			<input type="hidden" name="strGbnKindCode" value="<%=strGbnKindCode%>"><!-- 정부제출자료 코드 -->
			<input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--검색어 -->
			<input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"> <!--검색필드 000 이면 전체 -->			   
			<input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--정렬 필드 --> 			   
			<input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">  <!--정렬 방향 --> 			   
			<input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- 페이지수 --> 
			<input type="hidden" name="strSubmtDate" value="<%=strSubmtDate%>">  <!-- 등록일자 --> 
			<input type="hidden" name="strPdfFilePath" value="<%=strPdfFilePath%>">  <!-- Pdf파일패스 --> 
			<input type="hidden" name="strOrgFilePath" value="<%=strOrgFilePath%>">  <!-- 원본파일패스 --> 
			<input type="hidden" name="strTocFilePath" value="<%=strTocFilePath%>">  <!-- Toc파일패스 --> 
			
			<input type="hidden" name="strReqOrganNm" value="<%=strReqOrganNm%>"><!--하위 담당기관명 -->	   
<input type="hidden" name="strGovDlbrtHighOrganID" value="<%=strGovDlbrtHighOrganID%>"><!--담당기관id (요구기관ID)-->	      

			  </table>
			  </td>
			</tr>
		</table>
		<!--------------------------------------- 여기까지  MAIN WORK AREA 실제 코딩의 끝입니다. ----------------------------->     </form>


		</td>
	  </tr>
	</table>

</body>
</html>
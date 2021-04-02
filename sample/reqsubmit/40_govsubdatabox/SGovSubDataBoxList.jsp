<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>


<%@ include file="../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

	boolean blnCheckPDFFileUploadComplet = true;
    StringUtil objDate = new StringUtil();
	ArrayList objAllBinderArray = null;
	Hashtable objGovSubmtDataHash = null;
	ResultSetHelper objRs = null;
	SGovSubmtDataDelegate objGovSubmtData = null;
	String strReqId = null;
	String strGovSubmtDataSortField = null;
	String strGovSubmtDataSortMtd = null;
	String strGovSubmtDataPageNum = null;
	//String strPageSize = null;
	String strUserID = null;
	String strGbnCode = null;    // 정부제출자료구분코드 000 전체 001 예산안 ..
	//String strOrganId = null;  // 기관 id
	String	strGovSubmtGNB = null;
	String strGovSubmtDataId = null;
	String strSubmtOrganId = null;
	String strOrgFilePath = null;
	String strPdfFilePath = null;
	String strTocFilePath = null;
	String strGovSubmtYear = null;

	String	strSubmtDate = null;
	String	strSubmtOrganNm = null;
	String	strSubmtDataCont = null;
	String  strHttpPdfFilePath = null;
	String	strReqOrganId = null;
	String  strReqOrganNmValue = null;
	String	strAnsSubmtQryField = null;
	String	strAnsSubmtQryTerm = null;
	String	strReqOrganNm  = null;
    String  strCheckLegiConn = null;
	String	strRegerNm = null ;  // 등록자
	String  strCDNm = null; // 구분 코드명

	String strOrgan_Kind = null; // 기관종류 ( 001 사무처 ,002 예산정책처 , 003 의원실 , 004 위원회)

	boolean blnGovSubmtDataNoExist =  true;
	boolean blnUserInfo = false;

	int intPageSize = 10 ; //  보여줄수있는 페이지 수
	int	intTotalRecordCount = 0;
	int	intCurrentPageNum = 0; // 현재 페이지
	int	intTotalPage = 0;
	int	intRecordNumber = 0;
	int intIndexNum = 1;
	int intStartPage = 0;
	int intEndPage = 0;

	String strQryFieldValue =StringUtil.getEmptyIfNull(StringUtil.toHan(request.getParameter("strAnsSubmtQryField")));
	String strQryTermValue = StringUtil.getEmptyIfNull(request.getParameter("strAnsSubmtQryTerm"));
    strGbnCode = StringUtil.getEmptyIfNull(request.getParameter("GovSubmtDataType")); // 정부제출자료 기관코드 000 전체 001 예산안 ..

	strReqOrganNmValue = StringUtil.getEmptyIfNull(StringUtil.toHan(request.getParameter("strReqOrganNm")));

	if(strGbnCode == null || strGbnCode == "" || strGbnCode.equals("")){
		strGbnCode = "000";
	}

	if(strQryFieldValue == null || strQryFieldValue == "" ||strQryFieldValue.equals("")){
		strAnsSubmtQryField = "001";
	}else{
	    strAnsSubmtQryField = strQryFieldValue;
	}

	if( strQryTermValue == null || strQryTermValue.equals("")){
		strAnsSubmtQryTerm = "";
	}else{
		strQryTermValue = StringUtil.toMulti(strQryTermValue);
		StringUtil.isAssigned(strQryTermValue);
		strAnsSubmtQryTerm = strQryTermValue;
	}
	//System.out.println("[SGovSubDataBoxList.jsp] 최종 strAnsSubmtQryTerm = " + strAnsSubmtQryTerm);


	strUserID = objUserInfo.getUserID();
	strSubmtOrganId = objUserInfo.getOrganID();
	//strOrgan_Kind = (String)session.getAttribute("ORGAN_KIND");  // 기관종류 ( 001 사무처 ,002 예산정책처 , 003 의원실 , 004 위원회 ,006 제출기관)
	strOrgan_Kind = objUserInfo.getOrganGBNCode();

	//정렬 정보 받기.
	strGovSubmtDataSortField = StringUtil.getEmptyIfNull(StringUtil.toHan(request.getParameter("strGovSubmtDataSortField")));
	if(strGovSubmtDataSortField == null || strGovSubmtDataSortField.equals("")){
		strGovSubmtDataSortField = "REG_DT";
	}

 	strGovSubmtDataSortMtd= StringUtil.getEmptyIfNull(request.getParameter("strGovSubmtDataSortMtd"));
 	if(strGovSubmtDataSortMtd == null || strGovSubmtDataSortMtd.equals("")){
	 	strGovSubmtDataSortMtd = "DESC";
 	}

	// 정보 페이지 번호 받기.
	strGovSubmtDataPageNum = StringUtil.getEmptyIfNull(request.getParameter("strGovSubmtDataPageNum"));
	//strGovSubmtDataPageNum = objParams.getParamValue("strGovSubmtDataPageNum");
	if(strGovSubmtDataPageNum == null || strGovSubmtDataPageNum.equals("")){
		strGovSubmtDataPageNum = "1";
	}

	//System.out.println("[SGovSubDataBoxList jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);
	Integer objIntD = new Integer(strGovSubmtDataPageNum);
	intCurrentPageNum = objIntD.intValue();
	//System.out.println("[SGovSubDataBoxList jsp] intCurrentPageNum = " + intCurrentPageNum);

    objGovSubmtData = new SGovSubmtDataDelegate();
	//intCurrentPageNum = 1

    intRecordNumber= (intCurrentPageNum -1) * intPageSize +1;
	intStartPage = intRecordNumber;
	intEndPage = intCurrentPageNum*10;

    //기관종류 ( 001 사무처 ,002 예산정책처 , 003 의원실 , 004 위원회 ,006 제출기관)

	if(strOrgan_Kind.equals("001")){ // 사무처(법제실)(GI00004754) 하드코딩처리
		if(strSubmtOrganId.equals("GI00004754")){
			if (objUserInfo.isRequester()) {
				objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,"GI00004754",strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
			} else {
				objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode, objUserInfo.getOrganID(),strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
			}
		} else {
			if (objUserInfo.isRequester()) {
				objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,objUserInfo.getOrganID(),strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
			} else {
				objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode, objUserInfo.getOrganID(),strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
			}
		}
	}else if(strOrgan_Kind.equals("002")){ // 예산정책처(GI00004746)하드코딩처리
			objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,"GI00004746",strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
	}else if(strOrgan_Kind.equals("003")   // 의원실
			|| strOrgan_Kind.equals("004")   // 위원회
		 	|| strOrgan_Kind.equals("006")){ // 제출기관
	        objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,strSubmtOrganId,strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
	}

    // 회의자료등록함 전부 보여준다.
	//objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,strSubmtOrganId,strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm);

	if(objGovSubmtDataHash != null ){
		blnGovSubmtDataNoExist = false;

		objRs =new ResultSetHelper(objGovSubmtDataHash);

		intCurrentPageNum = objRs.getPageNumber();//현재페이지번호
		//System.out.println("intCurrentPageNum = " + intCurrentPageNum);
	    intTotalRecordCount = objRs.getTotalRecordCount();//전체 조회된 레코드갯수
		//System.out.println("intTotalRecordCount = " + intTotalRecordCount);
	    intRecordNumber = objRs.getRecordSize(); //출력할 레코드개수
		//System.out.println("intRecordNumber = " + intRecordNumber);
	    intTotalPage = objRs.getTotalPageCount();//페이지개수
		//System.out.println("intTotalPage = " + intTotalPage);
 	}

   // strPageSize = Integer.toString(intRecordNumber);

%>
<%
	try{
		 blnUserInfo = objUserInfo.isRequester();
	 }catch(Exception e){
     }
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  function changeSortQuery(sortField,sortMethod){
  	GovSubmtList.strGovSubmtDataSortField.value=sortField;
  	GovSubmtList.strGovSubmtDataSortMtd.value=sortMethod;
  	GovSubmtList.submit();
  }


  function goPage(strPage){
  	GovSubmtList.strGovSubmtDataPageNum.value=strPage;
  	GovSubmtList.submit();
  }


  function gotoInsert(formName){

  		var varTarget = formName.target;
		var varAction = formName.action;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataInsert.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;

  }



  function gotoDetailView(formName,strGovSubmtDataId){
  		var varTarget = formName.target;
		var varAction = formName.action;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataDetailView.jsp";
		formName.strGovSubmtDataId.value = strGovSubmtDataId;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
  }



  function gotoGovSubDataBoxLegiConnect(formName,checkPdfUploadComplete){
		var blnCheck = false;
		var blnCheck2 = false;

		if(formName.LegiConn == undefined){
			alert("회의자료 등록함의 입법통합시스템에 연계할 자료가 없습니다.");
			blnCheck2 = true;
		}else{
			if(formName.LegiConn.length==undefined){
				if(formName.LegiConn.checked==true){
					blnCheck=true;
				}
			}else{
				var intLen=formName.LegiConn.length;
				for(var i=0;i<intLen;i++){
					if(formName.LegiConn[i].checked==true){
						blnCheck=true;
						break;
					}
				}
			}
		}

		if( !blnCheck2 ){
			if(blnCheck){
				var checkPdfUploadCompleteData = checkPdfUploadComplete;
				if(checkPdfUploadCompleteData == "true"){
				 	var varTarget = formName.target;
					var varAction = formName.action;
					formName.action="/reqsubmit/40_govsubdatabox/GovSubDataBoxLegiConnect.jsp";
					formName.submit();
					formName.target = varTarget;
					formName.action = varAction;
				}else{
					alert("입법통합시스템에 등록할 PDF문서가 아직 등록되지 않았습니다.");
				}

			}else {
				alert("입법통합시스템에 등록할 목록을 선택하세요");
			}
		}
  }



  function PdfFileOpen(strGovID,GPDF){

      var http = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strGovID + "&DOC=" + GPDF;
	  window.open(http,"PdfView",
		"resizable=yes,menubar=no,status=nos,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );

   }



    /** 전체 선택 전체 해제 */
  var blnCheckBoxFlag=false;

  function checkAllOrNot(formName){

   var i, chked=0, k=0;
   	  blnCheckBoxFlag=!blnCheckBoxFlag;
	  for(i=0;i<formName.length;i++){
	   if(formName[i].type=='checkbox'){
		//if(document.formName[i].checked){formName[i].checked=false;} else{formName[i].checked=true;}
		  formName[i].checked=blnCheckBoxFlag;
		  formName.checkAll.checked=blnCheckBoxFlag;
	   }
	}
	return true;
  }//end func



  function gotoHeadQuery(formName){
		var varTarget = formName.target;
		var varAction = formName.action;
	   // formName.strCheckSearchGbnCode.value = "001";
	    formName.strGovSubmtDataPageNum.value = 1; //처음 페이지로
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
 }


  function gotoSearch(formName){

		var varTarget = formName.target;
		var varAction = formName.action;
	   // formName.strCheckSearchGbnCode.value = "001";
	    formName.strGovSubmtDataPageNum.value = 1; //처음 페이지로
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;

  }

  	function OrgFileDownLoad(govSubmtDataId,strFileName,strYearData,formName){

		var varTarget = formName.target;
		var varAction = formName.action;
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GDOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.method = "post";
		formName.action = linkPath;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
	}
</script>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
<%
	if(blnUserInfo){
%>
        <h3>회의자료함 자료 목록</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />
<%
	out.println(MenuConstants.GOTO_HOME + " > " + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > "  + MenuConstants.GOV_SUBMT_REQ_DATA_BOX);
%>
<%
	}else{

	  String strTitle1 = "회의자료 등록함 자료 목록";
	  String strLocation2 =  MenuConstants.GOTO_HOME + " > " + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > " + MenuConstants.GOV_SUBMT_DATA_BOX;
%>

	<h3><%=strTitle1%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /><%=strLocation2%>
<%
	}
%>

	</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
<form name="GovSubmtList" method="post" action="<%=request.getRequestURI()%>">
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p>요구함조회조건</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
            <select name="GovSubmtDataType" onChange="this.form.submit()">
			<option
			<%
			if(strGbnCode == "000" || strGbnCode.equals("000")){
				out.print(" selected ");
				}
			%>
				value="000">전체</option>
			<%
  			Hashtable objGbnCodeList = objGovSubmtData.getGovSubmtDataGBNCodeList();
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

			  //if(strGbnCodeData.equals("001") || strGbnCodeData.equals("002") || strGbnCodeData.equals("003")){
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
			  //}
			} //FOR
		%>
			</select>
            <a href="javascript:gotoSearch(GovSubmtList);"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
				<input name="" type="checkbox" value="" class="borderNo" />
			 </th>
              <th scope="col" style="width:15px;"><%=SortingUtil.getSortLink("changeSortQuery","",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"NO")%></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","DATA_NM",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"제출내용")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"제출기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"구분")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"파일")%></th>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"등록자")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"등록일")%></th>
            </tr>
          </thead>
          <tbody>
	<%
		if(!blnGovSubmtDataNoExist){
			  int intRecordNumberCount = intTotalRecordCount - ((intCurrentPageNum -1) * intPageSize);
			 if(intRecordNumber > 0){
				while(objRs.next()){
					//strGovSubmtYear  = (String)objRs.getObject("SUBMT_DATA_ID"); 		// 정부제출자료함 ID
					strGovSubmtDataId  = (String)objRs.getObject("SUBMT_DATA_ID"); 		// 정부제출자료함 ID
					strSubmtOrganNm = (String)objRs.getObject("SUBMT_ORGAN_NM");		// 제출기관 명
					strReqOrganId = (String)objRs.getObject("REQ_ORGAN_ID"); 			// 담담기관 ID
					strCheckLegiConn = (String)objRs.getObject("ILKMS_REG_FLAG"); 	   // 입법통합등록 확인

				 // System.out.println("[SGovSubDataBoxList.jsp] strCheckLegiConn = " + strCheckLegiConn);
				 // if(strCheckLegiConn.compareTo("Y") == 0){
				 //		continue;
				 // }

				   // if(strGbnCode.compareTo("001") == 0){
					strReqOrganNm = (String)objRs.getObject("REQ_ORGAN_NM");        // 담당기관명
						// System.out.println("[SGovSubDataBoxList.jsp] strReqOrganNm = " + strReqOrganNm);
					//}

					strGovSubmtGNB	= (String)objRs.getObject("SUBMT_DATA_GBN");        // 구분코드
					strCDNm = (String)objRs.getObject("CD_NM");        					// 구분명
					strSubmtDataCont  = (String)objRs.getObject("DATA_NM"); 			// 제출내용
					strSubmtDate = (String)objRs.getObject("REG_DT");					// 제출기간
					String strYear =strSubmtDate.substring(0,4); // 년도

					strOrgFilePath = (String)objRs.getObject("APD_ORG_FILE_PATH"); 	// 원본문서패스
					strPdfFilePath = (String)objRs.getObject("APD_PDF_FILE_PATH"); 	// PDF문서패스
					strTocFilePath = (String)objRs.getObject("APD_TOC_FILE_PATH"); 	// TOC문서패스
					 strRegerNm = (String)objRs.getObject("USER_NM"); 	// TOC문서패스

					//ReqFileOpen.jsp?paramAnsId=6&DOC=PDF"
					 strSubmtDate = StringUtil.getDate(strSubmtDate);
					 //strHttpPdfFilePath = objGovSubmtData.getHttpFileInfo(strPdfFilePath);
					 //strHttpPdfFilePath = objDate.toMulti(strHttpPdfFilePath);

					 //System.out.println("[SGovSubDataBoxList.jsp] strHttpPdfFilePath =" + strHttpPdfFilePath);

		 %>
            <tr>
  			<%
				if( strCheckLegiConn == "Y" || strCheckLegiConn.equals("Y")){
					  strCheckLegiConn = "등록";
			%>
			  <td >
				<input name="ReqInfoIDs" type="checkbox" class="borderNo" Disabled/>
			  </td>
			<%
				}else{
					  strCheckLegiConn = "미등록";
			%>
			  <td>
				<input name="LegiConn" type="checkbox" value ="<%//=strGovSubmtDataId%>" class="borderNo" Disabled/>
			  </td>
			<%
				}
									//intIndexNum
			%>
              <td><%= intRecordNumberCount %></td>
              <td><a href="javascript:gotoDetailView(GovSubmtList,'<%=strGovSubmtDataId%>');"><%=strSubmtDataCont%></a></td>
              <td><%=strSubmtOrganNm%></td>
              <td><%=strCDNm%></td>
			  <!--<td><%//=strCheckLegiConn%></td>-->
              <td>
				<%
					if(strPdfFilePath == "DB등록중" || strPdfFilePath.equals("DB등록중")){
						out.println("등록중");
						blnCheckPDFFileUploadComplet = false;
					}else{
						if(strPdfFilePath == "" || strPdfFilePath.equals("")){
						}else{
				%>
				<a href="javascript:PdfFileOpen('<%=strGovSubmtDataId%>','GPDF');"><img src="/image/common/icon_pdf.gif" border="0"></a>
				<%
						}
					String strExtension = FileUtil.getFileExtension(strOrgFilePath);
					String strOrgFileName =  "src_"  + strGovSubmtDataId + "." + strExtension;

					   if(strOrgFilePath == "" || strOrgFilePath.equals("")){
					   }else{
							if(strExtension.equals("DOC") || strExtension.equals("doc")){
				%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_word.gif" border="0"></a>
					<%
						}else if(strExtension.equals("HWP") || strExtension.equals("hwp")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_hangul.gif" border="0"></a>
					<%
						}else if(strExtension.equals("GUL") || strExtension.equals("gul")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_hun.gif" border="0"></a>
					<%
						}else if(strExtension.equals("TXT") || strExtension.equals("txt")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_txt.gif" border="0"></a>
					<%
						}else if(strExtension.equals("HTML") || strExtension.equals("html") || strExtension.equals("HTM") || strExtension.equals("htm")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_html.gif" border="0"></a>
					<%
						}else if(strExtension.equals("XLS") || strExtension.equals("xls")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_excel.gif" border="0"></a>
					<%
						}else if(strExtension.equals("TOC") || strExtension.equals("toc")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_toc.gif" border="0"></a>
					<%
						}else if(strExtension.equals("ppt") || strExtension.equals("PPT")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_ppt.gif" border="0"></a>
					<%
						}
				   }
				}
			%>
			  </td>
              <td><%=strRegerNm%></td>
              <td><%=strSubmtDate%></td>
            </tr>
		<%
				 intRecordNumberCount --; // intIndexNum++;
				 }//end While
			} else { // end intRecordNumber
				//System.out.println("\n 출력할 레코드개수 0 보다 작다.");
		%>
			<tr>
				<td colspan="8" align="center">등록된 회의자료 정보 목록이 없습니다</td>
			</tr>
			<%
				}
			} else { //end blnGovSubmtDataNoExist = true
					//System.out.println("\n DB에서 받아온 HASHTABEL이 NULL 이다.");
			%>
			<tr >
				<td colspan="8" height="40" align="center">등록된 회의자료 정보 목록이 없습니다</td>
			</tr>
		<%
			} //blnBindFileSessionExist
		%>
          </tbody>
        </table>
		<%
		//System.out.println("blnGovSubmtDataNoExist = " +blnGovSubmtDataNoExist);
			if(intRecordNumber > 0){
		%>
        <!-- /list -->
		<%=objPaging.pagingTrans(PageCount.getLinkedString(
										new Integer(intTotalRecordCount).toString(),
										new Integer(intCurrentPageNum).toString(),
										new Integer(intPageSize).toString()))%>
		<%
		   }
		%>
        <!-- 페이징-->
         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			//String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="strAnsSubmtQryField" class="selectBox5"  style="width:70px;" >
<%
 if(strAnsSubmtQryField == "001" || strAnsSubmtQryField.equals("001")){
%>
			<option	 selected value="001">제출내용</option>
			<option	 value="002">제출기관</option>
			<!--<option	 value="003">담당기관</option>-->
			<option	 value="004">등록자</option>
<%
	}else if(strAnsSubmtQryField == "002" || strAnsSubmtQryField.equals("002")){
%>
			<option	  value="001">제출내용</option>
			<option	selected  value="002">제출기관</option>
			<!--<option	 value="003">담당기관</option>-->
			<option	 value="004">등록자</option>
<%
						//}else if(strAnsSubmtQryField == "003" || strAnsSubmtQryField.equals("003")){
%>
	<!--		<option	 value="001">제출내용</option>
				<option	 value="002">제출기관</option>
				<option	selected value="003">담당기관</option>
				<option	 value="004">등록자</option>
	 -->
<%
	}else if(strAnsSubmtQryField == "004" || strAnsSubmtQryField.equals("004")){
%>
			<option	 value="001">제출내용</option>
			<option	 value="002">제출기관</option>
			<!--<option	 value="003">담당기관</option>-->
			<option	selected value="004">등록자</option>
<%
						}
%>
          </select>
          <input name="strAnsSubmtQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"value="<%=strAnsSubmtQryTerm%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="gotoSearch(GovSubmtList);"/>
<%
   // }
%>
		  </div>
        <!-- /리스트 내 검색 -->
		<span class="right">
<%
	if ("003".equalsIgnoreCase(strOrgan_Kind)) {
	} else {
		if(strOrgan_Kind.equals("006")){ //제출기관
%>
			<span class="list_bt"><a href="javascript:gotoInsert(GovSubmtList)">등록</a></span>
<%
		}else{
%>
			<span class="list_bt"><a href="javascript:gotoInsert(GovSubmtList)">등록</a></span>
<%
		}
	}
%>
		</span>

		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
  </div>
   <input type="hidden" name="strOrganId" value="<%=strSubmtOrganId%>"> <!--제출기관 id  -->
   <input type="hidden" name="strSubmtOrganNm" value="<%=strSubmtOrganNm%>"> <!--제출기관명 -->
   <input type="hidden" name="strGbnCode" value="<%=strGbnCode%>"><!--정부제출자료구분코드 000전체 001예산안-->
   <input type="hidden" name="strGovSubmtDataId" value="">  <!--정부제출자료 id -->
   <input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--정렬 필드 -->
   <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">

   <!--정렬차순  오름차순,내림차순 -->
   <input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- 페이지수 -->
   <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"><!--검색필드 000 이면 전체-->
    <input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--검색어 -->
	<!--<input type="hidden" name="strCheckSearchGbnCode" value="">--> <!--search버튼 선택시 -->

</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
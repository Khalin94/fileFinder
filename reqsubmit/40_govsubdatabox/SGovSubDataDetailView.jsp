<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>

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

	SGovSubmtDataDelegate objGovSubmtData = null;
	UserInfoDelegate objUser = null;
	 FileUtil objFileUtil = new FileUtil();

	objUser = new UserInfoDelegate(request);

	String strGbnCode = null;
	String strOrganId = null;
	strGbnCode = objUser.getOrganGBNCode();   // 003:의원실 004:위원회 (보기), 006:제출기관 (등록)
	//System.out.println("기관 구분  strGbnCode = " + strGbnCode );
	strOrganId = objUser.getOrganID();
	//System.out.println("요구 기관  strOrganId = " + strOrganId );
	String strUserId = null;
	//String strUserID =	objUser.getUserID();
	String strUserName = objUser.getUserName();
	boolean blnUserInfo = false;


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
	//System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataId = " + strGovSubmtDataId);

	//검색어
	strAnsSubmtQryTerm =  (String)request.getParameter("strAnsSubmtQryTerm");
	//System.out.println("strAnsSubmtQryTerm ="  + strAnsSubmtQryTerm);
	if(strAnsSubmtQryTerm != null){
		strAnsSubmtQryTerm =  StringUtil.toMulti(request.getParameter("strAnsSubmtQryTerm"));
	}
	//System.out.println("[SGovSubDataDetailView.jsp] strAnsSubmtQryTerm = " + strAnsSubmtQryTerm);

	//검색필드
	strAnsSubmtQryField =  (String)request.getParameter("strAnsSubmtQryField");
	//System.out.println("[SGovSubDataDetailView.jsp] strAnsSubmtQryField = " + strAnsSubmtQryField);

	// 정렬 필드선택 (정보제출자료코드)
	strGovSubmtDataSortField =  (String)request.getParameter("strGovSubmtDataSortField");
	if(strGovSubmtDataSortField == null){
			strGovSubmtDataSortField = "REG_DT";
	}
	//System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataSortField = " + strGovSubmtDataSortField);

	// 정렬 순서
 	strGovSubmtDataSortMtd=  (String)request.getParameter("strGovSubmtDataSortMtd");
	if(strGovSubmtDataSortMtd == null){
			strGovSubmtDataSortMtd = "DESC";
	}
		//System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataSortMtd = " + strGovSubmtDataSortMtd);
	// 정보 페이지 번호 받기.
	strGovSubmtDataPageNum = (String)request.getParameter("strGovSubmtDataPageNum");
	if(strGovSubmtDataPageNum == null){
		strGovSubmtDataPageNum = "1";
	}
	//System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);


	Hashtable objhash = null;

	objGovSubmtData = new SGovSubmtDataDelegate();

	objhash = objGovSubmtData.getGovSubmtDetailView(strGovSubmtDataId);


	String strGbnKindCode = (String)( (Vector)objhash.get("SUBMT_DATA_GBN") ).elementAt(0);	 //구분
	//System.out.println("  ******* strGbnKindCode  =  " + strGbnKindCode + " ********** " );



	strSelCodeName = (String)( (Vector)objhash.get("CD_NM") ).elementAt(0);			//정부제출자료코드이름
  	strSubmtOrganNm = (String)( (Vector)objhash.get("ORGAN_NM") ).elementAt(0); 			 //제출기관명
	strReqOrganNm = (String)( (Vector)objhash.get("REQ_ORGAN_NM") ).elementAt(0); 	  //담당기관명(요구기관명)
    strUserNm = (String)( (Vector)objhash.get("USER_NM") ).elementAt(0);   				    // 등록자명
	strUserId = (String)( (Vector)objhash.get("REGR_ID") ).elementAt(0);                    // 등록ID
  	strSubmtDataCont = (String)( (Vector)objhash.get("DATA_NM") ).elementAt(0);  			//제출내용
    strSubmtDataCont  = StringUtil.getDescString(strSubmtDataCont);
  	strPdfFilePath  = (String)( (Vector)objhash.get("APD_PDF_FILE_PATH") ).elementAt(0);	//PDF문서패스
  	strPdfFilePath = FileUtil.getFileSeparatorPath(strPdfFilePath);
  	strPdfFilePath = FileUtil.getFileName(strPdfFilePath);
  	//System.out.println("[SGovSubDataDetailView.jsp] strPdfFilePath =" + strPdfFilePath);

  	strOrgFilePath =(String)( (Vector)objhash.get("APD_ORG_FILE_PATH") ).elementAt(0); 	//원본문서패스
  	strOrgFilePath = FileUtil.getFileSeparatorPath(strOrgFilePath);
  	strOrgFilePath = FileUtil.getFileName(strOrgFilePath);
  	//System.out.println("[SGovSubDataDetailView.jsp] strOrgFilePath =" + strOrgFilePath);

  	strTocFilePath =  (String)( (Vector)objhash.get("APD_TOC_FILE_PATH") ).elementAt(0); 	//TOC문서패스
  	strTocFilePath = FileUtil.getFileSeparatorPath(strTocFilePath);
  	strTocFilePath = FileUtil.getFileName(strTocFilePath);
  	//System.out.println("[SGovSubDataDetailView.jsp] strTocFilePath =" + strTocFilePath);

  	strSubmtDate =  (String)( (Vector)objhash.get("REG_DT") ).elementAt(0);  				//등록일자
	String strYear =strSubmtDate.substring(0,4); // 년도

  	strGovSubmtYear =  (String)( (Vector)objhash.get("SUBMT_YEAR")).elementAt(0);  		//제출 해당 년도
  	strGovDlbrtHighOrganID =  (String)( (Vector)objhash.get("DLBRT_ORGAN_ID")).elementAt(0);  	//담당기관 ID


	 String strFileNameInfo = strGovSubmtYear + "_" + strSelCodeName + "_" + strSubmtOrganNm;

	 //아이콘 리스트 : 한글,word,powerpointer,excel,훈민정음,txt문서 ,html문서, toc파일 , 기타문서
%>
<%
	try{
		 blnUserInfo = objUserInfo.isRequester();
	}catch(Exception e){
	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">

 	function gotoUpdate(formName){
  		var varTarget = formName.target;
		var varAction = formName.action;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataUpdate.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
    }

    function gotoList(formName){

  		var varTarget = formName.target;
		var varAction = formName.action;
		formName.strGovSubmtDataId.value = "<%=strGovSubmtDataId%>";
		formName.strGovSubmtDataSortField.value = "<%=strGovSubmtDataSortField%>";
		formName.strGovSubmtDataSortMtd.value = "<%=strGovSubmtDataSortMtd%>";
		formName.strGovSubmtDataPageNum.value = "<%=strGovSubmtDataPageNum%>";
		formName.strAnsSubmtQryField.value = "<%=strAnsSubmtQryField%>";
		formName.strAnsSubmtQryTerm.value =  "<%=strAnsSubmtQryTerm%>";

		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
    }

    function gotoDelete(formName){

    	if(confirm("회의자료등록함 목록에서 삭제하시겠습니까 ?")==true){
  			var varTarget = formName.target;
			var varAction = formName.action;
			formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataDelete.jsp";
			formName.submit();
			formName.target = varTarget;
			formName.action = varAction;
		}
    }

	function PDFfileDownLoad(govSubmtDataId,code){

			var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=" + code;

			window.open(linkPath,"DowloadOrginalDocFile",
			"resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=800,width=900" );

	}

	//function OrgFileDownLoad(orgFileName,orgNewFileName){
	function OrgFileDownLoad(govSubmtDataId,strFileName,strYearData){

		var varTarget = formName.target;
		var varAction = formName.action;
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GDOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.action=linkPath;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;

	}

	function TocFileDownLoad(govSubmtDataId,strFileName,strYearData){

		var varTarget = formName.target;
		var varAction = formName.action;
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GTOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.action=linkPath;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
	}



</script>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
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
	if(blnUserInfo){ // 요구자일 경우
%>
        <h3>회의자료함</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 자료 요구 > 회의자료함 > 회의자료 상세보기
<%
	}else{  //제출자일 경우
%>
        <h3>회의자료 등록함</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 자료 요구 > 회의자료 등록함 > 회의자료 상세보기
<%
	}
%>
	</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
<form name="formName" method="post" action="./SGovSubDataInsertProc.jsp"><!--요구 신규정보 전달 -->
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl"><%=MenuConstants.GOV_SUBMT_DATA_DETAIL_VIEW%> </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; 적용 년도 </th>
                <td height="25" colspan="3"><%=strGovSubmtYear%></td>
            </tr>
            <tr>
                <th height="25">&bull; 구분 </th>
                <td height="25" colspan="3"><%=strSelCodeName%></td>
            </tr>
            <tr>
                <th height="25">&bull; 담당기관 </th>
                <td height="25"><%=strSubmtOrganNm%></td>
                <th height="25">&bull; 등록자 </th>
                <td height="25"><%=strUserNm%></td>
            </tr>
            <tr>
                <th height="25">&bull; 제출내용 </th>
                <td height="25" colspan="3"><%=strSubmtDataCont%></td>
            </tr>
            <tr>
                <th height="25" rowspan="2">&bull; 첨부파일 </th>
				<%
					if(StringUtil.isAssigned(strPdfFilePath)) {
				%>
                <th height="25">PDF</th>
                <td height="25" colspan="2">
					<%
						if(strPdfFilePath == "DB등록중" || strPdfFilePath.equals("DB등록중")){
							out.println("등록중");
						} else {
					%>
					<a href="javascript:PDFfileDownLoad('<%=strGovSubmtDataId%>','GPDF');">
					<img src="/image/common/icon_pdf.gif" border="0">&nbsp;
					<%
							String strPdfFileName =  strFileNameInfo  + ".pdf";
							out.println(strPdfFileName);
						}
					%>
				</td>
            </tr>
            <tr>
		   <%
				}
		   %>
		   <%
				if (StringUtil.isAssigned(strOrgFilePath)) {
		   %>
                <th height="25">원본파일</th>
                <td height="25" colspan="2">
				<%
					String strExtension = FileUtil.getFileExtension(strOrgFilePath);
					String strOrgFileName =  strFileNameInfo  + "." + strExtension;
				%>
			   <a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>')">
				<%
					if(strExtension.equals("PDF") || strExtension.equals("pdf")){
				%>
				<img src="/image/common/icon_pdf.gif" border="0">&nbsp;
				<%
					}else if(strExtension.equals("DOC") || strExtension.equals("doc")){
				%>
				<img src="/image/common/icon_word.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("HWP") || strExtension.equals("hwp")){
				%>
				<img src="/image/common/icon_hangul.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("GUL") || strExtension.equals("gul")){
				%>
				<img src="/image/common/icon_hun.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("TXT") || strExtension.equals("txt")){
				%>
				<img src="/image/common/icon_txt.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("HTML") || strExtension.equals("html") || strExtension.equals("HTM") || strExtension.equals("htm")){
				%>
				<img src="/image/common/icon_html.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("XLS") || strExtension.equals("xls")){
				%>
				<img src="/image/common/icon_excel.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("TOC") || strExtension.equals("toc")){
				%>
				<img src="/image/common/icon_toc.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("ppt") || strExtension.equals("PPT")){
				%>
				<img src="/image/common/icon_ppt.gif" border="0"></a> &nbsp;
				<%
					}else{
				%>
				<img src="/image/common/icon_etc.gif" border="0"></a> &nbsp;
			<%
					}
					out.println(strOrgFileName);
			%>
				</a>
		<%
			}
		%>
				</td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>
-->
        <!-- 리스트 버튼-->
         <div id="btn_all"class="t_right">
		<!-- 제출 완료 -->
<%
	//if(strUserName.equals(strUserNm) || strOrganId.equals(strGovDlbrtHighOrganID)){
	if(strOrganId.equals(strGovDlbrtHighOrganID)){
%>
			 <span class="list_bt"><a href="javascript:gotoDelete(formName)">삭제</a></span>
<%
	}
%>
			<span class="list_bt"><a href="javascript:gotoList(formName)">목록</a></span>
		 </div>

        <!-- /리스트 버튼-->

    </div>
  </div>
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
			<input type="hidden" name="RegrID" value="<%=strUserId%>"><!-- 등록자 ID -->
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
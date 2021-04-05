<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>
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
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
	String strRltdDuty=null; 			 /**선택된 업무구분 */
	String strDaeSuCh = null;
	String strCmtGubun = objUserInfo.getOrganGBNCode();

	/**요구함 목록조회용 파라미터 설정.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();
	/**요구기관 설정 :: 소속 기관.*/
	objParams.setParamValue("ReqOrganID", objUserInfo.getOrganID());
	/**요구함 상태: 작성중 요구함.*/
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_003);
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/

	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	RequestBoxDelegate objReqBoxDelegate = null;

	// 2005-08-29 kogaeng ADD
	// 요구일정자동생성을 체크하기 위해서 추가되는 Delegate
	CmtSubmtReqBoxDelegate objBean2 = null;

	ResultSetHelper objRs=null;				/**요구함 목록 */
	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objYearRs=null;

	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;

	try{
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objBean2 = new CmtSubmtReqBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));
	    if(strDaesuInfo.equals("")){
			if(objDaeRs != null){
				if(objDaeRs.next()){
					strDaesu = (String)objDaeRs.getObject("DAE_NUM");
					strStartdate = (String)objDaeRs.getObject("START_DATE");
					strEnddate = (String)objDaeRs.getObject("END_DATE");
					objDaeRs.first();
				}
			}
	    }else{
			String[] strDaesuInfos = StringUtil.split("^",strDaesuInfo);
			strDaesu = strDaesuInfos[0];
			strStartdate = strDaesuInfos[1];
			strEnddate = strDaesuInfos[2];

	    }
	    Hashtable objhashdata = new Hashtable();

		System.out.println("TIMEMMMM1 : "+this.getCurrentTime());
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003,strStartdate,strEnddate,strSelectedAuditYear));
		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003,strStartdate,strEnddate));
		System.out.println("TIMEMMMM2 : "+this.getCurrentTime());

		objhashdata.put("START_DATE",strStartdate);
	    objhashdata.put("END_DATE",strEnddate);

		objRs=new ResultSetHelper(objReqBox.getRecordDaeList(objParams,objhashdata));
		System.out.println("TIMEMMMM3 : "+this.getCurrentTime());
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
		System.out.println("TIMEMMMM4 : "+this.getCurrentTime());
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					데이터 값 할당  Part 														  */
	/*************************************************************************************************/

	/**요구정보 목록조회된 결과 반환.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">

  var IsClick=false;

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
  	formName.target = '';
  	formName.submit();
  }

  //요구함상세보기로 가기.
  function gotoDetail(strID){
  	/*
  	formName.action="./RMakeReqBoxVList.jsp?ReqBoxID="+strID;
  	formName.target = "";
  	formName.submit();
	*/
	if(!IsClick){
		location.href="./RMakeReqBoxVList.jsp?ReqBoxID="+strID+"&AuditYear="+formName.AuditYear.value+"&CmtOrganID="+formName.CmtOrganID.value;
	}else{
		alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
		return;
	}
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
	formName.DAESUCH.value = "N";
  	formName.target = '';
  	formName.submit();
  }

  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	formName.ReqBoxQryField.value="";
  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
	formName.DAESUCH.value = "N";
  	formName.target = '';
  	formName.submit();
  }

	// 2005-07-13 요구서 일괄 발송
	function sendReqDoc() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("요구서 발송을 위해서는 우선 위원회를 선택해 주시기 바랍니다.");
				document.formName.CmtOrganID.focus();
				return;
			}

			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("발송하실 하나 이상의 요구함을 선택해 주세요.");
				return;
			}
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}

	  	if(confirm("선택하신 요구함을 해당 제출기관으로 일괄 발송하시겠습니까?\n\r\n\r***** 확인바랍니다 *****\n\r해당기관의 대표 담당자가 없는 경우는 발송되지 않습니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			//ButtonProcessing();  //처리상태를 표시하는 메소드 호출
			
			var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);

			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/ReqDocSendProcMultiTest.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}


	var strPopup;
	var strGubun = -1;

	function ButtonProcessing()
	{
		try{
			if(strGubun < 0){
				var oPopup = window.createPopup();
				var  oPopBody  =  oPopup.document.body;
				oPopBody.style.backgroundColor  =  "white";
				oPopBody.style.border  =  "solid  #dddddd 1px";



				// "처리중입니다"라는 메시지와 로딩이미지가 표시되도록 한다.
				oPopBody.innerHTML  = "<table width='100%' height='100%' border='1'><tr><td align='center' style='font-size:9pt;'><b>처리중입니다. 잠시만 기다려주세요...<b><br><img src='/image/reqsubmit/processing.gif'></td></tr></table>";



				var leftX = document.body.clientWidth/2 -130;
				var topY = (document.body.clientHeight/1.7) - (oPopBody.offsetHeight/2);

				oPopup.show(leftX,  topY,  270,  130,  document.body);



				// createPopup()를 이용해 팝업페이지를 만드는 경우
				// 기본적으로 해당 팝업에서 onblur이벤트가 발생하면 그 팝업페이지는 닫히게 됩니다.

				// 해당 팝업페이지에서 onblur이벤트가 발생할때마다  메소드를 재호출하여

				// 팝업페이지가 항상 표시되게 합니다.
				oPopBody.attachEvent("onblur", ButtonProcessing);
				strPopup = oPopup;
			}
			strGubun = -1;
		}
		catch(e) {}
	}

	function notProcessing(){
		if(strPopup.isOpen){
			strPopup.hide();
			strGubun = 1;
		}
	}


	// 2005-07-13 요구서 일괄 발송
	function sendReqDoc1() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("요구서 발송을 위해서는 우선 위원회를 선택해 주시기 바랍니다.");
				document.formName.CmtOrganID.focus();
				return;
			}

			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("발송하실 하나 이상의 요구함을 선택해 주세요.");
				return;
			}
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}

	  	if(confirm("선택하신 요구함을 해당 제출기관으로 일괄 발송하시겠습니까?\n\r\n\r***** 확인바랍니다 *****\n\r해당기관의 대표 담당자가 없는 경우는 발송되지 않습니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			ButtonProcessing();  //처리상태를 표시하는 메소드 호출
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/ReqDocSendProcMultiTest.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}else{
			 return ;
		}
	}

	function AllInOne2(){
		var w = 800;
		var h = 800;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		var url = "/reqsubmit/common/ReqInfoWriteAllInOne.jsp";	window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
	}

	// 2005-07-18 선택된 요구함 일괄 삭제
	function doDelete() {
		if(!IsClick){
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("삭제하실 하나 이상의 요구함을 선택해 주세요.");
				return;
			}
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}

	  	if(confirm("선택하신 요구함을 일괄 삭제하시겠습니까?\n\r포함된 모든 요구 내용도 일괄 삭제됩니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			//ButtonProcessing();  //처리상태를 표시하는 메소드 호출


			var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);

			//var winl = (screen.width - 300) / 2;
			//var winh = (screen.height - 240) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/ReqBoxDelProcMulti.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}

	// 2005-08-26 kogaeng ADD
	// 위원회 명의 요구서 일괄 발송
	function sendCmtReqDoc() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("요구서 발송을 위해서는 우선 위원회를 선택해 주시기 바랍니다.");
				document.formName.CmtOrganID.focus();
				return;
			}

			//if(document.formName.CmtOrganID.value == "GI00004773"){
			//	alert("임기만료로 인하여 요구서를 보내실 수 없습니다 \n 향후 위원회의 위원이 구성되면 요구서를 보내실 수 있습니다.");
			//	return;
			//}
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("위원회 명의로 발송할 요구함을 하나 이상 선택해 주세요.");
				return;
			}
			<% if(objBean2.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID) && objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID)) { %>

			<%}else{
				if("GI00007001".equals(strSelectedCmtOrganID)|| "GI00007002".equals(strSelectedCmtOrganID)){

				}else{
			%>
				alert("소속 상임위원회가 아닌 경우에는 발송하실 수 없습니다.");
				return;
			<%
				}
			}
			%>
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			//return false;
			return;
		}

		if(confirm("선택하신 요구함을 해당 위원회 명의로 발송하시겠습니까?\n\r\n\r[확인사항]\n\r1. 소속 상임위원회가 아닌 경우에는 발송하실 수 없습니다.\n\r2. 등록된 요구가 없는 경우 발송하실 수 없습니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			//ButtonProcessing();  //처리상태를 표시하는 메소드 호출
			
			var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);

			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/CmtReqDocSendAllInOneMulti2.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
		}
	}
	function changeDaesu(){
		formName.DAESUCH.value = "Y";
		formName.submit();
	}

	function doListRefresh() {
		var f = document.formName;
		f.target = "";
		f.submit();
	}
</script>
</head>
<%
	// 2005-08-09 kogaeng ADD
	// 요구함 작성 메뉴 때문에 불가피하게 추가
	String strAddScript = "";
	String strAutoPopup = StringUtil.getEmptyIfNull(request.getParameter("AutoPopup"));
	if("Y".equalsIgnoreCase(strAutoPopup)) strAddScript = "AllInOne2();";
%>
<body onload="<%= strAddScript %>">
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
<%
		System.out.println("TIMEMMMM4.4 : "+this.getCurrentTime());
%>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
<%
	System.out.println("TIMEMMMM4.5 : "+this.getCurrentTime());
%>
    </div>
    <div id="rightCon">
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">
		  <%//정렬 정보 받기.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
		  %>
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--요구함목록정령방법-->
			<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--페이지 번호 -->


			<!-- 2005-07-18 요구서 발송을 위한 기본 정보 -->
			<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_001 %>">
			<input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_DOC_FORM_001 %>">
			<input type="hidden" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>">
			<input type="hidden" name="ReqOrganID" value="<%= objUserInfo.getOrganID() %>">
			<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
			<input type="hidden" name="DAESUCH" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p>요구함조회조건</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
            <select onChange="changeDaesu()" name="DaeSu">
		<%
			if(objDaeRs != null){
				while(objDaeRs.next()){
					String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
		%>
				<option value="<%=objDaeRs.getObject("DAE_NUM")%>^<%=objDaeRs.getObject("START_DATE")%>^<%=objDaeRs.getObject("END_DATE")%>" <%if(str.equals(strDaesuInfo)){%>selected<%}%>><%=objDaeRs.getObject("DAE_NUM")%>대</option>
		<%
			}
			}
		%>
            </select>
            <select onChange="javascript:doListRefresh()" name="AuditYear">
             <option value="">전체</option>
			<%
				if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
					while(objYearRs.next()){
				%>
					<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%></option>
				<%
					}
				}
			%>
            </select>
            <select onChange="javascript:doListRefresh()" name="CmtOrganID">
              <option value="">:::: 전체위원회 :::</option>
			<%
				if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
					while(objCmtRs.next()){
				%>
					<option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%></option>
				<%
					}
				}
			%>
            </select>
            <select onChange="this.form.submit();" name="RltdDuty">
				<option value="">업무구분(전체)</option>
			<%
			   /**업무구분 리스트 출력 */
			   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
					String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
					out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
			   }
			%>
            </select>
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>

 <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;"><input name="checkAll" type="checkbox" value=""  class="borderNo" onClick="javascript:checkAllOrNot(document.formName)" /></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"요구함명")%></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REGR_NM",strReqBoxSortField,strReqBoxSortMtd,"등록자")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"제출기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"업무구분")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_STT",strReqBoxSortField,strReqBoxSortMtd,"진행상태")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"개수")%></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqBoxSortField,strReqBoxSortMtd,"등록일시")%></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqBoxPageSize")));
		  if(objRs.getRecordSize() > 0){
			String strReqBoxID = "";
			int intMakeGrdID = 0;
			while(objRs.next()){
				strReqBoxID = (String)objRs.getObject("REQ_BOX_ID");
				intMakeGrdID = Integer.parseInt(StringUtil.getEmptyIfNull((String)objRs.getObject("MAKE_GRD_ID"), "0"));
				String strBgColor = "";
				if((intMakeGrdID % 2) == 0) strBgColor = "#f4f4f4";
		 %>
            <tr>
              <td><input name="ReqBoxID" type="checkbox" value="<%=strReqBoxID%>"  class="borderNo"/></td>
			  <td width="300px"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
			  <td><%=(String)objRs.getObject("REGR_NM")%></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              <td><%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),true)%></td>
              <td><%=objRs.getObject("REQ_CNT")%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
				<%
						intRecordNumber --;
					}//endwhile
				} else {
				%>
			<tr>
				<td colspan="7" align="center">등록된 <%=MenuConstants.REQ_BOX_MAKE%>이 없습니다.</td>
			</tr>
				<%
					} // end if
				%>
          </tbody>
        </table>

        <!-- /list -->
					<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqBoxPageSize")))%>
        <!-- 페이징-->
         <!-- /페이징-->
         <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
            <option <%=(strReqBoxQryField.equalsIgnoreCase("regr_nm"))? " selected ": ""%>value="regr_nm">등록자</option>
            <option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit()"/> </div>
        <!-- /리스트 내 검색 -->
		<span class="right"><span class="list_bt"><a href="javascript:AllInOne2()">요구함 작성</a></span></span>
		<span class="right"><span class="list_bt"><a href="javascript:doDelete()">요구함 삭제</a></span></span>
		<%
			if(!objUserInfo.getIsMyCmtOrganID("GI00004757")) {
		%>
		<%if(strCmtGubun.equals("004")){%>
		<span class="right"><span class="list_bt"><a href="javascript:sendReqDoc()">요구서 발송</a></span></span>
		<%}else{%>
		<span class="right"><span class="list_bt"><a href="javascript:sendCmtReqDoc()">위원회 명의 요구서 발송</a></span></span>
		<span class="right"><span class="list_bt"><a href="javascript:sendReqDoc()">의원실 명의 요구서 발송</a></span></span>
		
		<%}%>
	<%
		} else {
	%>
		<span class="right"><span class="list_bt"><a href="javascript:sendCmtReqDoc()">위원회 명의 요구서 발송</a></span></span>
		<%if(strCmtGubun.equals("004")){%>
		<span class="right"><span class="list_bt"><a href="javascript:sendReqDoc()">요구서 발송</a></span></span>
		<%}else{%>
		<span class="right"><span class="list_bt"><a href="javascript:sendReqDoc()">의원실 명의 요구서 발송</a></span></span>
		<%}%>
		
	<%
		}
	%>
		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->
</form>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
<%
	System.out.println("TIMEMMMM5 : "+this.getCurrentTime());
%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>
</div>
</body>
</html>
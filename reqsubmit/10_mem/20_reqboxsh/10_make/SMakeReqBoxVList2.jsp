<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	// 2004-05-11 추가된 파라미터
	// 답변 등록이 모두 완료되면 자동으로 답변서 발송 창을 띄운다.
	String strStartAnsDocSend = StringUtil.getEmptyIfNull(request.getParameter("startAnsDocSend"));

	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate reqDelegate = null;
	SMemReqInfoDelegate reqInfoDelegate = null;

	SMemReqBoxVListForm objParams = new SMemReqBoxVListForm();
	//SReqInfoListForm objParams = new SReqInfoListForm();
	// 요구자 제출자 여부를 Form에 추가한다
  	objParams.setParamValue("IsRequester", String.valueOf(objUserInfo.isRequester()));

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

	// 넘어온 파라미터를 설정해서 필요할 ?? 쓰도록 하자
	// 요구함 관련
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
	String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
	String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
	String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");

	// 요구 목록 관련
	String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
	String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
	String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
	String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");

	// 요구 개수 및 페이징 관련
	int intTotalRecordCount = 0;
	int intCurrentPageNum = 0;
	int intTotalPage = 0;

	// 현재 요구함의 요구에 등록된 답변 개수
	int intTotalAnsCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
		selfDelegate = new SMemReqBoxDelegate();
	   	reqDelegate = new MemRequestBoxDelegate();
	   	reqInfoDelegate = new SMemReqInfoDelegate();

	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  		out.println("해당 요구함을 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구함 등록 정보를 SELECT 한다.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID, objUserInfo.getUserID()));

	    	// 요구 목록을 SELECT 한다.
	    	objRs = new ResultSetHelper(reqInfoDelegate.getRecordList(objParams));

	    	// 현재 요구함의 등록된 요구별 답변 개수는??
	    	intTotalAnsCount = selfDelegate.checkReqInfoAnsIsNull(strReqBoxID);

	    	 /**요구정보 목록조회된 결과 반환.*/
			intTotalRecordCount = objRs.getTotalRecordCount();
 			intCurrentPageNum = objRs.getPageNumber();
 			intTotalPage = objRs.getTotalPageCount();
			System.out.println("SIZE : "+objRs.getRecordSize());
		}
	} catch(AppException e) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(e.getStrErrCode());
  		objMsgBean.setStrMsg(e.getMessage());
  		out.println("<br>Error!!!" + e.getMessage());
	  	return;
 	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
	var f;

	// 요구서 보기
	function goReqDocView() {
		NewWindow('/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID%>&ReqTp=001', '', '800', '600');
		//window.open("/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID%>&ReqTp=001", "",	"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
	}

	// 답변서 발송
	function sendAnsDoc() {
		var f = document.viewForm;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
		//window.open('/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID%>', '', 'width=450,height=300, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
	}

	// 요구 목록 조회
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "SMakeReqBoxList.jsp";
		f.target = "";
		f.submit();
	}

	// 정렬방법 바꾸기
	function changeSortQuery(sortField, sortMethod){
		f = document.viewForm;
  		f.ReqInfoSortField.value = sortField;
  		f.ReqInfoSortMtd.value = sortMethod;
  		f.target = "";
  		f.submit();
  	}

  	// 요구 상세보기로 가기 */
  	function gotoDetail(strID){
  		f = document.viewForm;
  		f.ReqID.value = strID;
  		f.action="SMakeReqInfoVList.jsp";
  		f.target = "";
  		f.submit();
  	}

  	// 페이징 바로가기
  	function goPage(strPage){
  		f = document.viewForm;
  		f.ReqInfoPage.value = strPage;
  		f.target = "";
  		f.submit();
  	}

  	// 답변서 발송을 할 때 등록된 답변이 하나라도 없으면 발송을 못한다는 메세지를 보여준다.
  	function alertSendAnsDocMessage() {
  		alert("답변이 등록되지 않은 요구가 있습니다.\n확인 후 다시 시도해 주시기 바랍니다.");
  	}

  	/**
  	 * 2005-10-20 kogaeng ADD
  	 * 체크박스를 하나만 선택하게 하는 스크립트
  	 */
  	function checkBoxValidate(cb, strID) {
		if(<%= objRs.getRecordSize() %> == 1) {
			if(cb == 0) {
				document.viewForm.ReqInfoID.checked = true;
				document.viewForm.ReqID.value = strID;
				return;
			}
		}
		for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
			if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
				document.viewForm.ReqInfoID[j].checked = false;
				if (j == cb) {
					document.viewForm.ReqInfoID[j].checked = true;
					document.viewForm.ReqID.value = strID;
				} else {
					document.viewForm.ReqInfoID[j].checked = false;
					document.viewForm.ReqID.value = "";
				}
			}
		}
	}

  	// 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
  		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
		} else {
			for (j = 0; j < <%= intTotalRecordCount %>; j++) {
				if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
					document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
					cnt++;
				}
			}
		}
  		if(cnt == 0) {
  			alert("요구를 선택하신 후에 버튼을 다시 클릭해 주세요");
  			return;
  		}
  		f = document.viewForm;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=no,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
  	// 구버전-답변 작성 화면으로 이동
  	function goSbmtReqForm_old() {
  		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
		} else {
			for (j = 0; j < <%= intTotalRecordCount %>; j++) {
				if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
					document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
					cnt++;
				}
			}
		}
  		if(cnt == 0) {
  			alert("요구를 선택하신 후에 버튼을 다시 클릭해 주세요");
  			return;
  		}
  		f = document.viewForm;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
	/** 요구 이력보기 */
	function viewReqHistory() {
		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
		} else {
			for (j = 0; j < <%= intTotalRecordCount %>; j++) {
				if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
					document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
					cnt++;
				}
			}
		}

  		if(cnt == 0) {
  			alert("요구를 선택하신 후에 버튼을 다시 클릭해 주세요");
  			return;
  		}
  		f = document.viewForm;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID="+document.viewForm.ReqID.value;
		var winl = (screen.width - 540) / 2;
		var winh = (screen.height - 450) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=450,width=540, left="+winl+", top="+winh);
		f.submit();
		/*
  		var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.viewForm.ReqID.value,
  																'', 'dialogWidth:540px;dialogHeight:450px; center:yes; help:no; status:no; scroll:yes; resizable:yes');
  		*/
	}

	// 답변 작성 화면으로 이동
  	function offlineSubmit() {
  		f = document.viewForm;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/OffLineDocSend.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}


</script>


</head>

<body <% if("Y".equalsIgnoreCase(strStartAnsDocSend)) { %> onLoad="javascript:sendAnsDoc()" <% } %>>
<div id="balloonHint" style="display:none;height:100px">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,돋움;font-weight:bold">요구<BR>상세<BR>내용</font></td>
		<td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
			<font style="font-size:11px;font-family:verdana,돋움">{{hint}}</font>
		</td>
	</tr>
</table>
</div>
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	  <SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%= MenuConstants.REQ_BOX_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->
		<%
			String strAnsDocURL = null;
			String strAnsDocPreviewScriptURL = null;
			if (intTotalAnsCount == 0) {
				strAnsDocURL = "javascript:sendAnsDoc()";
				strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(viewForm,'"+strReqBoxID+"')";
			} else {
				strAnsDocURL = "javascript:alertSendAnsDocMessage()";
				strAnsDocPreviewScriptURL = "javascript:alertSendAnsDocMessage()";
			}
			//strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(viewForm,'"+strReqBoxID+"')";
		%>
        <span class="list02_tl">요구함 등록 정보 </span>
         <div class="top_btn"><samp>
			 <span class="btn"><a href="javascript:goReqBoxList()">요구함 목록</a></span>
			 <span class="btn"><a href="javascript:submtBindingJob(viewForm, '<%= strReqBoxID %>');">바인딩</a></span>
		 </samp></div>
<form name="viewForm" method="post" action="" style="margin:0px">
	<!-- 요구함 등록 정보 관련 -->
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>"><!--요구함목록정렬필드 -->
	<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>"><!--요구함목록정렬방법-->
	<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>"><!--요구함 페이지 번호 -->
	<% if(StringUtil.isAssigned(strReqBoxQryTerm)) { %>
	<input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>"><!--요구함 조회필드 -->
	<input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>"><!--요구함 조회필드 -->
	<% } //요구함 조회어가 있는 경우만 출력해서 사용함 %>

	<!-- 요구 목록 관련 -->
	<input type="hidden" name="ReqID" value=""> <!-- 요구 ID -->
	<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--요구정보 목록정렬필드 -->
	<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--요구정보 목록정렬방법-->
	<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- 요구정보 페이지 번호 -->
	<input type="hidden" name="strReturnURLFLAG" value="NONECMT">

	<% if("Y".equalsIgnoreCase(strStartAnsDocSend)) { %>
		<input type="hidden" name="ReturnURL" value="/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp">
	<%}else{%>
		<input type="hidden" name="ReturnURL" value="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp">
	<%}%>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col">&bull;&nbsp;요구함명 </th>
				  <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %>
				  <%
										// 2004-06-15 ADD
										String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
										if (StringUtil.isAssigned(strElcDocNo)) {
											out.println(" (전자결재번호 : "+strElcDocNo+")");
										}
									%>
				</td>

            </tr>

            <tr>
              <th scope="col">&bull;&nbsp;소관 위원회 </th>
			  <td><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;업무구분  </th>
			  <td><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;발송정보 </th>
			  <td colspan="3">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
					 <tr>
						 <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
						 <td><%=(String)objRsSH.getObject("REQ_ORGAN_NM")%></td>
						 <td rowspan="2"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
						 <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
						 <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
					 </tr>
					 <tr>
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("REGR_EMAIL")%>"><%=(String)objRsSH.getObject("REGR_EMAIL")%></a> / <%=(String)objRsSH.getObject("REGR_CPHONE")%>)</td>
						 <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%></td>
					 </tr>
				 </table>
			</td>

            </tr>
            <tr>
              <th scope="col" rowspan="2">&bull;&nbsp;요구함이력 </th>  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;요구함생성일시 :</span>
              <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;요구서 수신일 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              </ul>
              </td>
            </tr>
            <tr>
			  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;제출기관 조회일 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;제출기한 :</span><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>
              </ul>
              </td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구함설명 </th>   <td colspan="3"><%= objRsSH.getObject("REQ_BOX_DSC") %></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">* 모든 요구목록에 대해서 즉시제출 또는 답변작성을 마친 후 답변서발송버튼을 눌러주시기 바랍니다.</p>
		<!-- 답변서 발송 -->
        <!-- 리스트 버튼-->
<!--
요구함 목록, 바인딩, 요구서 보기, 답변서 미리 보기, 답변서 발송, 오프라인 제출
-->
         <div id="btn_all">
			 <div >
				 <div class="mi_btn" style="float:right"><a href="javascript:goReqDocView()"><span>요구서 보기</span></a></div> 
				 <div class="mi_btn" style="float:right"><a href="<%= strAnsDocPreviewScriptURL %>"><span>답변서 미리 보기</span></a></div>
				 <div class="mi_btn" style="float:right"><a href="<%= strAnsDocURL %>"><span>답변서 발송</span></a></div>
				 <div class="mi_btn" style="float:right"><a href="javascript:offlineSubmit()"><span>오프라인 제출</span></a></div>
			 </div>
		 </div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
        <table>
			<tr><td>&nbsp;</td></tr>
		</table>



        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col" style="width:15px;"></th>
              <th scope="col" style="width:15px;"><a>NO</a></th>
              <th scope="col" style="width:250px;" style="text-align:center;">
				<%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "요구제목") %>
			  </th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "상태") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "공개등급") %></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><a>첨부</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqInfoSortField, strReqInfoSortMtd, "등록일자")%></th>
            </tr>
          </thead>
          <tbody>
<%
	int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
	String strReqInfoID = "";
	while(objRs.next()){
		strReqInfoID = (String)objRs.getObject("REQ_ID");
%>
            <tr>
              <td><input name="ReqInfoID" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-1) %>, '<%= strReqInfoID %>')" /></td>
              <td><%= intRecordNumber %></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%= objRs.getObject("REQ_ID") %>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%= objRs.getObject("REQ_CONT") %></a></td>
              <td><%= CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
              <td><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
			  <td width="50" align="center"><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"), (String)objRs.getObject("ANS_OPIN"), (String)objRs.getObject("SUBMT_FLAG"), objUserInfo.isRequester()) %></td>
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
            </tr>
<%
		intRecordNumber++;
	} //endwhile
%>
          </tbody>
        </table>
        <p class="warning mt10">* 답변을 작성할 요구의 체크박스를 선택해 주신 후 아래의 답변 작성 버튼을 클릭해 주시기 바랍니다.</p><br>
		<!--<p class="warning mt10">* PDF변환실패 시 "수동답변작성" 기능을 이용해 주시기 바랍니다. </p>-->
        <!-- /list -->

        <!-- 페이징-->
					<!--	<%= PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								objParams.getParamValue("ReqInfoPageSize"))
						%>
						-->
						<%=objPaging.pagingTrans(PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								objParams.getParamValue("ReqInfoPageSize")))%>

       <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%> value="req_cont">요구제목</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%> value="req_dtl_cont">요구내용</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()" value="<%= strReqInfoQryTerm %>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="viewForm.submit()"/> </div>
        <!-- /리스트 내 검색 -->
			<span class="right">
            <!-- 손성제 2012.2.13-->
            <!-- 변경된 업로드 컴포넌트 에러시 goSbmtReqForm-> goSbmtReqForm_old 변경-->
			<span class="list_bt"><a href="javascript:goSbmtReqForm_old()">답변작성</a></span>
			<span class="list_bt"><a href="javascript:viewReqHistory()">요구이력보기</a></span>
            <span class="list_bt"><a href="javascript:goSbmtReqForm()">대용량파일등록</a></span>
<!--
			<span class="list_bt"><a href="#">요구삭제</a></span>
			<span class="list_bt"><a href="#">요구복사</a></span>
-->
			</span>
		</div>

        <!-- /리스트 버튼-->
        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
<%!
	public String makeAttachedFileLink(String strFileName){
		String strReturnURL = null;
		System.out.println("XXXXXXX : "+strFileName);
		if(!StringUtil.isAssigned(strFileName)){
			//파일경로가 없으면 기본 파일경로로 대치함.
			strReturnURL = "";
			//strFileName=nads.lib.reqsubmit.EnvConstants.getConstFilePath();
		} else {
			strReturnURL = "<a href=\"/reqsubmit/common/AttachStyleFileDownload.jsp?path=" + strFileName+ "\"><img src=\"/image/common/icon_etc.gif\" border=\"0\"></a>";
		}
		return strReturnURL;
	}

%>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
<OBJECT ID="ezPDFConv" height="1" width="1" CLASSID="CLSID:ABBFCE48-008E-4DA1-8F5F-DF9E9749DC9D" codebase='cab/ezPDFConvtt.cab#Version=1,0,0,10'></OBJECT>
</body>
</html>
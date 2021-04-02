<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
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

	/**일반 요구함 상세보기 파라미터 설정.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} //endif

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	String strAuditYear = (String)objParams.getParamValue("AuditYear") == null ? "2008" : (String)objParams.getParamValue("AuditYear");
	String strCmtGubun = objUserInfo.getOrganGBNCode();
	strAuditYear = StringUtil.getEmptyIfNull(strAuditYear);
	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
	ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
	ResultSetHelper objRs=null;				/**요구 목록 */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	try{
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**요구함 이용 권한 체크 */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
		    objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  	objMsgBean.setStrCode("DSAUTH-0001");
		  	objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
		  	//out.println("해당 요구함을 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			/** 요구함 정보 */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));

			/**요구 정보 대리자 New */
			objReqInfo=new MemRequestInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));

			if(strAuditYear.equals("")){
				strAuditYear = ((String)objRsSH.getObject("REG_DT")).substring(0,4);
			}
		}/**권한 endif*/
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
<script language="javascript">
  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.target = '';
  	formName.submit();
  }
  /**요구 상세보기로 가기.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RMakeReqInfoVList.jsp";
  	formName.target = '';
  	formName.submit();
  }

  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RMakeReqBoxList.jsp";
  	formName.target = '';
  	formName.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.target = '';
  	formName.submit();
  }

  /** 요구등록페이지로 가기. */
  function gotoRegReqInfo(){
  	formName.action="./RMakeReqInfoWrite.jsp";
  	formName.target = '';
  	formName.submit();
  }

	var IsClick=false;
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


	function sendReqDocByCmtTitle() {

		if(!IsClick){

		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}
		if(confirm("해당 요구 내용을 위원회로 신청하신 후 위원회 명의로 발송하시겠습니까?")) {
			IsClick = true;  //버튼 처리를 수행중..
//			ButtonProcessing();  //처리상태를 표시하는 메소드 호출

			var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);

			formName.method = "POST";
			formName.target = "processingFrame";
			formName.action = "/reqsubmit/common/CmtReqDocSendAllInOne.jsp";
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			//window.open('about:blank', 'popwin', 'width=100px, height=100px, left=1500px, top=1500px');
			formName.submit();
		}
	}

	function sendReqDocNew(strReqDocType, strReqBoxID) {
		if(!IsClick){
			NewWindowFixSize('/reqsubmit/common/ReqDocSend.jsp?ReqBoxID='+strReqBoxID+'&ReqDocType='+strReqDocType, '', '460', '340');
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}
  	//var popModal = window.showModalDialog('RMakeReqDocSend.jsp?ReqDocType="+strReqDocType+"&ReqBoxID=' + strReqBoxID,
  	//															'', 'dialogWidth:450px;dialogHeight:500px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  	//window.open('/reqsubmit/common/ReqDocSend.jsp?ReqBoxID='+strReqBoxID+'&ReqDocType='+strReqDocType, '', 'width=450,height=320, scrollbars=no, resizable=no, toolbar=no, menubar=no, location=no, directories=no, status=no');

  }

	function copyReqBox(ReqBoxID) {
		NewWindow('/reqsubmit/common/MemReqBoxCopyList.jsp?ReqBoxID='+ReqBoxID,'', '640', '450');
	}

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>

<body>
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="balloonHint" style="display:none;height:100px;background:#fff">
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
    </div>
    <div id="rightCon">
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
			<%//요구함 정렬 정보 받기.
				String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
				String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
				//요구함 페이지 번호 받기.
				String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
				//요구함 조회정보 받기.
				String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
				String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
				//요구 정보 정렬 정보 받기.
				String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
				String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
				//요구함 정보 페이지 번호 받기.
				String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
				//요구조회히든태그없애기위해.
				objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
				objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    %>
		    <!-- %= objParams.getHiddenFormTags()% -->

			<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>">
			<input type="hidden" name="ReqBoxPageSize" value="<%= (String)objParams.getParamValue("ReqBoxPageSize") %>">
			<input type="hidden" name="ReqBoxQryField" value="<%= (String)objParams.getParamValue("ReqBoxQryField") %>">
			<input type="hidden" name="ReqBoxQryTerm" value="<%= (String)objParams.getParamValue("ReqBoxQryTerm") %>">
			<input type="hidden" name="ReqBoxSortField" value="<%= (String)objParams.getParamValue("ReqBoxSortField") %>">
			<input type="hidden" name="ReqBoxSortMtd" value="<%= (String)objParams.getParamValue("ReqBoxSortMtd") %>">
			<input type="hidden" name="ReqInfoPage" value="<%= (String)objParams.getParamValue("ReqInfoPage") %>">
			<input type="hidden" name="ReqInfoPageSize" value="<%= (String)objParams.getParamValue("ReqInfoPageSize") %>">
			<input type="hidden" name="ReqInfoSortField" value="<%= (String)objParams.getParamValue("ReqInfoSortField") %>">
			<input type="hidden" name="ReqInfoSortMtd" value="<%= (String)objParams.getParamValue("ReqInfoSortMtd") %>">
			<input type="hidden" name="AuditYear" value="<%= strAuditYear %>">
			<input type="hidden" name="RltdDuty" value="<%= (String)objParams.getParamValue("RltdDuty") %>">

			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
			<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_001 %>"><!-- ReqDocType -->
			<input type="hidden" name="CmtOrganID" value="<%= objRsSH.getObject("CMT_ORGAN_ID") %>">
			<input type="hidden" name="ReqBoxID" value="<%= (String)objParams.getParamValue("ReqBoxID") %>">
			<input type="hidden" name="ReqInfoID" value="">
			<input type="hidden" name="ReqBoxIDs">
			<input type="hidden" name="SubmtDln" value="<%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %>">
			<input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">
			<input type="hidden" name="ReqOrganNm" value="<%=objRsSH.getObject("REQ_ORGAN_NM")%>">
			<input type="hidden" name="RegrNm" value="<%=objRsSH.getObject("REGR_NM")%>">
			<input type="hidden" name="ReqOrganId" value="<%=objRsSH.getObject("REQ_ORGAN_ID")%>">

			<%
				int int1st = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).indexOf("제");
				int int2nd = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).indexOf("회");
				String strNatCnt = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).substring(int1st+1, int2nd);
			%>
			<input type="hidden" name="NatCnt" value="<%= strNatCnt %>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /><%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구함 정보</span>
		<%
		  //요구함 진행 상태.
		  String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");
		%>
		 <!-- 상단 버튼 시작-->
		 <div class="top_btn">
		  <samp>
		<%
			//결재대기중(상신),기안대기중  상태에서는 요구함 수정,삭제,요구함 발송 버튼이 Disable되어있어야함.
			//즉 작성중과 반려상태에석만 가능함.
			//
			if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){

				/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
				if(objUserInfo.getUserID().equals((String)objRsSH.getObject("REGR_ID"))){
		%>
        <!-- 리스트 버튼-->
			 <span class="btn"><a href="javascript:gotoMemEditPage()">요구함 수정</a></span>
			 <span class="btn"><a href="javascript:gotoMemDeletePage(<%=objRs.getTotalRecordCount()%>)">요구함 삭제</a></span>
		<%
				} // 등록자와  로그인자가 같을때만 화면에 출력함.
		%>
			 <span class="btn"><a href="javascript:copyReqBox('<%=objRsSH.getObject("REQ_BOX_ID")%>')">요구함 복사</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구함 목록</a></span>
		<%
			} // endif
		%>
		  </samp>
		 </div>
        <!-- 상단 버튼 끝-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>
              <th scope="col">&bull;&nbsp;요구함명 </th>
				  <td colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
			<%
				// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
				if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
				} else {
			%>
            <tr>
              <th scope="col">&bull;&nbsp;소관 위원회 </th>
			  <td><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
            </tr>
			<% } %>
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
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%></td>
						 <td class="fonts">(발송되지 않았으므로, 답변 대상자 정보가 없습니다.)</td>
					 </tr>
				 </table>
			</td>

            </tr>
                <tr>

              <th scope="col">&bull;&nbsp;요구함 이력 </th>  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;요구함생성일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;제출기한 :</span> <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>
              </ul>
              </td>

            </tr>
                <tr>
              <th scope="col">&bull;&nbsp;요구함설명 </th>   <td colspan="3"><%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>
		<%
			if(objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) && objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) {
			//if(objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")) && ("GI00004757".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID")) || "GI00004773".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID"))) && objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) == true) {
		%>
        <p class="warning mt10">위원회 명의 요구서 발송 : 위원회로 작성한 요구 내용을 자동 신청 합니다. 위원회 접수완료 요구함 에서 해당 내용을 확인하세요.</p>
		<% } %>

	<!-- 중단버튼 시작 -->
         <div id="btn_all">
			<div  class="t_right">
		<%
			//결재대기중(상신),기안대기중  상태에서는 요구함 수정,삭제,요구함 발송 버튼이 Disable되어있어야함.
			//즉 작성중과 반려상태에석만 가능함.
			//
			if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
		%>

		<%
				if(intTotalRecordCount>0){
		%>
			<% if(objUserInfo.getIsMyCmtOrganID("GI00004757") && "GI00004757".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID"))) { %>
			<% } else { %>
				<%if(strCmtGubun.equals("004")){%>
		     <div class="mi_btn"><a href="javascript:sendReqDocNew('<%= CodeConstants.REQ_DOC_TYPE_001 %>', '<%= (String)objParams.getParamValue("ReqBoxID") %>')"><span>요구함 발송</span></a></div>
				 <%}else{%>
			 <div class="mi_btn"><a href="javascript:sendReqDocNew('<%= CodeConstants.REQ_DOC_TYPE_001 %>', '<%= (String)objParams.getParamValue("ReqBoxID") %>')"><span>의원실 명의 요구서 발송</span></a></div>
			<%}%>
		<% } %>
		<%
					if(objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) && objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <div class="mi_btn"><a href="javascript:sendReqDocByCmtTitle()"><span>위원회 명의 요구서 발송</span></a></div>
		<%
			}
		%>
		<%
				}//딸린식구가있어야 보임.

			} // endif

			/*조회결과 있을때 출력 시작.*/
			if(objRs.getRecordSize()>0){
		%>
		<%
			String strReqTp = "";
			if (CodeConstants.ORGAN_GBN_CMT.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) strReqTp = CodeConstants.PRE_REQ_DOC_FORM_901;
			else strReqTp = CodeConstants.PRE_REQ_DOC_FORM_101;
		%>
			 <div class="mi_btn"><a href="javascript:PreReqDocView(formName,'<%= (String)objParams.getParamValue("ReqBoxID") %>', '<%= strReqTp %>')"><span>요구서 미리 보기</span></a></div>
		<%
			}//endif 요구서 미리보기 번튼 제어 끝.
		%>
			</div>
		 </div>
        <!-- /중단 버튼-->

        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
        <table>
		<tr><td>&nbsp;</td></tr>
		</table>



        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col" style="width:10px; ">
				<input name="checkAll" type="checkbox" value="" class="borderNo"onClick="checkAllOrNot(document.formName);" />
			  </th>
              <th scope="col"  style="width:20px; "><a>NO</a></th>
				<%
					int intTmpWidth1=490;
					if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
					  intTmpWidth1=intTmpWidth1-50;
					}//endif의원실소속확인
				%>
              <th scope="col" style="width:250px; "><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"요구제목")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"공개등급")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_STT",strReqInfoSortField,strReqInfoSortMtd,"상태")%></th>
			<%
				if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
			%>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","CMT_REQ_APP_FLAG",strReqInfoSortField,strReqInfoSortMtd,"위원회")%></th>
			<%
				}//endif의원실소속확인
			%>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"등록일시")%></th>
            </tr>
          </thead>
          <tbody>

	<%
		int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
		String strReqInfoID = "";
		String strCmtApplyValue = "Y";

		while(objRs.next()) {
			strReqInfoID = (String)objRs.getObject("REQ_ID");
			/** 위원회신청가능한지(Y) 아닌지 "" 결정*/
			if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))) strCmtApplyValue = "";
			else strCmtApplyValue="Y";
	 %>
            <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
              <td><input name="ReqInfoIDs" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo"/></td>
              <td><%= intRecordNumber %></td>
			<%
				int intTmpWidth2=490;
				if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
				  intTmpWidth2=intTmpWidth2-50;
				}//endif의원실소속확인
			%>
              <td style="text-align:left;"><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 40)+" ..."	 %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a>
			  </td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
              <td><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT"))%></td>
			<%
				if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
			%>
              <td><%=CodeConstants.getCmtRequestAppoint((String)objRs.getObject("CMT_REQ_APP_FLAG"))%></td>
			<%
				}//endif의원실소속확인
			%>
              <td><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
			<input type="hidden" name="ReqID" value="<%= strReqInfoID %>">
			<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
<%
		intRecordNumber--;
	} //endwhile
%>
	<%
		/*조회결과 없을때 출력 시작.*/
		if(objRs.getRecordSize()<1){
	%>
			<tr>
              <td colspan="7" align="center">등록된 요구정보가 없습니다.</td>
            </tr>
		<%
			}/*조회결과 없을때 출력 끝.*/
		%>
          </tbody>
        </table>
        <!-- /list -->
						<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>

       <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="gotoReqInfoSearch(formName);"/> </div>
        <!-- /리스트 내 검색
요구 등록

요구 이동

요구 삭제

요구 복사

		-->
			<span class="right">
	   <%//결재대기중(상신),기안대기중  상태에서는 요구함 수정,삭제,요구함 발송 버튼이 Disable되어있어야함.
		  //즉 작성중과 반려상태에석만 가능함.
		 if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009) ){
	   %>
			<span class="list_bt" onclick="javascript:gotoRegReqInfo();return false;"><a href="#">요구 등록</a></span>
		<%
		if(objRs.getRecordSize()>0){/**요구목록이있을경우만 출력*/
		%>
		<span class="list_bt" onclick="javascript:moveMemReqInfo(formName);return false;"><a href="#">요구 이동</a></span>
		<%
			}//endif
		%>
	   <%
			}//endif 요구항 상태 체크 끝.
	   %>
		<%//결재대기중(상신),기안대기중  상태에서는 요구함 수정,삭제,요구함 발송 버튼이 Disable되어있어야함.
		  //즉 작성중과 반려상태에석만 가능함.
		 if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
			if(objRs.getRecordSize()>0){/**요구목록이있을경우만 출력*/
		%>
		<span class="list_bt" onclick="javascript:delMemReqInfos(formName);return false;"><a href="#">요구 삭제</a></span>
		<% if(!objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) || !objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) { %>
			<% } %>
		<%
			}//endif
		}//endif 요구항 상태 체크 끝.
	   %>
		<%
			if(objRs.getRecordSize()>0){/**요구목록이있을경우만 출력*/
		%>
			<span class="list_bt" style="cursor:hand" onClick="copyMemReqInfo(document.formName);" alt="현재 요구의 복사본을 선택한 요구함에 생성합니다."><a>요구 복사</a></span>
		<%
			}//endif
		%>
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
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
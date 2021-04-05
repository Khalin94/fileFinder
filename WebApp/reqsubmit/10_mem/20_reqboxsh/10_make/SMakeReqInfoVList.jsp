<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>

<%
	MemRequestBoxDelegate reqDelegate = null;
	SMemReqBoxDelegate sReqDelegate = null;
	SMemReqInfoDelegate selfDelegate = null;
	AnsInfoDelegate ansDelegate = null;

	SMemReqInfoVListForm objParams = new SMemReqInfoVListForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

  	reqDelegate = new MemRequestBoxDelegate();
	sReqDelegate = new SMemReqBoxDelegate();
	selfDelegate = new SMemReqInfoDelegate();
	ansDelegate = new AnsInfoDelegate();

	// 넘어온 파라미터를 설정해서 필요할 ?? 쓰도록 하자
	// 요구함 관련
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqID = objParams.getParamValue("ReqID");

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
	
	//공개비공개 테스트
  String strOpenCL = request.getParameter("ReqOpenCL");
  System.out.println("kangthis logs SMakeReqInfoVList.jsp(strOpenCL) => " + strOpenCL);

	String strReqStt = null; // 요구 제출 여부 정보

	// 답변 개수 및 페이징 관련
	int intTotalRecordCount = 0;
	int intCurrentPageNum = 0;
	int intTotalPage = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  		out.println("해당 요구함을 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구 등록 정보를 SELECT 한다.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqID));
	    	// 요구 제출 여부 정보를 쒜팅!
	    	strReqStt = (String)objRsSH.getObject("REQ_STT");

	    	// 답변 목록을 SELECT 한다.
	    	objRs = new ResultSetHelper(ansDelegate.getRecordList(objParams));

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
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

<script language="javascript">
	var f;

	// 제출 완료
	function sbmtReq() {
		f = document.viewForm;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("현재 요구에 대한 답변 제출을 완료하시겠습니까?")) f.submit();
	}

	// 요구함 보기
	function goReqBoxView() {
		f = document.viewForm;
		f.target = "";
		f.action = "SMakeReqBoxVList.jsp";
		f.submit();
	}

	// 요구함 목록 조회
	function goReqBoxList() {
		f = document.viewForm;
		f.target = "";
		f.action = "SMakeReqBoxList.jsp";
		f.submit();
	}
    // 손성제 2012.2.13
    // 변경된 업로드 컴포넌트 에러시 gotoDetail-> gotoDetail_old//gotoDetail_old-> gotoDetail 변경
  	// 답변 상세보기로 가기
  	function gotoDetail(strAnsID){
  		f = document.viewForm;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strAnsID;
  		NewWindow('/blank.html', 'popwin', '618', '590');
  		f.submit();
  	}

    // 구버전 답변 상세보기로 가기
  	function gotoDetail_old(strAnsID){
  		f = document.viewForm;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView_old.jsp?AnsID="+strAnsID;
  		NewWindow('/blank.html', 'popwin', '520', '350');
  		f.submit();
  	}
    
    

    
 	// 기존 답변 작성 화면으로 이동
  	function goSbmtReqForm_test() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_before.jsp";	  	
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		//window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=yes,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=yes,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		f.submit();
  	}

  	// 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";		
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		//window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=yes,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=yes,location=no,toolbar=no,height=600,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
	function goSbmtReqForm2() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite2.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=no,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
    //구버전 답변 작성 화면
  	function goSbmtReqForm_old() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	// 선택 답변 삭제
  	function selectDelete() {
  		var f = document.viewForm;
  		f.target = "";
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
  		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
  	}

  	// 요구 중복 조회
  	function checkOverlapReq() {
  		var f2 = document.dupCheckForm;
  		f2.target = "popwin";
  		f2.action = "/reqsubmit/common/SReqOverlapCheck.jsp";
  		NewWindow('/blank.html', 'popwin', '500', '480');
  		f2.submit();
  	}

  	// 답변서 발송
	function sendAnsDoc() {
		var f = document.viewForm;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.ReturnURL.value = "/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
	}

	// 자동 답변서 발송 확인
	function checkSendAnsDoc() {
		if(confirm("모든 요구에 대한 답변을 등록하셨습니다. 답변서 발송을 진행하시겠습니까?")) sendAnsDoc();
	}
	
	// 페이징 바로가기
  	function goPage(strPage){
  		f = document.viewForm;
  		f.ReqInfoPage.value = strPage;
  		f.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqInfoVList.jsp";
  		f.target = "_self";
  		f.submit();
  	}
</script>
</head>

<body
<%
	int intNotSubmitReqCnt = sReqDelegate.getReqCntNotSubmit(strReqBoxID);
	int intRemaindReqCnt = sReqDelegate.checkReqInfoAnsIsNull(strReqBoxID);

	if(intNotSubmitReqCnt == 0 || intRemaindReqCnt == 0) {
		out.println(" onLoad='javascript:checkSendAnsDoc()'");
	}
%>
>
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
					<input type="hidden" name="ReqID" value="<%= strReqID %>"> <!-- 요구 ID -->
					<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--요구정보 목록정렬필드 -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--요구정보 목록정렬방법-->
					<% if(StringUtil.isAssigned(strReqInfoQryTerm)) { %>
					<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--요구정보 조회필드 -->
					<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- 요구정보 조회어 -->
					<% } %>
					<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- 요구정보 페이지 번호 -->
					<input type="hidden" name="ReqStt" value="<%= strReqStt %>">
					<input type="hidden" name="ReqOpenCL" value="<%= objRsSH.getObject("OPEN_CL") %>">

					<!-- 삭제 후 반환될 URL을 선택하기 위한 Parameter 설정 -->
					<input type="hidden" name="WinType" value="SELF">
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">

					<!-- 개별 답변 삭제를 위한 AnsID 설정 -->
					<input type="hidden" name="AnsID2" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></span></h3>
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
        <span class="list02_tl">요구 등록 정보 </span>
        <div class="top_btn"><samp>
		<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
			 <span class="btn"><a href="javascript:checkOverlapReq()">중복조회</a></span>
		<% } %>
			 <span class="btn"><a href="javascript:goReqBoxView()">요구함 보기</a></span>
			 <span class="btn"><a href="javascript:goReqBoxList()">요구함 목록</a></span>
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">요구 이력 보기</a></div>
        </samp></div>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25"">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%= objRsSH.getObject("REQ_CONT") %></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구기관 </th>
                <td height="25"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
                <th height="25">&bull;&nbsp;제출기관</th>
                <td height="25"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
                <td height="25"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                <th height="25">&bull;&nbsp;첨부파일</th>
                <td height="25"><%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %></td>
            </tr>
            <tr>
                <th height="25">&bull; 제출기한 </th>
                <td height="25"><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
                <th height="25">&bull;&nbsp;등록일자</th>
                <td height="25"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; 등록자 </th>
                <td height="25" width="32%"><%= objRsSH.getObject("USER_NM") %></td>
                <th height="25" width="18%">&bull;&nbsp;제출 여부</th>
                <td height="25" width="32%"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">* 모든 요구목록에 대해서 즉시제출 또는 답변작성 후 작성중요구함 > 해당 요구함 상세보기 화면의 답변서발송 버튼을&nbsp;눌러주시기 바랍니다.</p>
        
        <!-- 리스트 버튼-->
        <div id="btn_all">
        <div  class="t_right">
	  <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt) && intTotalRecordCount > 0) { %>
			 <div class="mi_btn"><a href="javascript:sbmtReq()"><span>즉시제출</span></a></div>
	  <% } %>
        </div>
		</div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <%-- <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 :  <%= intTotalRecordCount %>개 </span></span> --%>
        <span class="list01_tl">답변 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			<th scope="col">
			<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
			<input name="checkAll" type="checkbox" value="" class="borderNo" onClick="javascript:checkAllOrNot(viewForm)"/>
			<% } else { %>
			  No
			  <%	}	%>
			  </th>
              <th scope="col" width="250px;"><a>제출 의견</a></th>
              <th scope="col" width="50px;"><a>작성자</a></th>
              <th scope="col"><a>공개여부</a></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><a>작성일자</a></th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber= 0;
				if (intTotalRecordCount > 0) {
					while(objRs.next()){
			%>
            <tr>
              <td>
			  <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
				<input name="AnsID" type="checkbox" value="<%= objRs.getObject("ANS_ID") %>" class="borderNo"/>
			  <% } else { %>
			  <%=intRecordNumber+1%>
			  <%	}	%>
			  </td>
			  <td style="text-align:left;"><%= StringUtil.getNotifyImg((String)objRs.getObject("ANS_DT"), CodeConstants.REQ_STT_NOT) %><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
              <td><%= objRs.getObject("USER_NM") %></td>
              <td><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
            </tr>
			<%
						intRecordNumber++;
					} //endwhile
				} else {
			%>
			<tr>
				<td colspan="6" align="center">등록된 답변이 없습니다.</td>
            </tr>
			<%
					}
           	%>

<!--
	자료가 없을 경우
			<tr>
			 <td colspan="6"  align ="center"> 등록된 요구정보가 없습니다. </td>
            </tr>
-->
          </tbody>
        </table>
		<!--<p class="warning mt10">* PDF변환실패 시 "수동답변작성" 기능을 이용해 주시기 바랍니다. </p>--><br>
        <!-- /list -->
        <%=objPaging.pagingTrans(PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								"10"))%>

        <!-- 페이징
        <span class="paging" > <span class="list_num_on"><a href="#">1</a></span> <span class="list_num"><a href="#">2</a></span> <span class="list_num"><a href="#">3</a></span> <span class="list_num"><a href="#">4</a></span> <span class="list_num"><a href="#">5</a></span> </span>

         /페이징-->


       <!-- 리스트 버튼
        <div id="btn_all" >
		<!-- 리스트 내 검색 -->
<!--
		<div class="list_ser" >
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">요구제목</option>
            <option value="">요구내용</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
-->
        <!-- /리스트 내 검색  -->
			<span class="right">
                <!-- 손성제 2012.2.13-->
                <!-- 변경된 업로드 컴포넌트 에러시 goSbmtReqForm-> goSbmtReqForm_old 변경-->
				<%if (objUserInfo.getUserID().equals("0000039924")){%>
					<span class="list_bt"><a href="javascript:goSbmtReqForm2()">테스트</a></span>
				<%}%>
				<span class="list_bt"><a href="javascript:goSbmtReqForm_old()">답변작성</a></span>
                <span class="list_bt"><a href="javascript:selectDelete()">선택삭제</a></span>
				<span class="list_bt"><a href="javascript:goSbmtReqForm()">대용량파일등록</a></span>				
				
			</span>
		</div>

<!--         /리스트 버튼-->
        <!-- /각페이지 내용
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>

<form method="post" action="" name="dupCheckForm" style="margin:0px">
	<input type="hidden" name="queryText" value="<%= StringUtil.ReplaceString((String)objRsSH.getObject("REQ_CONT"), "'", "") %>">
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqID" value="<%= strReqID %>">
	<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=
<%= strReqBoxID %>&ReqID=<%= strReqID %>">
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>

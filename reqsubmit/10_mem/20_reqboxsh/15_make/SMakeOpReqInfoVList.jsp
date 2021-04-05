<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
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

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>


<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

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

	String strReqStt = null; // 요구 제출 여부 정보

	//공개비공개 테스트
    String strOpenCL = request.getParameter("ReqOpenCL");
    System.out.println("kangthis logs SMakeOpReqInfoVList.jsp(strOpenCL) => " + strOpenCL);

	// 답변 개수 및 페이징 관련
	int intTotalRecordCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("해당 요구자료를 볼 권한이 없습니다.");
  	  		out.println("해당 요구자료를 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구 등록 정보를 SELECT 한다.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqID));
	    	// 요구 제출 여부 정보를 쒜팅!
	    	strReqStt = (String)objRsSH.getObject("REQ_STT");

	    	// 답변 목록을 SELECT 한다.
	    	objRs = new ResultSetHelper(ansDelegate.getRecordList(objParams));

			intTotalRecordCount = objRs.getTotalRecordCount();
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
		f.action = "SMakeOpReqBoxVList.jsp";
		f.submit();
	}

	// 요구함 목록 조회
	function goReqBoxList() {
		f = document.viewForm;
		f.target = "";
		f.action = "SMakeOpReqBoxList.jsp";
		f.submit();
	}

  	// 답변 상세보기로 가기
  	function gotoDetail(strAnsID){
  		f = document.viewForm;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strAnsID;
  		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 550) / 2;
        window.open("/blank.html","popwin","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=no,location=no,toolbar=no,height=550,width=610, left="+winl+", top="+winh);
		f.submit();
  	}

  	// 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 550) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=no,location=no,toolbar=no,height=600,width=610, left="+winl+", top="+winh);
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
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
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

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > 국회의원 비전자 자료 요구 > <%=MenuConstants.REQ_BOX_MAKE%></div>
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
			 <span class="btn"><a href="javascript:goReqBoxView()">요구함보기</a></span>
			 <span class="btn"><a href="javascript:goReqBoxList()">요구함목록</a></span>
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">요구 이력 보기</a></span>
		</samp></div>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col">&bull;&nbsp;요구제목 </th>
				  <td colspan="3"><%= objRsSH.getObject("REQ_CONT") %>
     			  </td>
            </tr>

            <tr>
              <th scope="col">&bull;&nbsp;요구내용 </th>
			  <td colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구자료  </th>
			  <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;요구기관 </th>
			  <td><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
              <th scope="col">&bull;&nbsp;제출기관 </th>
			  <td><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;공개등급 </th>
			  <td><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
              <th scope="col">&bull;&nbsp;첨부파일 </th>
			  <td><%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;제출기한 </th>
			  <td><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
              <th scope="col">&bull;&nbsp;등록일자 </th>
			  <td><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;등록자 </th>
			  <td><%= objRsSH.getObject("USER_NM") %></td>
              <th scope="col">&bull;&nbsp;제출 여부 </th>
			  <td><%= CodeConstants.getRequestStatus(strReqStt) %></td>
            </tr>
        </table>
        <!-- /list view -->

		<!-- 답변서 발송 -->

        <!-- 리스트 버튼-->
<!--
요구함 목록, 바인딩, 요구서 보기, 답변서 미리 보기, 답변서 발송, 오프라인 제출
-->
         <div id="btn_all">
         <div  class="t_right">
         &nbsp;
         </div>
		 </div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">답변 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개</span></span>
        <table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
			  <th scope="col"><input name="checkAll" type="checkbox" onClick="javascript:checkAllOrNot(viewForm)" class="borderNo" /></th>
			<% } %>
              <th scope="col" style="width:40%; "><a>제출 의견</a></th>
              <th scope="col"><a>작성자</a></th>
              <th scope="col"><a>공개등급</a></th>
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
			<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
              <td><input name="AnsID" type="checkbox" value="<%= objRs.getObject("ANS_ID")%>"  class="borderNo"/></td>
			<% } else { %>
				<%= intRecordNumber+1 %>
			<% } %>
              <td><%= StringUtil.getNotifyImg((String)objRs.getObject("ANS_DT"), CodeConstants.REQ_STT_NOT) %><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
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
				<td colspan="6" align="center">  등록된 답변이 없습니다.</td>
			</tr>
		<%
			}
		%>
          </tbody>
        </table>
        <!-- /list -->

        <!-- 페이징-->

        <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <!-- /리스트 내 검색 -->
			<span class="right">
<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
			<span class="list_bt"><a href="javascript:goSbmtReqForm()">추가답변작성</a></span>
			<span class="list_bt"><a href="javascript:selectDelete()">선택삭제</a></span>
<% } %>
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
</form>
<form method="post" action="" name="dupCheckForm" style="margin:0px">
	<input type="hidden" name="queryText" value="<%= StringUtil.ReplaceString((String)objRsSH.getObject("REQ_CONT"), "'", "") %>">
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqID" value="<%= strReqID %>">
	<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=
<%= strReqBoxID %>&ReqID=<%= strReqID %>">
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
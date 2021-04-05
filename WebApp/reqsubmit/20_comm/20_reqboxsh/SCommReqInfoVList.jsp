<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SCommReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	SCommReqInfoVListForm objParams = new SCommReqInfoVListForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

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
	String strReqStt = "";

	// 답변 개수 및 페이징 관련
	int intTotalRecordCount = 0;

 	SCommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;
	ResultSetHelper objRsAns = null;

	try{
   objReqBox=new SCommRequestBoxDelegate();
   /**요구함 이용 권한 체크 */


	// 요구 정보를 SELECT 한다.
	objRsSH = new ResultSetSingleHelper(objAnsInfo.getReqRecord(strReqID));
	// 요구 제출 여부 정보를 쒜팅!
	strReqStt = (String)objRsSH.getObject("REQ_STT");
	// 답변 목록을 SELECT 한다.
	String strRefReqID = (String)objRsSH.getObject("REF_REQ_ID");
	objRs = new ResultSetHelper(objAnsInfo.getRecordList(strReqID));
	intTotalRecordCount = objRs.getTotalRecordCount();
	// 제출 정보 목록을 SELECT 한다.
	objRsAns = new ResultSetHelper(objAnsInfo.getRecordList((String)objRsSH.getObject("REF_REQ_ID")));

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
		f.action = "./SCommReqBoxVList.jsp";
		f.target = "";
		f.submit();
	}

	// 요구함 목록 조회
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxList.jsp";
		f.target = "";
		f.submit();
	}

  	// 답변 상세보기로 가기
  	function gotoDetail(strAnsID){
  		f = document.viewForm;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strAnsID;
  		NewWindow('/blank.html', 'popwin', '618', '590');
  		//window.open('about:blank', 'popwin', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  		f.submit();
  	}

  	// 답변 작성 화면으로 이동
  	function gotoNewAns() {
		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=no,location=no,toolbar=no,height=600,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
  	// 답변 작성 화면으로 이동
  	function gotoNewAns_old() {
		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no,	scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	// 공식제출 화면으로 이동
  	function gotoCommAns() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "RefAnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}
  		f.action = "SCommAnsWriteProc.jsp";
		f.target = "";
  		f.submit();
  	}

  	// 선택 답변 삭제
  	function gotoDelAns() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
		f.target = "";
  		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
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
    <div id="contents">
			<form name="viewForm" method="post" action="" style="margin:0px">
			<!-- 요구함 등록 정보 관련 -->
			<input type="hidden" name="CmtOrganID" value="<%=request.getParameter("CmtOrganID")%>">
			<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
			<input type="hidden" name="ReqID" value="<%= strReqID %>">
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
			<input type="hidden" name="ReqOpenCL" value="<%= (String)objRsSH.getObject("OPEN_CL") %>">
			<!-- 삭제 후 반환될 URL을 선택하기 위한 Parameter 설정 -->
			<input type="hidden" name="returnURL" value="SELF">
		    <input type="hidden" name="WinType" value="SELF">
		    <input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">
		    <input type="hidden" name="WriteURL" value="<%=request.getRequestURI()%>">
			<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="ReqStt" value="<%=strReqStt%>">
            <input type="hidden" name="ReturnURLFLAG" value="CMT">

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--문구--></p>
      </div>
      <div id="contents">


        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구 등록 정보 </span>
        <div class="top_btn"><samp>
        <!-- 요구함 보기 -->
			 <span class="btn"><a href="javascript:goReqBoxView();">요구함 보기</a></span>
			  <!-- 요구함 목록 -->
			 <!--span class="list_bt"><a href="javascript:goReqBoxList();">요구함 목록</a></span-->
			 <!-- 요구 이력 조회 -->
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>');">요구 이력 조회</a></span>
		</samp></div>


			<table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
			<tr>
                <th height="25">&bull; 요구제목</th>
		  		<td height="25" colspan="3"><strong><%= objRsSH.getObject("REQ_CONT") %></strong></td>
			</tr>
						<tr>
                <th height="25">&bull; 요구내용</th>
		  		<td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %></td>
			</tr>
			<tr>
                <th height="25">&bull; 요구함명</th>
		  		<td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
			</tr>
			<tr>
                <th height="25" width="18%">&bull; 소관 위원회</th>
		  		<td height="25" width="32%"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
                <th height="25" width="18%">&bull; 제출 여부</th>
		  		<td height="25" width="32%"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
			</tr>
			<tr>
                <th height="25">&bull; 요구기관</th>
		  		<td height="25"><%= objRsSH.getObject("REQ_ORGAN_NM") %> (<%= objRsSH.getObject("REGR_NM") %>)</td>
                <th height="25">&bull; 제출기관</th>
		  		<td height="25"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
			</tr>
			<tr>
                <th height="25">&bull; 제출기한</th>
		  		<td height="25"><strong><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</strong></td>
                <th height="25">&bull; 요구일자</th>
		  		<td height="25"><strong><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></strong></td>
			</tr>
			<tr>
                <th height="25">&bull; 공개등급</th>
		  		<td height="25"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                <th height="25">&bull; 첨부파일</th>
		  		<td height="25"><%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %></td>
			</tr>
			</table>
            <p class="warning mt10">* 모든 요구목록에 대해서 즉시제출 또는 답변작성 후 작성중요구함 > 해당 요구함 상세보기 화면의 답변서발송 버튼을&nbsp;눌러주시기 바랍니다.</p>
        <!-- 리스트 버튼-->
         <div id="btn_all"><div  class="t_right">
	  <% if(!strReqSubmitFlag.equals("004") && !CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt) && intTotalRecordCount > 0) { %>
			 <div class="mi_btn"><a href="javascript:sbmtReq();"><span>즉시제출</span></a></div>
	  <% } %>
		 </div></div>
        <!-- /리스트 버튼-->
        <!-- list -->
        <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 :  <%= intTotalRecordCount %>개 </span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>

			<!------------------------------------------------- 답변 목록 테이블 시작 ------------------------------------------------->
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
			<%
			Vector vct = new Vector();
  			if(objRs.getRecordSize() > 0){
				while(objRs.next()){
				String strRefAnsID = (String)objRs.getObject("REF_ANS_ID");
					if(!strRefAnsID.equalsIgnoreCase("")){
						vct.add(strRefAnsID);
					}
			%>

			<tr>
				<td>
			  	<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
   	          		<input type="checkbox" name="AnsID" value="<%= objRs.getObject("ANS_ID") %>">
   	          	<% } %>
				</td>
				<td style="text-align:left;"><%= StringUtil.getNotifyImg((String)objRs.getObject("ANS_DT"), CodeConstants.REQ_STT_NOT) %><a href="javascript:gotoDetail('<%=objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
				<td><%= objRs.getObject("ANSR_NM") %></td>
                <td><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
				<td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
				<td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
			</tr>
			<%
				} //endwhile
			} else {
			%>
			<tr>
				<td colspan="7" height="40" align="center">등록된 답변정보가 없습니다.</td>
			</tr>
			<%	}	%>
			</table>

            <span class="right">
			  	<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
                    <span class="list_bt"><a href="javascript:gotoNewAns_old()">답변작성</a></span>
					<span class="list_bt"><a href="javascript:gotoNewAns()">대용량파일등록</a></span>
    				<span class="list_bt"><a href="javascript:gotoDelAns()">선택삭제</a></span>
   	          	<% } %>
            </span>
		<%
		if(objRsAns.getRecordSize() > 0) {
		%>
		<!----- 제출 정보 목록 -------->
			<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
			<table border="0" cellpadding="0" cellspacing="0" width="759">
			<tr>
				<td width="300" class="soti_reqsubmit">
				<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
				기제출 자료 목록</td>
				<td width="459" align="right" valign="bottom">
				<!------------------------- COUNT (PAGE) ------------------------------------>
				</td>
			</tr>
			</table>
			<!------------------------------------------------- 제출 정보 목록 테이블 시작 ------------------------------------------------->
			<table width="759" border="0" cellspacing="0" cellpadding="0">
			<tr>
		  		<td height="2" colspan="7" class="td_reqsubmit">기존에 제출하신 자료가 있습니다.<br>
			첨부된 답변자료를 참조하여 재작성 하시거나 수정사항이 없으면 아래의 [위원회 제출]버튼을 클릭하여 등록 하실 수 있습니다.</td>
			</tr>
			<tr align="center" class="td_top">
			  	<td width="64" height="22">
			  	<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
						<input type="checkbox" name="" value="" onClick="javascript:revCheck(this.form, 'RefAnsID')">
				<% } %>
				</td>
				<td width="335" height="22">제출 의견</td>
			  	<td width="80">작성자</td>
			  	<td width="80">작성일</td>
			  	<td width="150">답변</td>
			</tr>
			<tr>
			  	<td height="1" colspan="7" class="td_reqsubmit"></td>
			</tr>
			<%
			int intRefNumber= 0;
			while(objRsAns.next()){
			%>
			<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
				<td height="20" align="center">
				<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요
					if(!vct.contains(objRsAns.getObject("ANS_ID"))){ %>
				   	<input type="checkbox" name="RefAnsID" value="<%= objRsAns.getObject("ANS_ID") %>">
				<% }
				}%></td>
				<td class="td_lmagin" height="20"><a href="javascript:gotoDetail('<%= objRsAns.getObject("ANS_ID") %>')"><%= objRsAns.getObject("ANS_OPIN") %></a></td>
				<td align="center"><%= objRsAns.getObject("ANSR_NM") %></td>
				<td align="center"><%= StringUtil.getDate((String)objRsAns.getObject("ANS_DT")) %></td>
				<td align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRsAns.getObject("ANS_ID"), (String)objRsAns.getObject("ANS_MTD")) %></td>
			</tr>
			<tr class="tbl-line">
			  	<td height="1" colspan="7"></td>
			</tr>
			<%
				intRefNumber++;
			} //endwhile
			%>
			<tr class="tbl-line">
			  	<td height="1" colspan="7"></td>
			</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
		  		<td width="300" height="40">
  				<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
				<%
				if(!strReqSubmitFlag.equals("004")){
					if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요
						if(!vct.contains(objRsAns.getObject("ANS_ID"))){ %>
					   	<img src="/image/button/bt_committeeSubmit.gif" height="20" style="cursor:hand" onClick="gotoCommAns();" alt="신청함에 있는 요구정보를 위원회명의로 보내기위해 제출신청합니다.">
					<% }
				}	}%>
  				</td>
  				<td width="459" align="right" valign="middle">
			  	</td>
			</tr>
		  	</table>
			</td>
		</tr>
		<%
		}
		%>
        <tr>
        	<td height="35px"></td>
        </tr>
		</table>
</form>
        </div>

<!--         /리스트 버튼-->
        <!-- /각페이지 내용
      </div>
      <!-- /contents -->

    </div>
  </div>
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